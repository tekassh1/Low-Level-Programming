#include <stdio.h>
#include "asm_headers.h"

int main() {
    char input[255];

    print_string("Please, enter filename: ");

    if (scanf("%s", input) > 0) {
        putchar('\n');

        print_file(input);
        putchar('\n');
        return 0;
    }
    else {
        return 1;
    }
}