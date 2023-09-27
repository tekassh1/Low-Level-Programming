section .data

decimal_numbers: db "0123456789"
test_string: db "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15", 0

section .text

; Takes a return code and exits the current process (arg - rdi)
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
    pop rsi ; pointer to string start
    mov rdx, rax ; amount of bytes
    mov rax, 1 ; syscall number
    mov rdi, 1 ; file descriptor (1 - stdout)
    syscall
    ret

; Takes a character code and prints it to stdout
print_char:
    push rdi
    mov rsi, rsp
    mov rax, 1 ; syscall number
    mov rdi, 1 ; file descriptor (1 - stdout)
    mov rdx, 1 ; amount of bytes
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
; Tip: allocate space on the stack and store division results there
; Don't forget to convert digits to their ASCII codes.
print_uint:
    xor rax, rax
    xor r8, r8
    xor r9, r9
    xor r10, r10
    mov r9, 10
    mov r10, rsp    ; save default stack pointer to define end of out number
.count_loop:
    cmp rdi, 0
    je .print_loop
    mov rax, rdi
    xor rdx, rdx    ; div divides RAX:RDX pair
    div r9
    mov r8, rax
    push rdx        ; remainder of division stored in rdx (intel docs)
    mov rdi, r8
    jmp .count_loop
.print_loop:
    cmp rsp, r10    ; check end of out number
    je  .end
    pop rdx
    xor rdi, rdi
    mov dil, byte [decimal_numbers + rdx]
    call print_char
    jmp .print_loop
.end:
    ret

; Prints a signed 8-byte number in decimal format
print_int:
    xor rax, rax
    ret

; Takes two pointers to null-terminated strings and returns 1 if they are equal, 0 otherwise
string_equals:
    xor rax, rax
    ret

; Reads one character from stdin and returns it. Returns 0 if the end of the stream is reached
read_char:
    xor rax, rax
    ret

; Takes: the address of a buffer, the buffer size
; Reads a word from stdin into the buffer, skipping leading whitespace, .
; Whitespace characters are space 0x20, tab 0x9, and newline 0xA.
; Stops and returns 0 if the word is too large for the buffer
; On success, returns the address of the buffer in rax, the length of the word in rdx.
; On failure, returns 0 in rax
; This function should append a null terminator to the word
read_word:
    ret

; Takes a pointer to a string and attempts
; to read an unsigned number from its beginning.
; Returns in rax: the number, rdx: its length in characters
; rdx = 0 if the number cannot be read
parse_uint:
    xor rax, rax
    ret

; Takes a pointer to a string, a pointer to a buffer, and the buffer length
; Copies the string to the buffer
; Returns the length of the string if it fits in the buffer, otherwise 0
string_copy:
    xor rax, rax
    ret

global _start

_start:
    mov rdi, 0x12d687
    call print_uint
    call print_newline
    call exit