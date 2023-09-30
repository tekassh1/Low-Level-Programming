section .text
 
; Takes a pointer to a null-terminated string and returns its length
string_length:
    xor rax, rax
.loop:
    cmp byte [rdi+rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

; Takes a pointer to a null-terminated string and prints it to stdout
print_string:
    xor rax, rax
    push rdi
    call string_length
    pop rsi ; pointer to string start
    mov rdx, rax ; amount of bytes
    mov rax, 1 ; syscall number
    mov rdi, 1 ; file descriptor (1 - stdout)
    syscall
    ret

; Принимает указатель на строку, пытается
; прочитать из её начала беззнаковое число.
; Возвращает в rax: число, rdx : его длину в символах
; rdx = 0 если число прочитать не удалось
parse_uint:
    xor rax, rax
    xor rdx, rdx
    xor r9, r9
    mov r8, 10
.loop:
    cmp byte [rdi+rdx], 0
    je  .end
    cmp byte [rdi+rdx], '0'
    jl  .end
    cmp byte [rdi+rdx], '9'
    jg  .end
    
    push rdx
    mul r8
    pop rdx
    mov r9b, byte [rdi+rdx]
    sub r9b, '0'
    add rax, r9
    inc rdx
    jmp .loop
.end:
    ret