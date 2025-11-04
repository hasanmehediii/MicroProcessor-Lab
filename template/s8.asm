section .data
    array db 1, 2, 3, 4, 5
    size equ 5
    msg db 'The sum is: '
    len equ $ - msg

section .bss
    sum resb 2

section .text
    global _start

_start:
    mov ecx, size
    mov esi, array
    mov al, 0

calculate_sum:
    add al, [esi]
    inc esi
    loop calculate_sum

    ; Check if the sum is > 9
    cmp al, 10
    jl print_single_digit

    ; Handle two-digit sum
    mov ah, 0
    mov bl, 10
    div bl
    add ah, '0'
    add al, '0'
    mov [sum], al
    mov [sum+1], ah
    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Print the two-digit sum
    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 2
    int 0x80
    jmp exit

print_single_digit:
    add al, '0'
    mov [sum], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Print the single-digit sum
    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 1
    int 0x80

exit:
    mov eax, 1
    int 0x80
