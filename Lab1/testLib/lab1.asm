section .data

test_string: db "1234567890", 0

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
.loop:
    cmp byte [rdi+rax], 0
    je .end
    push rdi
    push rax

    ; print a single character
    lea rsi, [rdi+rax]
    mov rax, 1 ; syscall number
    mov rdi, 1 ; file descriptor (1 - stdout)
    mov rdx, 1 ; amount of bytes
    syscall

    pop rax
    pop rdi
    inc rax
    jmp .loop
.end:
    ret

; Takes a character code and prints it to stdout
print_char:
    xor rax, rax
    ret

; Translates a string (prints a character with code 0xA)
print_newline:
    xor rax, rax
    ret

; Prints an unsigned 8-byte number in decimal format
; Tip: allocate space on the stack and store division results there
; Don't forget to convert digits to their ASCII codes.
print_uint:
    xor rax, rax
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
    mov rdi, test_string
    call print_string

    call exit