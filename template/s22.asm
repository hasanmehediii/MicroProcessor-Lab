section .data
    num1 dw 10
    num2 dw 20
    msg1 db 'Before swap: num1='
    len1 equ $ - msg1
    msg2 db ', num2='
    len2 equ $ - msg2
    msg3 db 'After swap: num1='
    len3 equ $ - msg3
    newline db 0xa

section .bss
    num_str resb 5

section .text
    global _start

_start:
    ; Print before swap
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80
    
    mov ax, [num1]
    call print_ax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov ax, [num2]
    call print_ax

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Swap using XOR
    mov ax, [num1]
    mov bx, [num2]
    xor ax, bx
    xor bx, ax
    xor ax, bx
    mov [num1], ax
    mov [num2], bx

    ; Print after swap
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov ax, [num1]
    call print_ax

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov ax, [num2]
    call print_ax

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    jmp exit

print_ax:
    ; Convert the number in ax to a string and print it
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
    mov ecx, edi
    mov edx, num_str + 5
    sub edx, ecx
    int 0x80
    ret

exit:
    mov eax, 1
    int 0x80
