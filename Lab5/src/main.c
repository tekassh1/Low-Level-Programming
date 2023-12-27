#include "bmp.h"
#include "file_io.h"
#include "filter.h"
#include "simd_filter.h"
#include "util.h"

#include <time.h>
#include <stdio.h>

int main() {
    FILE* in_file;
    read_file("input.bmp", &in_file);

    FILE *src;
    file_proc_status open_file_status = read_file("input.bmp", &src);
    if (open_file_status != FILE_PROC_OK) {
        fprintf(stderr, "\n\n%s\n\n", file_proc_status_names[open_file_status]);
        return 1;
    }

    image* img;
    read_bmp_status read_bmp_status = from_bmp(in_file, &img);
     if (read_bmp_status != READ_BMP_OK) {
        clear_images_memory(1, img);
        fprintf(stderr, "\n\n%s\n\n", read_status_names[read_bmp_status]);
        return 1;
    };
    fclose(in_file);

    FILE* out_file1;
    FILE* out_file2;

    file_proc_status open_file_status1 = write_file("output1.bmp", &out_file1);
    file_proc_status open_file_status2 = write_file("output2.bmp", &out_file2);

    if (open_file_status1 != FILE_PROC_OK || open_file_status2 != FILE_PROC_OK) {
        clear_images_memory(1, img);
        if (open_file_status1 != FILE_PROC_OK) 
            fprintf(stderr, "\n\n%s\n\n", file_proc_status_names[open_file_status1]);
        if (open_file_status2 != FILE_PROC_OK) 
            fprintf(stderr, "\n\n%s\n\n", file_proc_status_names[open_file_status2]);
        return 1;
    }
    
    size_t amout_of_iters = 500;

    image* out1;

    clock_t begin_c = clock();
    for (size_t i = 0; i < amout_of_iters; i++)
        out1 = filter_c(img);
    clock_t end_c = clock();

    image* out2;

    clock_t begin_asm = clock();
    for (size_t i = 0; i < amout_of_iters; i++)
        out2 = filter_asm(img);
    clock_t end_asm = clock();

    double c_res   = (double) (end_c - begin_c) / CLOCKS_PER_SEC;
    double asm_res = (double) (end_asm - begin_asm) / CLOCKS_PER_SEC;
    
    printf("%-11s %-5s %s \n\n", "Realization", "Iters", "Result");
    printf("%-11s %-5zu %.2fs \n", "\"SIMD\"", amout_of_iters, asm_res);
    printf("%-11s %-5zu %.2fs \n", "\"NATIVE C\"", amout_of_iters, c_res);
    printf("\nTotal perfomance boost: %.2f\n", c_res / asm_res);

    write_bmp_status write_bmp_status1 = to_bmp(out_file1, out1);
    write_bmp_status write_bmp_status2 = to_bmp(out_file2, out2);

    if (write_bmp_status1 != WRITE_BMP_OK || write_bmp_status2 != WRITE_BMP_OK) {
        clear_images_memory(3, img, out1, out2);
        if (write_bmp_status1 != WRITE_BMP_OK)
            fprintf(stderr, "\n\n%s\n\n", write_status_names[write_bmp_status1]);
        if (write_bmp_status2 != WRITE_BMP_OK) 
            fprintf(stderr, "\n\n%s\n\n", write_status_names[write_bmp_status2]);
        return 1;
    };
    
    fclose(out_file1);
    fclose(out_file2);

    clear_images_memory(1, img);
    return 0;
}