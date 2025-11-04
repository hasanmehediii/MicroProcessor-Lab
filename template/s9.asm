section .data
    string db 'hello'
    len equ $ - string

section .bss
    reversed_string resb len

section .text
    global _start

_start:
    mov ecx, len
    mov esi, string + len - 1
    mov edi, reversed_string

reverse_loop:
    mov al, [esi]
    mov [edi], al
    dec esi
    inc edi
    loop reverse_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, reversed_string
    mov edx, len
    int 0x80

    mov eax, 1
    int 0x80
