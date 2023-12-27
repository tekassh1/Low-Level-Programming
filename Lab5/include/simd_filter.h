#ifndef SIMD_FILTER
#define SIMD_FILTER

#include "bmp.h"
#include <stdint.h>

void simd_filter(uint64_t height, uint64_t width, pixel* data);

#endif