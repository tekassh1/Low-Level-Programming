%include "dict.inc"
%include "words.inc"
%include "lib.inc"

section .data
key: db "first word", 0 ;402056 ;40202a ;402000
section .text

global _start

_start:
    mov rdi, key
    mov rsi, first_word
    call find_word
    mov rdi, rax
    call print_uint
    call exit