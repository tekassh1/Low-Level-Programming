#include <stdio.h>

#define print_var(x) printf(#x " is %d \n", x )

int main() {
    int a = 1;
    const int b = 3;

    print_var(a);
    print_var(42);
    print_var(b);
}