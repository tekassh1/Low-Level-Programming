#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/wait.h>

typedef struct exchange_data {
    bool finished;
    int arr[10];
} exchange_data;

int main() {
    int pipes[2][2];
    pipe(pipes[0]);
    pipe(pipes[1]);

    int pid = fork();

    if (pid == 0) {
        int to_parent_pipe = pipes[0][1];
        int from_parent_pipe = pipes[1][0];
        close(pipes[0][0]);
        close(pipes[1][1]);

        int arr[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

        while (true)
        {
            int input;
            scanf("%d", &input);
            if (input < 0) break;
            arr[input] *= 2;

            exchange_data data = {.finished = false};
            memcpy(data.arr, arr, sizeof(arr));

            write(to_parent_pipe, &data, sizeof(data));
        }

        exchange_data break_data = {.finished = true};
        write(to_parent_pipe, &break_data, sizeof(break_data));
        close(pipes[0][1]);
        close(pipes[1][0]);
    }
    else {
        int to_child_pipe = pipes[1][1];
        int from_child_pipe = pipes[0][0];
        close(pipes[0][1]);
        close(pipes[1][0]);

        exchange_data child_message;
        while (read(from_child_pipe, &child_message, sizeof(exchange_data)) && child_message.finished != true) {
            for (size_t i = 0; i < 10; i++) printf("%d ", child_message.arr[i]);
            printf("\n");
        }
        close(pipes[1][1]);
        close(pipes[0][0]);
    }
}