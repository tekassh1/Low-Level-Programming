#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <semaphore.h>
#include <unistd.h>

void* create_shared_memory(size_t size) {
    return mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
}

void print_arr(int* arr) {
    for (int i = 0; i < 10; i++) printf("%d ", arr[i]);
}

void change_arr(int* arr, int idx, int value) {
    arr[idx] = value;
}

int main() {
    void* shmem = create_shared_memory(sizeof(int) * 10);    
    printf("Shared memory at: %p\n" , shmem);
    int* arr = (int*) shmem;
    for (int i = 0; i < 10; i++) arr[i] = i+1;

    int pid = fork();

    if (pid == 0) {
        int idx, val;
        scanf("%d", &idx);
        scanf("%d", &val);
        arr[idx] = val;
    } else {
        sleep(5);
        for (int i = 0; i < 10; i++) printf("%d ", arr[i]);
        printf("\n");
    }
}