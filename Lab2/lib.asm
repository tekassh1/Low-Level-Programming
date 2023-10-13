section .text

global exit
global string_length
global print_string
global print_char
global print_newline
global print_uint
global print_int
global string_equals
global read_char
global read_word
global parse_uint
global parse_int
global string_copy

%define EXIT_SYSCALL 60

; Takes a return code and terminates the current process
exit:
    mov rax, EXIT_SYSCALL
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
    add rsp, 8
    ret

; Translates a string (prints a character with code 0xA)
print_newline:
    mov rdi, '\n'
    jmp print_char

; Prints an unsigned 8-byte number in decimal format
; Tip: Allocate space on the stack and store division results there
; Don't forget to convert digits to their ASCII codes.
print_uint:
    xor rax, rax
    xor r8, r8
    mov r8, rdi
    mov r9, 10
    mov r10, rsp        ; save the default stack pointer to define the end of the output number
    sub rsp, 32         ; allocation of space for symbols
    dec r10             ; null terminator
    mov byte [r10], 0x0
    
.count_loop:
    mov rax, rdi
    xor rdx, rdx    ; div divides RAX:RDX pair
    div r9
    mov r8, rax     ; storing the remainder
    add rdx, '0'    ; getting the ASCII code of the digit
    dec r10         ; allocating space for the digit's ASCII code in the stack and moving it
    mov [r10], dl

    mov rdi, r8     ; restore the remainder
    test rdi, rdi   ; if it's the end of the number, exit   
    jnz .count_loop
.end:
    mov rdi, r10
    call print_string
    
    add rsp, 32     ; restore the rsp value
    ret

; Prints a signed 8-byte number in decimal format
print_int:
    cmp rdi, 0      ; if zero, print
    jge .end
.negative:
    push rdi
    mov rdi, 0x2d   ; if negative, print '-'
    call print_char
    pop rdi
    neg rdi
.end:
    jmp print_uint ; print the positive part

; Takes two pointers to null-terminated strings and returns 1 if they are equal, 0 otherwise
string_equals:
    xor rax, rax
    xor r8, r8
.loop:
    mov dl, byte [rdi]  ; compare two bytes
    cmp dl, byte [rsi]
    jne .end

    test dl, dl         ; check null-terminator for both
    je  .equals
.continue:
    inc rdi
    inc rsi
    jmp .loop
.equals:
    inc rax
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
    je  .err
    pop rax         ; move the result character to rax
    ret
.err:
    pop rax
    xor rax, rax
.end:
    ret

; Takes: buffer start address, buffer size
; Reads a word from stdin into the buffer, skipping leading whitespace characters (space 0x20, tab 0x9, newline 0xA)
; Stops and returns 0 if the word is too big for the buffer
; On success, returns the buffer address in rax, word length in rdx, and adds a null terminator to the word
read_word:
    push r14                 ; using callee-saved regs
    push r13
    push r12

    xor rax, rax
    xor r14, r14             ; r14 stores the final word size
    mov r12, rdi             ; r12 stores the buffer address
    mov r13, rsi             ; r13 stores the buffer size
    dec r13                  ; buffer (size - 1) because of the null terminator
.skipping_loop:     
    call read_char

    cmp rax, ` `             ; if "whitespace" characters before the word, skip
    je  .skipping_loop
    cmp rax, `\t`
    je  .skipping_loop
    cmp rax, `\n`
    je  .skipping_loop
.main_loop:
    cmp rax, ` `            ; if "whitespace" characters after the word, exit
    je  .success
    cmp rax, `\t`
    je  .success
    cmp rax, `\n`
    je  .success
    test rax, rax
    je .success

    cmp r14, r13             ; if the current word size > buffer size -> error
    jg  .err
    mov [r12 + r14], rax     ; put the character in the next buffer position
    inc r14

    call read_char
    jmp .main_loop
.success:
    cmp r14, 0              ; if word size is 0 -> error
    je  .err

    mov rdx, r14            ; one additional symbol for the null terminator
    inc r14
    mov byte [r12 + r14], 0x0
    mov rax, r12
    jmp .end
.err:
    xor rdx, rdx
    xor rax, rax
.end:
    pop r12
    pop r13
    pop r14

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
    cmp byte [rdi], '+'     ; if it starts with '+', the number is positive
    jne .without_sign
    jmp .signed
.neg:
    xor r9, r9              ; should we make number negative flag
    inc r9
.signed:
    inc rdi                 ; get the address of the positive part of the number (excluding '-' / '+')

    push r8                 ; saving caller-saved regs
    push r9
    push rdi
    call parse_uint         ; parse non signed part of number
    pop rdi
    pop r9
    pop r8
   
    cmp rdx, 0              ; if there was an error while parsing, exit
    je .end

    inc rdx                 ; parsed size = size + 1 because of the '-' character
    cmp r9, 1               ; if should be negative -> neg instruction
    je .do_neg
    
    ret
.without_sign:
    push rdi                ; parse an unsigned number
    call parse_uint
    pop rdi

    xor r8, r8
    mov r8, rdi
    ret
.do_neg:
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