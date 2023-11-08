/* generic_list.c */

#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdio.h>

void int64_t_list_add(int64_t x);
void double_list_add(double x);
void int_list_add(int x);

#define _print(type, x) type##_print(x)

void int64_t_print(int64_t i) { printf("%" PRId64 " ", i); }
void double_print(double d) { printf("%lf ", d); }

#define DEFINE_LIST(type)                                               \
    struct list_##type {                                                \
        type value;                                                     \
        struct list_##type* next;                                       \
    };                                                                  \
                                                                        \
    struct list_##type* create_##type##_node() {                        \
        return malloc(sizeof(struct list_##type));                      \
    };                                                                  \
                                                                        \
    void list_##type##_push (struct list_##type* list, type val) {      \
        struct list_##type* ptr = list;                                 \
        while (ptr -> next != NULL) ptr = ptr -> next;                  \
        ptr -> next = create_##type##_node();                           \
        ptr -> next -> value = val;                                     \
        ptr -> next -> next = NULL;                                     \
    };                                                                  \
                                                                        \
    void list_##type##_print (struct list_##type* list) {               \
        struct list_##type* ptr = list;                                 \
        while (ptr != NULL) {                                           \
            _print(type, ptr -> value);                                 \
            ptr = ptr->next;                                            \
        }                                                               \
    }

#define list_push(list, x)                                           \
_Generic((list),                                                     \
        struct list_int64_t* : list_int64_t_push(list, x),           \
        struct list_double* : list_double_push(list, x),             \
        default : error("Unsupported operation"))                    \

#define list_print(list)                                             \
_Generic((list),                                                     \
        struct list_int64_t* : list_int64_t_print (list),            \
        struct list_double* : list_double_print (list),              \
        default : error("Unsupported operation"))                    \

DEFINE_LIST(int64_t);
DEFINE_LIST(double);

int main() {
    struct list_int64_t* int64_t_list = create_int64_t_node();
    struct list_double* double_list = create_double_node();

    list_push(int64_t_list, 1);
    list_push(int64_t_list, 2);
    list_push(int64_t_list, 3);

    list_push(double_list, 3);
    list_push(double_list, 2);
    list_push(double_list, 1);

    list_print(int64_t_list);
    printf("\n\n");
    list_print(double_list);
    printf("\n\n");

    return 0;
}