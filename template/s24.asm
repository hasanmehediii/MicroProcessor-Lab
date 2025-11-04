section .data
    binary_num db '1101'
    len equ $ - binary_num
    msg db 'Decimal equivalent: '
    msg_len equ $ - msg

section .bss
    decimal_val resb 5

section .text
    global _start

_start:
    mov ecx, len
    mov esi, binary_num
    mov eax, 0 ; decimal value
    mov ebx, 1 ; power of 2

    convert_loop:
        dec ecx
        movzx edx, byte [esi + ecx]
        sub edx, '0'
        imul edx, ebx
        add eax, edx
        shl ebx, 1
        cmp ecx, 0
        jne convert_loop

    ; now eax has the decimal value, convert it to string and print
    mov edi, decimal_val + 4
    mov byte [edi], 0xa ; newline
    dec edi
    mov ebx, 10
print_loop:
    mov edx, 0
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    cmp eax, 0
    jne print_loop

    ; Print the result
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    inc ecx
    mov edx, decimal_val + 5
    sub edx, ecx
    int 0x80

    mov eax, 1
    int 0x80
