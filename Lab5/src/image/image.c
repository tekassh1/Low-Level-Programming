#include "image.h"

#include <stdarg.h>
#include <stdint.h>
#include <stdlib.h>

static image* init_image(uint64_t width, uint64_t height) {
    image* res = malloc(sizeof(image));
    res->width =  width;
    res->height = height;
    res->data = malloc(sizeof(pixel) * width * height);
    return res;
}

image* copy_image(image* source) {
    image* result = init_image(source->width, source->height);

    for (size_t i = 0; i < result->height; i++) {
        for (size_t j = 0; j < result->width; j++) {
            result->data[i * result->width + j]
                = source->data[i * result->width + j];
        }
    }
    return result;
}

void clear_images_memory(int count, ...) {
    va_list list;

    va_start(list, count);
    for (size_t j = 0; j < count; j++) {
        image* curr_image = va_arg(list, image*);
        free(curr_image->data);
        free(curr_image);
    }
    va_end(list);
}