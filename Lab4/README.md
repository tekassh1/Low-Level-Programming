# Assignment: Memory allocator

Project: memory allocator

# Memory allocator

We have already used the memory allocator many times, which is part of the standard C library. 
It is handled through the `malloc` and `free` functions (as well as `calloc` and `realloc`).
To get a better feel for its structure, we will write our own simplified version of the allocator.

# Zero approximation

The memory allocator allows you to request blocks of arbitrary size, and then it can return those blocks to reuse memory.

The allocator reserves a large region of memory with `mmap`. It partitions it into blocks with headers; the headers form a linked list. 
The header indicates whether the block is free, its size, and who its next block is.

- `malloc(size_t n)` : ищем свободный блок размера не меньше `n` и делим его на два блока:
   - блок размера $`n`$
   - оставшаяся часть
   
   As we search, we merge neighboring free blocks into free blocks of larger size.
- When freeing memory, we mark a block as unoccupied and merge it with the next block as long as possible (as long as both the current and the next block are free and
  the next block as long as possible (as long as both the current and the next block are free and
  as long as the next block is in memory immediately after the current block).
- If a large memory area runs out, we reserve more memory. At first
  we try to do it closely, right after the last block, but if we fail &mdash; allow more memory to be reserved.
  &mdash; we let `mmap` choose a suitable address to start a new
  region.
 


# First approximation

Let's imagine a rather large memory region that we allocate to the heap. Let's call it a *region*.
Let's partition the region into blocks; each block starts with a header, followed immediately by data.

```
|___header1____|____data1___||___header2____|____data2___||___header3____|____...
```

Blocks fill the entire space of the region. 

## Header 

The block header contains a link to the next block and a note about the status of the block (occupied or free).

```c
/* mem_internals.h */

typedef struct { size_t bytes; } block_capacity;

struct block_header {
  struct block_header*    next;
  block_capacity capacity;
  bool           is_free;
  uint8_t        contents[];  // flexible array member
};
```
The heap is specified by a reference to the first block header.

## Size and Capacity

Each unit has two characteristics: *size* and *capacity*. In order not to confuse them, we will create two types for them

```c
/* mem_internals.h */
typedef struct { size_t bytes; } block_capacity;
typedef struct { size_t bytes; } block_size;
```

The size of a block is always `offsetof(struct block_header, contents)` larger than its capacity.

```c
/* mem_internals.h */
inline block_size size_from_capacity( block_capacity cap ) { 
   return (block_size) {cap.bytes + offsetof( struct block_header, contents ) }; 
}
inline block_capacity capacity_from_size( block_size sz ) { 
   return (block_capacity) {sz.bytes - offsetof( struct block_header, contents ) }; 
}
```

- The header stores the capacity of the block, not its total size together with the header.
- You cannot use `sizeof( struct block_header )` because the structure size will be larger due to alignment. On the author's machine, for example, the structure size was 24, and `offsetof( struct block_header, contents ) == 17`, which is correct.

## Algorithm `malloc(n)`.

- We search through the blocks until we find a "good" block.
A good block &mdash; one that can hold `n` bytes.
- If no good block is found, see the second approximation.
- A good block may be too big, say we need to allocate 20 bytes and its size is 30 megabytes. Then we split the block into two parts: the first block will have `20 + offsetof( struct block_header, contents ) ` bytes.
  The address of the contents of this block is what `malloc` will return.

## Algorithm `free(void* addr)`.

- If `addr == NULL`, then we do nothing. 
- We need to get from `addr` (which points to the beginning of the `contents` field) the address of the beginning of the header (for this we subtract `sizeof(struct mem)` from it).
  In the block header set `is_free = true`, that's it.


# Second approximation

We now describe a few more aspects of allocation.

- what to do with a large number of consecutive free blocks?
- how to avoid too small blocks?
- what to do if the heap runs out of memory?
- how to free the memory allocated for the heap?


## Algorithm `malloc(n)`.

- It makes no sense to allocate a block of size, say 1 byte; even its header will take up more space.
  Let the minimum capacity of a block be denoted as follows:
  ```c
    #define BLOCK_MIN_CAPACITY 24
  ```

  Blocks that are too small can be formed in two cases:
  - `n < BLOCK_MIN_CAPACITY`. Then we will not request a block of size `n` but of size `BLOCK_MIN_CAPACITY`.
  - We have found a good block, and its size is slightly larger than `n`. If we divide the block into two parts, the capacity of the second part is smaller than `BLOCK_MIN_CAPACITY`. We will not divide such blocks, but give the block as a whole.
  
- When searching for a good block, we go through the blocks of the heap. Before deciding whether a block is good or not, we merge it with all the free blocks following it.
- If the heap runs out of memory, we need to expand the heap. For this purpose, we will use the `mmap` system call. Be sure to read `man` to understand what arguments (`prot` and `flags`) to call it with!
  
  - First, you should try to allocate memory close to the end of the heap and partition it into one big free block. If the last block in the first region of the heap was free, you should merge it with the next one.
  - If you fail to allocate the region close to the end of the heap, you should allocate the region "wherever you can". The last block of the previous region will be connected to the first block of the new region. 
 
 
## Algorithm `free(void* addr)`

- In addition to what has already been written about `free`, when you free a block, you can merge it with all the free blocks following it.

## Algorithm `heap_term(void)`

- To complete the allocator it is necessary to go through all memory regions allocated earlier with `mmap` and call `munmap` for them.
