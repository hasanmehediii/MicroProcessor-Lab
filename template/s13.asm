section .data
    char db 'a'
    msg db 'Uppercase: '
    len equ $ - msg

section .bss
    upper resb 1

section .text
    global _start

_start:
    mov al, [char]
    sub al, 32
    mov [upper], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, upper
    mov edx, 1
    int 0x80

    mov eax, 1
    int 0x80
