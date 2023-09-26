section .data
codes:
    db  '0123456789ABCDEF'

section .text

print_two_chars:
    push rdi
    xor rax, rax
    mov rsi, rsp
    mov rax, 1 ; syscall number
    mov rdi, 1 ; file descriptor (1 - stdout)
    mov rdx, 2 ; amount of bytes
    syscall
    pop rdi
    ret

print_char:
    push rdi
    xor rax, rax
    mov rsi, rsp
    mov rax, 1 ; syscall number
    mov rdi, 1 ; file descriptor (1 - stdout)
    mov rdx, 1 ; amount of bytes
    syscall
    pop rdi
    ret

print_newline:
    xor rax, rax
    mov rdi, 10
    call print_char
    ret

func_test:
    sub rsp, 24
    mov word [rsp], 'aa'
    mov word [rsp + 8], 'bb'
    mov word [rsp + 16], 'ff'

    mov rdi, [rsp]
    call print_two_chars
    call print_newline

    mov rdi, [rsp + 8]
    call print_two_chars
    call print_newline

    mov rdi, [rsp + 16]
    call print_two_chars
    call print_newline

    mov qword [rsp], 0
    mov qword [rsp + 8], 0
    mov qword [rsp + 16], 0
    add rsp, 24
    ret

global _start
_start:
    call func_test
.end:
    mov  rax, 60            ; invoke 'exit' system call
    xor  rdi, rdi
    syscall