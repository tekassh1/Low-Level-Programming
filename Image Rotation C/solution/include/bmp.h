#ifndef BMP
#define BMP

#include  <stdint.h>

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

#endif
