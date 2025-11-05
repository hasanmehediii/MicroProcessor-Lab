section .bss
    char resb 3

section .text
    global _start

_start:
    ; Read a character
    mov eax, 3
    mov ebx, 0
    mov ecx, char
    mov edx, 3
    int 0x80

    ; Print the character
    mov eax, 4
    mov ebx, 1
    mov ecx, char
    mov edx, 3
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
