section .data

string: db "-12345234121"

section .text
 
; Принимает код возврата и завершает текущий процесс
exit:
    mov rax, 60
    syscall

; Принимает указатель на нуль-терминированную строку, возвращает её длину
string_length:
    xor rax, rax
.loop:
    cmp byte [rdi+rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

; Принимает указатель на нуль-терминированную строку, выводит её в stdout
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

; Принимает код символа и выводит его в stdout
print_char:
    push rdi
    mov rsi, rsp
    mov rax, 1 ; syscall number
    mov rdi, 1 ; file descriptor (1 - stdout)
    mov rdx, 1 ; amount of bytes
    syscall
    pop rdi
    ret

; Переводит строку (выводит символ с кодом 0xA)
print_newline:
    xor rax, rax
    mov rdi, 10
    call print_char
    ret

; Выводит беззнаковое 8-байтовое число в десятичном формате 
; Совет: выделите место в стеке и храните там результаты деления
; Не забудьте перевести цифры в их ASCII коды.
print_uint:
    xor rax, rax
    xor r8, r8
    mov r8, rdi
    mov r9, 10
    mov r10, rsp    ; save default stack pointer to define end of out number
    push 0x0        ; null - terminator
    
.count_loop:
    mov rax, rdi
    xor rdx, rdx   ; div divides RAX:RDX pair
    div r9
    mov r8, rax    ; storing rest of number
    mov rax, rdx   ; getting ASCII code of number
    add rax, '0'
    dec rsp        ; allocating space for digit ASCII code in stack and mov it
    mov [rsp], al

    mov rdi, r8    ; restore rest of number
    cmp rdi, 0      ; if end of number - leave
    je .end
    jmp .count_loop
.end:
    mov rdi, rsp

    push r10    
    call print_string
    pop r10
    
    mov rsp, r10   ; restore rsp value
    ret

; Выводит знаковое 8-байтовое число в десятичном формате 
print_int:
    xor rax, rax
    mov r8, rdi
    cmp rdi, 0
    jge .end
.negative:
    mov rdi, 0x2d
    call print_char
    neg r8
.end:
    mov rdi, r8
    call print_uint
    ret

; Принимает два указателя на нуль-терминированные строки, возвращает 1 если они равны, 0 иначе
string_equals:
    xor rax, rax
    xor r8, r8
    mov rax, 1      ; default value - equals
.loop:
    mov dl, byte [rdi]
    cmp dl, byte [rsi]
    jne .not_equals

    cmp dl, 0x0     ; check null-terminator for both
    jne .continue
    cmp byte [rsi], 0x0
    je  .end
.continue:
    inc rdi
    inc rsi
    jmp .loop
.not_equals:
    mov rax, 0
.end:
    ret

; Читает один символ из stdin и возвращает его. Возвращает 0 если достигнут конец потока
read_char:
    xor rax, rax
    push rax
    mov rdi, 0
    mov rsi, rsp
    mov rdx, 1
    syscall
    cmp rax, -1
    je  .eof
    pop rax
    jmp .end
.eof:
    xor rax, rax
.end:
    ret

; Принимает: адрес начала буфера, размер буфера
; Читает в буфер слово из stdin, пропуская пробельные символы в начале, .
; Пробельные символы это пробел 0x20, табуляция 0x9 и перевод строки 0xA.
; Останавливается и возвращает 0 если слово слишком большое для буфера
; При успехе возвращает адрес буфера в rax, длину слова в rdx.
; При неудаче возвращает 0 в rax
; Эта функция должна дописывать к слову нуль-терминатор
read_word:
    xor rax, rax
    xor r8, r8  
    xor r9, r9
    xor r10, r10    ; r10 stores a final word size
    mov r8, rdi
    mov r9, rsi     
    dec r9          ; buf (size - 1) because of null terminator
.skipping_loop:
    push r8
    push r9
    push r10
    call read_char
    pop r10
    pop r9
    pop r8

    cmp rax, 0x20
    je  .skipping_loop
    cmp rax, 0x9
    je  .skipping_loop
    cmp rax, 0xA
    je  .skipping_loop
.main_loop:
    cmp rax, 0x20   ; if "whitespace" characters after word, exit
    je  .success
    cmp rax, 0x9
    je  .success
    cmp rax, 0xA
    je  .success
    cmp rax, 0
    je .success

    cmp r10, r9
    jg  .err
    mov [r8 + r10], rax
    inc r10

    push r8
    push r9
    push r10
    call read_char
    pop r10
    pop r9
    pop r8

    jmp .main_loop
.success:
    cmp r10, 0
    je  .err

    mov rdx, r10
    inc r10
    mov byte [r8 + r10], 0x0
    mov rax, r8
    jmp .end
.err:
    mov rdx, 0
    mov rax, 0
.end:
    ret
 
; Принимает указатель на строку, пытается
; прочитать из её начала беззнаковое число.
; Возвращает в rax: число, rdx : его длину в символах
; rdx = 0 если число прочитать не удалось
parse_uint:
    xor rax, rax
    xor rdx, rdx
    xor r9, r9
    xor r8, r8
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

; Принимает указатель на строку, пытается
; прочитать из её начала знаковое число.
; Если есть знак, пробелы между ним и числом не разрешены.
; Возвращает в rax: число, rdx : его длину в символах (включая знак, если он был) 
; rdx = 0 если число прочитать не удалось
parse_int:
    xor rax, rax
    cmp byte [rdi], '-'
    je .neg

    push rdi
    call parse_uint
    pop rdi

    xor r8, r8
    mov r8, rdi
    jmp .end
.neg:
    lea rdi, [rdi+1]

    push r8
    push rdi
    call parse_uint
    pop rdi
    pop r8

    cmp rdx, 0
    je .end
    inc rdx
    neg rax
.end:
    ret

; Принимает указатель на строку, указатель на буфер и длину буфера
; Копирует строку в буфер
; Возвращает длину строки если она умещается в буфер, иначе 0
string_copy:
    xor rax, rax
    
    push rdx
    push rdi
    push rsi
    call string_length
    pop rsi
    pop rdi
    pop rdx
    
    xor r8, r8
    xor r9, r9
    dec rdx
    cmp rax, rdx
    jg  .err
.loop:
    mov r9b, byte [rdi + r8]
    cmp r9b, 0x0
    je  .success
    mov byte [rsi + r8], r9b
    inc r8
    jmp .loop
.success:
    mov r9b, 0x0
    mov byte [rsi + r8], r9b
    mov rax, r8
    jmp .end
.err:
    mov rax, 0
.end:
    ret

global _start

_start:
    mov rdi, string
    call parse_int
    
    mov rdi, rax
    call print_int
    call exit