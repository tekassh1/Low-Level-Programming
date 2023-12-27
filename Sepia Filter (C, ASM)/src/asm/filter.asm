BITS 64
global simd_filter

%define PIXEL_SIZE 3

%macro pack_one_to_xmm 2    ; (xmm, pixel color ptr)
    xorps  %1, %1
    pinsrb %1, [%2], 0
    pinsrb %1, [%2], 4
    pinsrb %1, [%2], 8
    cvtdq2ps %1, %1
%endmacro

%macro pack_set_to_xmm 1    ; (pixel ptr)
    xorps xmm0, xmm0
    xorps xmm1, xmm1
    xorps xmm2, xmm2

    pack_one_to_xmm xmm0, %1        ; bbb
    pack_one_to_xmm xmm1, %1 + 1    ; ggg
    pack_one_to_xmm xmm2, %1 + 2    ; rrr
%endmacro

%macro process_matrix 0
    mulps xmm0, xmm3
    mulps xmm1, xmm4
    mulps xmm2, xmm5

    addps xmm0, xmm1
    addps xmm0, xmm2
%endmacro

%macro save_filtered 2          ; (source xmm, destination)
    cvtps2dq %1, %1             ; convert to doubleword
    pminud %1, xmm6             ; limit max color value
    
    pextrb [%2], %1, 0          ; extract colors from xmm to pointer
    pextrb [%2 + 1], %1, 4
    pextrb [%2 + 2], %1, 8
%endmacro

section .data

align 16
max_values_vec: dd 255, 255, 255, 0

align 16
b_vec: dd 0.131, 0.168, 0.189, 0.0  ; c33 c23 c13
align 16
g_vec: dd 0.534, 0.686, 0.769, 0.0  ; c32 c22 c12
align 16
r_vec: dd 0.272, 0.349, 0.393, 0.0  ; c31 c21 c11

section .text

simd_filter:                    ; (height, width, data ptr)
    mov r12, rdi                ; save height
    mov r13, rsi                ; save width
    mov r14, rdx                ; save data ptr
    
    mov rax, r12                ; get width * height * pixel size
    mul r13
    mov rbx, PIXEL_SIZE
    mul rbx
    mov r15, rax                ; save width * height * pixel size
    
    movaps xmm3, [rel b_vec]    ; save color coefficients to xmm's
    movaps xmm4, [rel g_vec]
    movaps xmm5, [rel r_vec]
    movaps xmm6, [rel max_values_vec]

    xor rbx, rbx                ; curr pixel pointer
    mov rbx, r14
.loop:
    pack_set_to_xmm rbx
    process_matrix
    save_filtered xmm0, rbx

    add rbx, PIXEL_SIZE
    sub r15, PIXEL_SIZE
    cmp r15, 0
    jl .end
    jmp .loop
.end:
    ret