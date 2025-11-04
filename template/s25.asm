section .data
    decimal_num dw 13
    msg db 'Binary equivalent: '
    msg_len equ $ - msg

section .bss
    binary_val resb 17 ; 16 bits + newline

section .text
    global _start

_start:
    mov ax, [decimal_num]
    mov edi, binary_val + 15
    mov byte [binary_val + 16], 0xa
    mov ecx, 16

convert_loop:
    shl ax, 1
    jc is_one
    mov byte [edi], '0'
    jmp next_bit
is_one:
    mov byte [edi], '1'
next_bit:
    dec edi
    loop convert_loop

    ; Print the result
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, binary_val
    mov edx, 17
    int 0x80

    mov eax, 1
    int 0x80
