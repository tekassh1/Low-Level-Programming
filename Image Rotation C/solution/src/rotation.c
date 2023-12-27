#define ROATATE(source_pix, result_img)                                             \
    for (size_t i = 0; i < (result_img) -> height; i++) {                           \
        for (size_t j = 0; j < (result_img) -> width; j++) {                        \
            (result_img) -> data[i * (result_img) -> width + j] = (source_pix);     \
        }                                                                           \
    }                                                                                                                                     \

#include "../include/image.h"

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

static image* init_image(uint64_t width, uint64_t height, bool reverse_rotation) {
    image* res = malloc(sizeof(image));
    res->width =  reverse_rotation? height : width;
    res->height = reverse_rotation ? width : height;
    res->data = malloc(sizeof(pixel) * width * height);
    return res;
}

image* rotate_90(image* source) {
    image* result = init_image(source->width, source->height, true);

    ROATATE(source->data[source->width * (j + 1) - 1 - i], result);
 

    return result;
}

image* rotate_90_reverse(image* source) {
    image* result = init_image(source->width, source->height, true);

    ROATATE(source->data[source->width * (source->height - 1 - j) + i], result);

    return result;
}

image* rotate_180(image* source) {
    image* result = init_image(source->width, source->height, false);

    ROATATE(source->data[source->width * (source->height - 1 - i) + (source->width - 1 - j)], result);
    
    return result;
}

image* copy_image(image* source) {
    image* result = init_image(source->width, source->height, false);

    ROATATE(source->data[i * result->width + j], result);

    return result;
}
