section .data
    N equ 10
    msg db 'Even numbers: '
    len equ $ - msg
    space db ' '

section .bss
    num_str resb 5

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov ecx, 1
print_loop:
    cmp ecx, N
    jg exit
    
    mov eax, ecx
    mov edx, 0
    mov ebx, 2
    div ebx
    
    cmp edx, 0
    jne not_even
    
    ; print the even number
    push ecx
    mov eax, ecx
    call print_eax
    pop ecx

not_even:
    inc ecx
    jmp print_loop

print_eax:
    ; Convert the number in eax to a string and print it
    mov edi, num_str + 4
    mov byte [edi], 0
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

    ; Print the number
    inc edi
    mov eax, 4
    mov ebx, 1
    push ecx
    mov ecx, edi
    mov edx, num_str + 5
    sub edx, ecx
    int 0x80
    pop ecx
    
    ; Print a space
    mov eax, 4
    mov ebx, 1
    push ecx
    mov ecx, space
    mov edx, 1
    int 0x80
    pop ecx
    ret

exit:
    mov eax, 1
    int 0x80
