#ifndef IMAGE
#define IMAGE

#include <inttypes.h>

typedef struct pixel {
    uint8_t b, g, r;
} pixel;

typedef struct image {
  uint64_t width, height;
  pixel* data;
} image;

image* copy_image(image* source);
void clear_images_memory(int count, ...);

#endif