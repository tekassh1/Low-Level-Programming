#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <semaphore.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/fcntl.h>

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
    
    sem_t *child, *parent;
    parent = sem_open("parent", O_CREAT, 644, 0);
    child = sem_open("child", O_CREAT, 644, 0);

    int pid = fork();

    if (pid == 0) {
        int idx, val;
        while (true) {
            scanf("%d", &idx);
            scanf("%d", &val);

            change_arr(arr, idx, val);
            sem_post(child);
            sem_wait(parent);
        }
    } 
    else {
        while (true) {
            sem_wait(child);
            for (int i = 0; i < 10; i++) printf("%d ", arr[i]);
            sem_post(parent);
            printf("\n");
        }
    }
}