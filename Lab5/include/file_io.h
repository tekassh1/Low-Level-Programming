#ifndef FILE_IO
#define FILE_IO

#include <stdio.h>

typedef enum file_proc_status {
    FILE_PROC_OK,
    FILE_PROC_ERROR
} file_proc_status;

typedef enum validate_filename_status {
  FILENAME_VALID,
  FILENAME_ERROR
} validate_filename_status;

extern const char* file_proc_status_names[2];
extern const char* validate_filename_status_names[2];

file_proc_status read_file(char* filename, FILE** f);
file_proc_status write_file(char* filename, FILE** f);
file_proc_status close_file(FILE* f);

#endif