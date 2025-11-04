section .data
    num1 dw 12
    num2 dw 18
    msg db 'The LCM is: '
    len equ $ - msg

section .bss
    lcm resb 5

section .text
    global _start

_start:
    mov ax, [num1]
    mov bx, [num2]
    mul bx
    
    push dx
    push ax

    mov ax, [num1]
    mov bx, [num2]
gcd_loop:
    cmp bx, 0
    je end_gcd
    mov dx, 0
    div bx
    mov ax, bx
    mov bx, dx
    jmp gcd_loop

end_gcd:
    pop bx ; pop product low
    pop dx ; pop product high
    ; ax has the GCD
    div ax
    
    ; ax has the lcm
    ; now convert ax to string
    mov edi, lcm + 4
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
    mov edx, lcm + 5
    sub edx, ecx
    int 0x80

    mov eax, 1
    int 0x80
