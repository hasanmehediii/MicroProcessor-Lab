section .data
    hello db 'Hello, World!', 0xa

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, hello
    mov edx, 14
    int 0x80

    mov eax, 1
    int 0x80
