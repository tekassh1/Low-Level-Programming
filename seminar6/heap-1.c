#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#define new_max(x,y) (((x) >= (y)) ? (x) : (y))

#define HEAP_BLOCKS 16
#define BLOCK_CAPACITY 1024

enum block_status {BLK_FREE = 0, BLK_ONE, BLK_FIRST, BLK_CONT, BLK_LAST};

struct heap {
  struct block {
    char contents[BLOCK_CAPACITY];
  } blocks[HEAP_BLOCKS];
  enum block_status status[HEAP_BLOCKS];
} global_heap = {0};

struct block_id {
  size_t       value;
  bool         valid;
  struct heap* heap;
};

struct block_id block_id_new(size_t value, struct heap* from) {
  return (struct block_id){.valid = true, .value = value, .heap = from};
}
struct block_id block_id_invalid() {
  return (struct block_id){.valid = false};
}

bool block_id_is_valid(struct block_id bid) {
  return bid.valid && bid.value < HEAP_BLOCKS;
}

/* Find block */

bool block_is_free(struct block_id bid) {
  if (!block_id_is_valid(bid))
    return false;
  return bid.heap->status[bid.value] == BLK_FREE;
}

/* Allocate */
struct block_id block_allocate(struct heap* heap, size_t size) {
    size_t max_free = 0;
    size_t start_id = 0;
    size_t counter = 0;

    bool started = false;

    for (size_t i = 0; i < HEAP_BLOCKS; i++) {
        if (heap->status[i] == BLK_FREE) {
            if (started == false) {
                started = true;
                start_id = i;
            }
            counter++;
            max_free = new_max(counter, max_free);
            if (max_free >= size)
                break;
        }
        else if (heap->status[i] != BLK_FREE && started == true) {
            started = false;
            counter = 0;
        }
    }

    if (max_free < size) return block_id_invalid();
    if (size == 1) {
        heap->status[start_id] = BLK_ONE;
    }
    else {
        for (size_t i = start_id; i < (start_id + size); i++) {
            if (i == start_id) heap->status[i] = BLK_FIRST;
            else if (i == start_id + size - 1) heap->status[i] = BLK_LAST;
            else heap->status[i] = BLK_CONT;
        }
    }
    return (struct block_id) {.heap = heap, .valid = true, .value = start_id};
}

void block_free(struct block_id b) {
    size_t curr_id = b.value;
    if (b.heap->status[curr_id] == BLK_ONE) {
        b.heap->status[curr_id] = BLK_FREE;
        return;
    }
    while (b.heap->status[curr_id] != BLK_LAST) {
        b.heap->status[curr_id] = BLK_FREE;
        curr_id++;
    }
    b.heap->status[curr_id] = BLK_FREE;
    return;
}

/* Printer */
const char* block_repr(struct block_id b) {
  static const char* const repr[] = {[BLK_FREE] = " .",
                                     [BLK_ONE] = " *",
                                     [BLK_FIRST] = "[=",
                                     [BLK_LAST] = "=]",
                                     [BLK_CONT] = " ="};
  if (b.valid)
    return repr[b.heap->status[b.value]];
  else
    return "INVALID";
}

void block_debug_info(struct block_id b, FILE* f) {
  fprintf(f, "%s", block_repr(b));
}

void block_foreach_printer(struct heap* h, size_t count,
                           void printer(struct block_id, FILE* f), FILE* f) {
  for (size_t c = 0; c < count; c++)
    printer(block_id_new(c, h), f);
}

void heap_debug_info(struct heap* h, FILE* f) {
  block_foreach_printer(h, HEAP_BLOCKS, block_debug_info, f);
  fprintf(f, "\n");
}
/*  -------- */

int main() {
    heap_debug_info(&global_heap, stdout);
    struct block_id b = block_allocate(&global_heap, 1);
    heap_debug_info(&global_heap, stdout);
    block_free(b);
    heap_debug_info(&global_heap, stdout);

    return 0;
}