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
    lea r13, [r13 + qw]
    mov rsi, r13
    call string_equals
    cmp rax, 0
    je .continue
    lea rax, [r13 - qw]
    jmp .end
.continue:
    lea r13, [r13 - qw]
    mov r13, [r13]
    jmp .loop
.not_found:
    mov rax, 0
.end:
    ret