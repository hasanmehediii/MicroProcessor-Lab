section .data
    char db 'A'
    msg db 'Lowercase: '
    len equ $ - msg

section .bss
    lower resb 1

section .text
    global _start

_start:
    mov al, [char]
    add al, 32
    mov [lower], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, lower
    mov edx, 1
    int 0x80

    mov eax, 1
    int 0x80
