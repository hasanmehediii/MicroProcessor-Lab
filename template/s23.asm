section .data
    num dw 123
    msg db 'The sum of digits is: '
    len equ $ - msg

section .bss
    sum resb 5

section .text
    global _start

_start:
    mov ax, [num]
    mov bx, 10
    mov cx, 0 ; sum

sum_loop:
    mov dx, 0
    div bx
    add cx, dx
    cmp ax, 0
    jne sum_loop

    mov ax, cx
    ; now ax has the sum, convert it to string and print
    mov edi, sum + 4
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
    mov edx, sum + 5
    sub edx, ecx
    int 0x80

    mov eax, 1
    int 0x80
