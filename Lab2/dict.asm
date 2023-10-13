%include "lib.inc"

%define qw 8
global find_word

; rdi - pointer to null terminated string
; rsi - pointer to list next elem

find_word:
    mov r12, rdi
    mov r13, rsi     
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