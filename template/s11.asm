section .data
    num db 5
    msg db 'The factorial is: '
    len equ $ - msg

section .bss
    fact resb 5 ; To store up to 5 digits for the result and a newline

section .text
    global _start

_start:
    mov al, [num]
    mov bl, al
    dec bl
    mov ah, 0

factorial_loop:
    mul bl
    dec bl
    cmp bl, 0
    jne factorial_loop

    ; Convert the result in ax to a string
    mov edi, fact + 4
    mov byte [edi], 0xa ; newline
    dec edi
    mov ebx, 10

convert_loop:
    mov edx, 0
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    cmp eax, 0
    jne convert_loop

    ; Print the result
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    inc ecx
    mov edx, fact + 5
    sub edx, ecx
    int 0x80

    mov eax, 1
    int 0x80
