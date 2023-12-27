# Assignment: Image rotation

Project: Image rotation

# Task

- It is necessary to implement rotation of an image in BMP format by a specified angle in a clockwise direction. 
  clockwise. The format to use is as follows:
  
```
./image-transformer <source-image> <transformed-image> <angle>
```

The angle can take values strictly from the list: 0, 90, -90, 180, -180, 270, -270

- The architecture of the application is described in the following sections. 
- The code is placed in the `solution/src` directory, header files are found in `solution/include`.

# BMP file structure

A BMP file consists of a header and a bitmap array.
The header is specified by the following structure (note the `packed` attribute):

```c
#include  <stdint.h>
struct bmp_header __attribute__((packed))
{
        uint16_t bfType;
        uint32_t  bfileSize;
        uint32_t bfReserved;
        uint32_t bOffBits;
        uint32_t biSize;
        uint32_t biWidth;
        uint32_t  biHeight;
        uint16_t  biPlanes;
        uint16_t biBitCount;
        uint32_t biCompression;
        uint32_t biSizeImage;
        uint32_t biXPelsPerMeter;
        uint32_t biYPelsPerMeter;
        uint32_t biClrUsed;
        uint32_t  biClrImportant;
};
```

Immediately after it (is it always?) comes a bitmap array that stores pixels in rows sequentially.
Each pixel is defined by a structure of 3 bytes:

```c
   struct pixel { uint8_t b, g, r; };
```

## Padding

If the image width in bytes is a multiple of four, the lines follow each other without skipping.
If the width is not a multiple of four, it is supplemented with garbage bytes to the nearest multiple of four.
These bytes are called *padding*.

# About the architecture

The program is divided into modules; each module is a `.c` file that becomes a file with the extension `.o`.

## Part 1: Internal Format

A description of the internal representation of the `struct image`, cleaned up from the
format details, and functions to work with it: create, deinitialize, etc.

   ```c
   struct image {
     uint64_t width, height;
     struct pixel* data;
   };
   ```
  
  This part of the program doesn't need to know about input formats or transforms

## Part 2: Input Formats

Each input format is described in a separate module; they provide functions
to read files of different formats into a `struct image` and to write to disk in the
the same formats.

These modules know about the module describing `struct image`, but know nothing about the
transformations. Therefore, it will be possible to add new transformations without rewriting the
the code for the input formats.

  Once we have read an image into an internal format, we must forget from
which format it was read from!  That's why in `struct image` only the bare minimum of image details (dimensions) is left.
only the bare minimum of image details (dimensions), and no parts of the
of the bmp header.  For BMP, you can start with:

```c
/*  deserializer   */
enum read_status  {
  READ_OK = 0,
  READ_INVALID_SIGNATURE,
  READ_INVALID_BITS,
  READ_INVALID_HEADER
  /* коды других ошибок  */
  };

enum read_status from_bmp( FILE* in, struct image* img );

/*  serializer   */
enum  write_status  {
  WRITE_OK = 0,
  WRITE_ERROR
  /* коды других ошибок  */
};

enum write_status to_bmp( FILE* out, struct image const* img );

```

The `from_bmp` and `to_bmp` functions accept an already opened file, which allows them to work with pre-opened files `stdin`, `stdout`, `stderr`.
They can work with pre-opened files `stdin`, `stdout`, `stderr`.

The `from_bmp` and `to_bmp` functions should neither open nor close files.
For open/close errors, you may want to introduce separate types of
enumerations.

Once we have read an image into an internal format, we should forget from
which format it was read from! This is why `struct image` leaves out
only the bare minimum of image details (dimensions), and no parts of the
of the bmp header.

You will also need functions similar to `from_bmp` and `to_bmp`, which will take file names and deal with corrections.
will take file names and handle the correct opening (`fopen`) and
close (`fclose`) files; on open files they can run `from_bmp`
and `to_bmp`.

It makes sense to separate file opening/closing and file handling. Already
opening and closing may be accompanied by errors (see `man fopen` and 
`man fclose`) and we would like to separate the processing of opening/closing errors from the processing of reading/writing errors.
processing of read/write errors.


## Part 3: Transformations

Each transformation is described in a separate module. These modules know about
module describing `struct image`, but know nothing about input formats.
Therefore, it will be possible to add new input formats without rewriting the code for the
transformations. Without any additional effort, we will be able, by describing the input
format and immediately support all transformations on it.

You will need a function to rotate a picture in its internal representation:

   ```c
   /* creates a copy of the image that is rotated 90 degrees */
   struct image rotate( struct image const source );
   ```

## Part 4: Everything else

The rest of the program can be organized in any meaningful way. You may want to write a small library for I/O, string handling, etc.

You are encouraged to sensibly create new modules and introduce additional functions for convenience where needed.

Additional functions that you have introduced for convenience, but which do not make sense in any of these modules, can be separated out
into a separate module. This is often called `util.c` or something similar.
