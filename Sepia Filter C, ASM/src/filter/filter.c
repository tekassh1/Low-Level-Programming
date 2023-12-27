#include "bmp.h"
#include "image.h"
#include "simd_filter.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

static uint8_t sat(uint64_t pixel_value) {
    return pixel_value > 255 ? 255 : pixel_value;
}

image* filter_c(image* img) {
    image* out = copy_image(img);

    for (size_t i = 0; i < out->height * out->width; i++) {
        uint8_t r = out->data[i].r;
        uint8_t g = out->data[i].g;
        uint8_t b = out->data[i].b;
        
        out->data[i].r = sat((r * 0.393f) + (g * 0.769f) + (b * 0.189f));
        out->data[i].g = sat((r * 0.349f) + (g * 0.686f) + (b * 0.168f));
        out->data[i].b = sat((r * 0.272f) + (g * 0.534f) + (b * 0.131f));
    }
    return out;
}

// asm function adapter

image* filter_asm(image* img) {
    image* out = copy_image(img);

    simd_filter(out->height, out->width, out->data);

    return out;
}