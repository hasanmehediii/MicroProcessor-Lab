; nasm -f elf32 22_4.asm -o 4.o && ld -m elf_i386 4.o -o 4 && ./4
section .data
    msg1 db ' ', 0
    len1 equ $ - msg1
    msg2 db ' ', 0
    len2 equ $ - msg2
    overflow_msg db 'OVERFLOW', 0x0A, 0
    len_overflow equ $ - overflow_msg

section .bss
    num_str resb 5
    fact resb 12 

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num_str
    mov edx, 5
    int 0x80

    mov eax, 0
    mov esi, num_str
next_digit:
    movzx edx, byte [esi]
    cmp edx, 10 
    je done_input
    sub edx, '0'
    imul ebx, eax, 10
    add ebx, edx
    mov eax, ebx
    inc esi
    jmp next_digit
done_input:

    push eax ;
    call factorial_safe
    add esp, 4

    
    cmp eax, 0xFFFFFFFF
    je handle_overflow

    
    mov edi, fact + 11
    mov byte [edi], 0x0A
    dec edi
    mov ebx, 10
convert_loop:
    mov edx, 0
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convert_loop
    inc edi

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, fact + 12
    sub edx, ecx
    int 0x80

    jmp exit_program

handle_overflow:
    mov eax, 4
    mov ebx, 1
    mov ecx, overflow_msg
    mov edx, len_overflow
    int 0x80

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

factorial_safe:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov eax, [ebp+8]

    cmp eax, 0
    je .return_1
    cmp eax, 1
    je .return_1

    mov ebx, eax
    dec eax
    push eax
    call factorial_safe
    add esp, 4

    cmp eax, 0xFFFFFFFF
    je .return_overflow
    mul ebx
    cmp edx, 0
    jne .return_overflow 
    jmp .end_factorial_safe

.return_1:
    mov eax, 1
    jmp .end_factorial_safe

.return_overflow:
    mov eax, 0xFFFFFFFF 
.end_factorial_safe:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret
