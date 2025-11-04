section .bss
    num1 resb 2
    num2 resb 2
    sum resb 2

section .text
    global _start

_start:
    ; Read first number
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2
    int 0x80

    ; Read second number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; Convert to integer and add
    mov al, [num1]
    sub al, '0'
    mov bl, [num2]
    sub bl, '0'
    add al, bl

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
    ; Print the single-digit sum
    mov eax, 4
    mov ebx, 1
    mov ecx, sum
    mov edx, 1
    int 0x80

exit:
    mov eax, 1
    int 0x80
