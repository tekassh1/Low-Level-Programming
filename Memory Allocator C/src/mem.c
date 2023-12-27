#define _DEFAULT_SOURCE

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "mem_internals.h"
#include "mem.h"
#include "util.h"

#define BLOCK_MIN_CAPACITY 24

void debug_block(struct block_header* b, const char* fmt, ... );
void debug(const char* fmt, ... );

extern inline block_size size_from_capacity( block_capacity cap );
extern inline block_capacity capacity_from_size( block_size sz );

static bool            block_is_big_enough( size_t query, struct block_header* block ) { return block->capacity.bytes >= query; }
static size_t          pages_count   ( size_t mem )                      { return mem / getpagesize() + ((mem % getpagesize()) > 0); }
static size_t          round_pages   ( size_t mem )                      { return getpagesize() * pages_count( mem ) ; }

static void block_init( void* restrict addr, block_size block_sz, void* restrict next ) {
	*((struct block_header*)addr) = (struct block_header) {
	  .next = next,
	  .capacity = capacity_from_size(block_sz),
	  .is_free = true
	};
}

static size_t region_actual_size( size_t query ) { return size_max( round_pages( query ), REGION_MIN_SIZE ); }

extern inline bool region_is_invalid( const struct region* r );

static void* map_pages(void const* addr, size_t length, int additional_flags) {
	return mmap( (void*) addr, length, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | additional_flags , -1, 0 );
}

/* аллоцировать регион памяти и инициализировать его блоком */
static struct region alloc_region(void const * addr, size_t query) {
	query = region_actual_size(query + offsetof(struct block_header, contents));
	void* allocated_region = map_pages(addr, query, MAP_FIXED_NOREPLACE);

	bool extends = true;

	if (allocated_region == MAP_FAILED) {
		extends = false;
		allocated_region = map_pages(addr, query, 0);
		if (allocated_region == MAP_FAILED) return (struct region) {.addr = NULL};
	}

	block_init(allocated_region, (block_size) {.bytes = query}, NULL);
	return (struct region) {.addr = allocated_region, .size = query, .extends = extends};
}

static void* block_after( struct block_header const* block )         ;

void* heap_init(size_t initial) {
	const struct region region = alloc_region( HEAP_START, initial );
	if (region_is_invalid(&region)) return NULL;	
	return region.addr;
}

/*  --- Разделение блоков (если найденный свободный блок слишком большой )--- */

static bool block_splittable( struct block_header* 
 block, size_t query) {
	return block-> is_free && query + offsetof( struct block_header, contents ) + BLOCK_MIN_CAPACITY <= block->capacity.bytes;
}

static bool split_if_too_big( struct block_header* block, size_t query ) {
	if (!block_splittable(block, query)) return false;
	query = query < BLOCK_MIN_CAPACITY ? BLOCK_MIN_CAPACITY : query;

	block_size original_size = size_from_capacity(block->capacity);
	block_capacity new_capacity = (block_capacity) {.bytes = query};
	block_size new_size = size_from_capacity(new_capacity);

	struct block_header* next_splitted_block_pointer = (struct block_header*) ((uint8_t*) block + new_size.bytes);
	struct block_header* original_next_block = block->next;

	block_init(
		block, 
		new_size, 
		next_splitted_block_pointer
	);
	block_init(
		next_splitted_block_pointer, 
		(block_size) { .bytes = original_size.bytes - new_size.bytes}, 
		original_next_block
	);

	return true;
}

/*  --- Слияние соседних свободных блоков --- */

static void* block_after ( struct block_header const* block ) {
	return (void*) block->contents + block->capacity.bytes;
}

static bool blocks_continuous (struct block_header const* fst,
                               struct block_header const* snd) {
	return (void*)snd == block_after(fst);
}

static bool mergeable(struct block_header const* restrict fst, struct block_header const* restrict snd) {
	return fst->is_free && snd->is_free && blocks_continuous( fst, snd ) ;
}

static bool try_merge_with_next( struct block_header* block ) {
	if (!block || (!block->next)) return false;
	if (!mergeable(block, block->next)) return false;

	struct block_header* next_after_merge = block->next->next;

	block_size merged_size = (block_size) {
		.bytes = size_from_capacity(block->capacity).bytes + size_from_capacity(block->next->capacity).bytes
	};

	block_init(
		block,
		merged_size,
		next_after_merge
	);

	return true;
}

/*  --- ecли размера кучи хватает --- */

struct block_search_result {
	enum {BSR_FOUND_GOOD_BLOCK, BSR_REACHED_END_NOT_FOUND, BSR_CORRUPTED} type;
	struct block_header* block;
};

static struct block_search_result find_good_or_last ( struct block_header* restrict block, size_t sz ) {
	if (!block) return (struct block_search_result) {.type = BSR_CORRUPTED};

	struct block_header* last = block;

	while (block) {
		if (!block->is_free) {
			block = block->next;
			continue;
		}
	
		while (try_merge_with_next(block)) {};

		if (block_is_big_enough(sz, block)) {
			return (struct block_search_result) {.block = block, .type = BSR_FOUND_GOOD_BLOCK};
		}
		last = block;
		block = block->next;
	}
	return (struct block_search_result) {.block = last, .type = BSR_REACHED_END_NOT_FOUND};
}

/*  Попробовать выделить память в куче начиная с блока `block` не пытаясь расширить кучу
 Можно переиспользовать как только кучу расширили. */
static struct block_search_result try_memalloc_existing ( size_t query, struct block_header* block ) {
	struct block_search_result new_block_result = find_good_or_last(block, query);
	if (new_block_result.type == BSR_CORRUPTED || new_block_result.type == BSR_REACHED_END_NOT_FOUND)
		return new_block_result;
	
	split_if_too_big(new_block_result.block, query);
	new_block_result.block->is_free = false;

	return new_block_result;
}

static struct block_header* grow_heap(struct block_header* restrict last, size_t query) {
	if (last == NULL) return NULL;
	struct region newly_allocated = alloc_region(block_after(last), query);
	if (newly_allocated.addr == NULL) return NULL;

	last->next = newly_allocated.addr;

	if (newly_allocated.extends)
		if (try_merge_with_next(last))
			return last;
	
	return last->next;
}

/*  Реализует основную логику malloc и возвращает заголовок выделенного блока */
static struct block_header* memalloc( size_t query, struct block_header* heap_start) {
	if (heap_start == NULL) return NULL;
	query = query < BLOCK_MIN_CAPACITY ? BLOCK_MIN_CAPACITY : query;

	struct block_search_result result = try_memalloc_existing(query, heap_start);

	if (result.type == BSR_CORRUPTED) {
		return NULL;
	}
	if (result.type == BSR_FOUND_GOOD_BLOCK) {
		return result.block;
	}
	
	block_capacity capacity = {.bytes = query};
	if (!grow_heap(result.block, size_from_capacity(capacity).bytes)) 
		return NULL;

	return try_memalloc_existing(query, heap_start).block;
}

void* _malloc( size_t query ) {
	struct block_header* const addr = memalloc( query, (struct block_header*) HEAP_START );
	if (addr) return addr->contents;
	else return NULL;
}

static struct block_header* block_get_header(void* contents) {
	return (struct block_header*) (((uint8_t*)contents)-offsetof(struct block_header, contents));
}

/*  освободить всю память, выделенную под кучу */

struct block_header* unmap_from_pointer(struct block_header* curr_header) {
	size_t len_to_unmap = 0;
	struct block_header* start = curr_header;

	while (curr_header->next && blocks_continuous(curr_header, curr_header->next)) {
		len_to_unmap += size_from_capacity(curr_header->capacity).bytes;
		curr_header = curr_header->next;
	}
	len_to_unmap += size_from_capacity(curr_header->capacity).bytes;

	struct block_header* next = curr_header->next;
	munmap(start, round_pages(len_to_unmap));

	return next;
}

void heap_term() {
	struct block_header* curr_header = HEAP_START;
	while (curr_header != NULL)
		curr_header = unmap_from_pointer(curr_header);
}

void _free( void* mem ) {
	if (!mem) return;
	struct block_header* header = block_get_header( mem );
	header->is_free = true;
	while (try_merge_with_next(header)) {
		printf("a");
	};
}