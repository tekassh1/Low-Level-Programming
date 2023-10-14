%include "dict.inc"
%include "words.inc"
%include "lib.inc"

%define BUFFER_SIZE 256
%define OVERFLOW_MSG_SIZE 50
%define NOT_FOUND_MSG_SIZE 43

%define qw 8

section .bss

buffer: resb BUFFER_SIZE

section .data

overflow_msg: db "The input key is too large! (max size - 255 symb)", 10, 0
not_found_msg: db "The key you are looking for was not found!", 10, 0

section .text

global _start

_start:
    mov rdi, buffer
    mov rsi, BUFFER_SIZE
    call read_word
    test rax, rax
    je .overflow
    
    mov rdi, rax
    mov rsi, head
    call find_word

    test rax, rax
    je .not_found

    mov r12, rax        ; save entry address
    lea rdi, [rax + qw]
    call string_length

    xor rdi, rdi
    lea rdi, [r12 + qw]
    lea rdi, [rdi + rax]
    inc rdi
    call print_string
    call print_newline
    
    jmp .end
.overflow:
    mov rax, 1
    mov rdi, 2
    mov rsi, overflow_msg
    mov rdx, OVERFLOW_MSG_SIZE
    syscall
    jmp .end
.not_found:
    mov rax, 1
    mov rdi, 2
    mov rsi, not_found_msg
    mov rdx, NOT_FOUND_MSG_SIZE
    syscall
.end:
    call exit