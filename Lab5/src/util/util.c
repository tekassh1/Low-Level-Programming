#include "bmp.h"
#include "file_io.h"

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define ARRAY_SIZE(x) ((sizeof(x))/(sizeof((x)[0])))

static char forbidden_symbols[8] = {'\\', '/', ':', '*', '?', '<', '>', '|'};

static bool is_forbidden(char symb) {
    for (size_t i = 0; i < ARRAY_SIZE(forbidden_symbols); i++) {
        if (forbidden_symbols[i] == symb) return true;
    }
    return false;
}

validate_filename_status check_valid_filename(char* filename) {
    for (size_t i = 0; filename[i] != '\0'; i++) {
        if (is_forbidden(filename[i])) return FILENAME_ERROR;
    }
    return FILENAME_VALID;
}