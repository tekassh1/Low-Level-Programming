%include "dict.inc"
%include "words.inc"
%include "lib.inc"

%define BUFFER_SIZE 10
%define OVERFLOW_MSG_SIZE 50

section .bss

buffer: resb BUFFER_SIZE

section .data

overflow_msg: db "The input key is too large! (max size - 255 symb)", 10, 0
not_found_msg: db `Key you looking for not found!`

section .text

global _start

_start:
    mov rdi, buffer
    mov rsi, BUFFER_SIZE
    call read_word
    test rax, rax
    je .overflow
    jne .end
.overflow:
    mov rax, 1
    mov rdi, 2
    mov rsi, overflow_msg
    mov rdx, OVERFLOW_MSG_SIZE
    syscall
.end:
    call exit