%include "lib.inc"

%define qw 8
global find_word

; rdi - pointer to null terminated string
; rsi - pointer to list next elem

find_word:
    mov r8, rdi
    mov r9, rsi     
.loop:
    cmp r9, 0
    je .not_found
    
    mov rdi, r8
    lea r9, [r9 + qw]
    mov rsi, r9

    push r8
    push r9
    call string_equals
    pop r9
    pop r8

    cmp rax, 0
    je .continue
    lea rax, [r9 - qw]
    jmp .end
.continue:
    lea r9, [r9 - qw]
    mov r9, [r9]
    jmp .loop
.not_found:
    mov rax, 0
.end:
    ret