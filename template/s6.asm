section .data
    array db 1, 5, 3, 9, 2
    size equ 5
    msg db 'The largest number is: '
    len equ $ - msg

section .bss
    largest resb 1

section .text
    global _start

_start:
    mov ecx, size
    dec ecx
    mov esi, array
    mov al, [esi]

find_largest:
    inc esi
    cmp al, [esi]
    jge continue
    mov al, [esi]

continue:
    loop find_largest

    add al, '0'
    mov [largest], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, largest
    mov edx, 1
    int 0x80

    mov eax, 1
    int 0x80
