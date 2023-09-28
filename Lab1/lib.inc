section .text

; Takes a return code and terminates the current process
exit:
    mov rax, 60
    syscall

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
    pop rsi             ; pointer to the string start
    mov rdx, rax        ; amount of bytes
    mov rax, 1          ; syscall number
    mov rdi, 1          ; file descriptor (1 - stdout)
    syscall
    ret

; Takes a character code and prints it to stdout
print_char:
    push rdi
    mov rsi, rsp
    mov rax, 1      ; syscall number
    mov rdi, 1      ; file descriptor (1 - stdout)
    mov rdx, 1      ; amount of bytes
    syscall
    pop rdi
    ret

; Translates a string (prints a character with code 0xA)
print_newline:
    xor rax, rax
    mov rdi, 10
    call print_char
    ret

; Prints an unsigned 8-byte number in decimal format
; Tip: Allocate space on the stack and store division results there
; Don't forget to convert digits to their ASCII codes.
print_uint:
    xor rax, rax
    xor r8, r8
    mov r8, rdi
    mov r9, 10
    mov r10, rsp    ; save the default stack pointer to define the end of the output number
    push 0x0        ; null-terminator
    
.count_loop:
    mov rax, rdi
    xor rdx, rdx    ; div divides RAX:RDX pair
    div r9
    mov r8, rax     ; storing the remainder
    mov rax, rdx    ; getting the ASCII code of the digit
    add rax, '0'
    dec rsp         ; allocating space for the digit's ASCII code in the stack and moving it
    mov [rsp], al

    mov rdi, r8     ; restore the remainder
    cmp rdi, 0      ; if it's the end of the number, exit
    je .end
    jmp .count_loop
.end:
    mov rdi, rsp

    push r10    
    call print_string
    pop r10
    
    mov rsp, r10    ; restore the rsp value
    ret

; Prints a signed 8-byte number in decimal format
print_int:
    xor rax, rax
    mov r8, rdi
    cmp rdi, 0      ; if zero, print
    jge .end
.negative:
    mov rdi, 0x2d   ; if negative, print '-'

    push r8
    call print_char
    pop r8

    neg r8
.end:
    mov rdi, r8     ; print the positive part
    call print_uint
    ret

; Takes two pointers to null-terminated strings and returns 1 if they are equal, 0 otherwise
string_equals:
    xor rax, rax
    xor r8, r8
    mov rax, 1          ; default value - equals
.loop:
    mov dl, byte [rdi]  ; compare two bytes
    cmp dl, byte [rsi]
    jne .not_equals

    cmp dl, 0x0         ; check null-terminator for both
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

; Reads one character from stdin and returns it. Returns 0 if the end of the stream is reached
read_char:
    xor rax, rax
    push rax        ; read syscall
    mov rdi, 0
    mov rsi, rsp
    mov rdx, 1
    syscall

    cmp rax, -1
    je  .eof
    pop rax         ; move the result character to rax
    jmp .end
.eof:
    xor rax, rax
.end:
    ret

; Takes: buffer start address, buffer size
; Reads a word from stdin into the buffer, skipping leading whitespace characters (space 0x20, tab 0x9, newline 0xA)
; Stops and returns 0 if the word is too big for the buffer
; On success, returns the buffer address in rax, word length in rdx, and adds a null terminator to the word
read_word:
    xor rax, rax
    xor r10, r10            ; r10 stores the final word size
    mov r8, rdi             ; r8 stores the buffer address
    mov r9, rsi             ; r9 stores the buffer size
    dec r9                  ; buffer (size - 1) because of the null terminator
.skipping_loop:     
    push r8                 ; saving volatile registers
    push r9
    push r10
    call read_char
    pop r10
    pop r9
    pop r8

    cmp rax, 0x20           ; if "whitespace" characters before the word, skip
    je  .skipping_loop
    cmp rax, 0x9
    je  .skipping_loop
    cmp rax, 0xA
    je  .skipping_loop
.main_loop:
    cmp rax, 0x20           ; if "whitespace" characters after the word, exit
    je  .success
    cmp rax, 0x9
    je  .success
    cmp rax, 0xA
    je  .success
    cmp rax, 0
    je .success

    cmp r10, r9             ; if the current word size > buffer size -> error
    jg  .err
    mov [r8 + r10], rax     ; put the character in the next buffer position
    inc r10

    push r8                 ; saving volatile registers
    push r9
    push r10
    call read_char
    pop r10
    pop r9
    pop r8

    jmp .main_loop
.success:
    cmp r10, 0              ; if word size is 0 -> error
    je  .err

    mov rdx, r10            ; one additional symbol for the null terminator
    inc r10
    mov byte [r8 + r10], 0x0
    mov rax, r8
    jmp .end
.err:
    mov rdx, 0
    mov rax, 0
.end:
    ret

; Takes a pointer to a string, attempts to read an unsigned number from its beginning
; Returns the number in rax, its length in rdx
; rdx = 0 if the number cannot be read
parse_uint:
    xor rax, rax
    xor rdx, rdx
    xor r9, r9
    xor r8, r8
    mov r8, 10              ; variable to divide by
.loop:
    cmp byte [rdi+rdx], 0
    je  .end
    cmp byte [rdi+rdx], '0' ; if not a number ASCII character, exit
    jl  .end
    cmp byte [rdi+rdx], '9'
    jg  .end
    
    push rdx
    mul r8                  ; build a number from the string (a*10 + x)
    pop rdx
    mov r9b, byte [rdi+rdx] ; next character in the buffer
    sub r9b, '0'            ; get the number from the character
    add rax, r9
    inc rdx
    jmp .loop
.end:
    ret

; Takes a pointer to a string, attempts to read a signed number from its beginning
; If there is a sign, spaces between it and the number are not allowed
; Returns the number in rax, its length in rdx (including the sign, if present)
; rdx = 0 if the number cannot be read
parse_int:
    xor rax, rax
    cmp byte [rdi], '-'     ; if it starts with '-', the number is negative
    je .neg

    push rdi                ; parse a positive number
    call parse_uint
    pop rdi

    xor r8, r8
    mov r8, rdi
    jmp .end
.neg:
    lea rdi, [rdi+1]        ; get the address of the positive part of the number (excluding '-')

    push r8
    push rdi
    call parse_uint         ; parse a positive number
    pop rdi
    pop r8

    cmp rdx, 0              ; if there was an error while parsing, exit
    je .end
    inc rdx                 ; parsed size = size + 1 because of the '-' character
    neg rax
.end:
    ret

; Takes a pointer to a string, a pointer to a buffer, and the buffer length
; Copies the string into the buffer
; Returns the length of the string if it fits in the buffer, otherwise 0
string_copy:
    xor rax, rax
    
    push rdx                ; saving volatile registers
    push rdi
    push rsi
    call string_length
    pop rsi
    pop rdi
    pop rdx
    
    xor r8, r8
    xor r9, r9
    dec rdx                 ; buffer length = length - 1 because of the null terminator
    cmp rax, rdx            ; if the string length > buffer size -> error
    jg  .err
.loop:
    mov r9b, byte [rdi + r8]    ; get the current character
    cmp r9b, 0x0                ; if it's a null terminator, end
    je  .success
    mov byte [rsi + r8], r9b    ; copy the character from the first string to the second
    inc r8
    jmp .loop
.success:
    mov r9b, 0x0                ; put a null terminator at the end of the string
    mov byte [rsi + r8], r9b
    mov rax, r8
    jmp .end
.err:
    mov rax, 0
.end:
    ret