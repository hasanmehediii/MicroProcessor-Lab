section .data
    string db 'hello', 0
    msg db 'The length of the string is: '
    len equ $ - msg

section .bss
    length resb 2

section .text
    global _start

_start:
    mov ecx, 0
    mov esi, string

count_loop:
    cmp byte [esi], 0
    je end_count
    inc ecx
    inc esi
    jmp count_loop

end_count:
    mov eax, ecx
    ; Convert the length in eax to a string
    mov edi, length + 1
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
    mov edx, length + 2
    sub edx, ecx
    int 0x80

    mov eax, 1
    int 0x80
