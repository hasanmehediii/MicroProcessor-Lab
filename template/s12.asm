section .data
    N equ 10
    series db 0, 1
    len equ 2
    space db ' '

section .bss
    num_str resb 5

section .text
    global _start

_start:
    mov ecx, N - 2
    mov esi, series

fibonacci_loop:
    mov al, [esi]
    mov bl, [esi+1]
    add al, bl
    add esi, 1
    mov [esi+1], al
    loop fibonacci_loop

    ; Print the series
    mov ecx, N
    mov esi, series
print_loop:
    movzx eax, byte [esi] ; Use movzx to zero-extend the byte into eax
    
    ; Convert number to string
    mov edi, num_str + 4
    mov byte [edi], 0
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

    ; Print the number
    inc edi
    mov eax, 4
    mov ebx, 1
    push ecx
    mov ecx, edi
    mov edx, num_str + 5
    sub edx, ecx
    int 0x80
    pop ecx

    ; Print a space
    mov eax, 4
    mov ebx, 1
    push ecx
    mov ecx, space
    mov edx, 1
    int 0x80
    pop ecx

    inc esi
    loop print_loop

    mov eax, 1
    int 0x80
