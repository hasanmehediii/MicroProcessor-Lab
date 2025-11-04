section .data
    num1 db 5
    num2 db 9
    msg1 db 'The larger number is: '
    len1 equ $ - msg1
    msg2 db 'The numbers are equal'
    len2 equ $ - msg2

section .bss
    larger resb 1

section .text
    global _start

_start:
    mov al, [num1]
    mov bl, [num2]
    cmp al, bl
    jg is_larger
    jl is_smaller
    
    ; They are equal
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80
    jmp exit

is_larger:
    mov [larger], al
    add byte [larger], '0'
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, larger
    mov edx, 1
    int 0x80
    jmp exit

is_smaller:
    mov [larger], bl
    add byte [larger], '0'
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, larger
    mov edx, 1
    int 0x80

exit:
    mov eax, 1
    int 0x80
