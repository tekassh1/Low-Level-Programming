%macro define_words 1-*
    %assign count 0
    %rep %0
        %if count != 0
            db ","
        %endif
        db %1
        %assign count count + 1
        %rotate 1
    %endrep
    db 0
%endmacro

string: define_words "hello", "world", "ravilTheBest"

string_length:
    xor rax, rax
.loop:
    cmp byte [rdi+rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

print_string:
    push rdi
    call string_length
    pop rsi             ; pointer to the string start
    mov rdx, rax        ; amount of bytes
    mov rax, 1          ; syscall number
    mov rdi, 1          ; file descriptor (1 - stdout)
    syscall
    ret

exit:
    mov rax, 60
    syscall

global _start

_start:
    mov rdi, string
    call print_string
    call exit