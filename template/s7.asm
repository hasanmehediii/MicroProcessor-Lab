section .data
    array db 5, 1, 3, 9, 2
    size equ 5
    msg db 'The smallest number is: '
    len equ $ - msg

section .bss
    smallest resb 1

section .text
    global _start

_start:
    mov ecx, size
    dec ecx
    mov esi, array
    mov al, [esi]

find_smallest:
    inc esi
    cmp al, [esi]
    jle continue
    mov al, [esi]

continue:
    loop find_smallest

    add al, '0'
    mov [smallest], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, smallest
    mov edx, 1
    int 0x80

    mov eax, 1
    int 0x80
