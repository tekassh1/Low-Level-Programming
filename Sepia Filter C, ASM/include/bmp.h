#ifndef BMP
#define BMP

#include "image.h"

#include <stdint.h>
#include <stdio.h>

#define PIXEL_SIZE 3

typedef enum read_bmp_status  {
  READ_BMP_OK,
  READ_BMP_INVALID_SIGNATURE,
  READ_BMP_INVALID_BITS,
  READ_BMP_INVALID_HEADER,
  READ_BMP_NO_ENOUGH_MEMORY
} read_bmp_status;

typedef enum write_bmp_status  {
  WRITE_BMP_OK,
  WRITE_BMP_ERROR
} write_bmp_status;

extern const char* write_status_names[2];
extern const char* read_status_names[5];

#pragma pack(push, 1)
struct bmp_header {
    // Header
    uint16_t    bfType;
    uint32_t    bfileSize;
    uint32_t    bfReserved;
    uint32_t    bOffBits;

    // Data
    uint32_t    biSize;
    uint32_t    biWidth;
    uint32_t    biHeight;
    uint16_t    biPlanes;
    uint16_t    biBitCount;
    uint32_t    biCompression;
    uint32_t    biSizeImage;
    uint32_t    biXPelsPerMeter;
    uint32_t    biYPelsPerMeter;
    uint32_t    biClrUsed;
    uint32_t    biClrImportant;
};
#pragma pack(pop)

typedef struct bmp_header bmp_header;

read_bmp_status from_bmp(FILE* in, image** const img);
write_bmp_status to_bmp(FILE* out, image const* img);

#endif