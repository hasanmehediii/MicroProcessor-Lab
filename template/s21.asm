section .data
    num dw 7
    prime_msg db 'The number is prime.'
    prime_len equ $ - prime_msg
    not_prime_msg db 'The number is not prime.'
    not_prime_len equ $ - not_prime_msg

section .text
    global _start

_start:
    mov ax, [num]
    cmp ax, 1
    jle not_prime ; 0 and 1 are not prime
    cmp ax, 2
    je is_prime ; 2 is prime

    mov bx, 2
prime_check_loop:
    cmp bx, ax
    je is_prime
    
    mov dx, 0
    mov cx, ax
    div bx
    
    cmp dx, 0
    je not_prime
    
    mov ax, cx
    inc bx
    jmp prime_check_loop

is_prime:
    mov eax, 4
    mov ebx, 1
    mov ecx, prime_msg
    mov edx, prime_len
    int 0x80
    jmp exit

not_prime:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_prime_msg
    mov edx, not_prime_len
    int 0x80

exit:
    mov eax, 1
    int 0x80
