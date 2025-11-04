section .data
    num1 db 9
    num2 db 3
    op db '*'
    msg_add db 'Addition: '
    len_add equ $ - msg_add
    msg_sub db 'Subtraction: '
    len_sub equ $ - msg_sub
    msg_mul db 'Multiplication: '
    len_mul equ $ - msg_mul
    msg_div db 'Division: '
    len_div equ $ - msg_div

section .bss
    result resb 5

section .text
    global _start

_start:
    mov al, [num1]
    mov bl, [num2]
    
    cmp byte [op], '+'
    je addition
    
    cmp byte [op], '-'
    je subtraction

    cmp byte [op], '*'
    je multiplication

    cmp byte [op], '/'
    je division

addition:
    add al, bl
    mov ah, 0
    call print_ax
    jmp exit

subtraction:
    sub al, bl
    mov ah, 0
    call print_ax
    jmp exit

multiplication:
    mul bl
    call print_ax
    jmp exit

division:
    mov ah, 0
    div bl
    call print_ax
    jmp exit

print_ax:
    ; Convert the number in ax to a string and print it
    mov edi, result + 4
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
    inc edi
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, result + 5
    sub edx, ecx
    int 0x80
    ret

exit:
    mov eax, 1
    int 0x80
