%include "dict.inc"
%include "words.inc"
%include "lib.inc"

%define BUFFER_SIZE 256
%define OVERFLOW_MSG_SIZE 50
%define NOT_FOUND_MSG_SIZE 43

%define STDERR 2
%define WRITE_SYSCALL 1
%define qw 8

section .bss

buffer: resb BUFFER_SIZE

section .rodata

overflow_msg: db "The input key is too large! (max size - 255 symb)", 10, 0
not_found_msg: db "The key you are looking for was not found!", 10, 0

section .text

error:
    mov rax, WRITE_SYSCALL 
    mov rdi, STDERR
    syscall
    mov rdi, 1
    call exit

global _start

_start:
    mov rdi, buffer
    mov rsi, BUFFER_SIZE
    call read_line
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
    mov rsi, overflow_msg
    mov rdx, OVERFLOW_MSG_SIZE
    call error
.not_found:
    mov rsi, not_found_msg
    mov rdx, NOT_FOUND_MSG_SIZE
    call error
.end:
    mov rdi, 0
    call exit