section .data
    msg db 'Enter a string: ', 0
    len_msg equ $ - msg

section .bss
    input resb 100           ; buffer for user input
    reversed resb 100        ; buffer for reversed string

section .text
    global _start

_start:
    ; -------- Prompt user --------
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len_msg
    int 0x80

    ; -------- Read user input --------
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 100
    int 0x80
    mov esi, eax             ; store input length (includes newline)
    dec esi                  ; ignore newline at the end

    ; -------- Reverse string --------
    mov ecx, esi             ; loop count = string length
    mov esi, input           ; start of input
    add esi, ecx             ; move to last char
    dec esi                  ; adjust to valid index
    mov edi, reversed        ; output buffer

reverse_loop:
    mov al, [esi]
    mov [edi], al
    dec esi
    inc edi
    loop reverse_loop

    ; -------- Print reversed string --------
    mov eax, 4
    mov ebx, 1
    mov ecx, reversed
    mov edx, edi
    sub edx, reversed        ; length = edi - reversed
    int 0x80

    ; -------- Exit --------
    mov eax, 1
    xor ebx, ebx
    int 0x80
