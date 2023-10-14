%include "lib.inc"

%define qw 8
global find_word

find_word:
    mov r12, rdi  ; rdi - pointer to null terminated string
    mov r13, rsi  ; rsi - pointer to list next elem
.loop:
    cmp r13, 0
    je .not_found
    
    mov rdi, r12
    lea rsi, [r13 + qw]
    call string_equals
    cmp rax, 0
    je .continue
    mov rax, r13
    jmp .end
.continue:
    mov r13, [r13]
    jmp .loop
.not_found:
    mov rax, 0
.end:
    ret