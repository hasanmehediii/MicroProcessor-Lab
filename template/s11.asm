section .data
    msg1 db 'Enter a number: ', 0
    len1 equ $ - msg1
    msg2 db 'The factorial is: ', 0
    len2 equ $ - msg2

section .bss
    num_str resb 5      ; buffer for user input
    fact resb 12        ; space for factorial result string

section .text
    global _start

_start:
    ; -------- Prompt for input --------
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    ; -------- Read user input --------
    mov eax, 3
    mov ebx, 0
    mov ecx, num_str
    mov edx, 5
    int 0x80

    ; -------- Convert ASCII to integer --------
    mov eax, 0
    mov esi, num_str
next_digit:
    movzx edx, byte [esi]
    cmp edx, 10          ; newline?
    je done_input
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc esi
    jmp next_digit
done_input:
    mov [num_str], eax   ; reuse buffer to store integer

    ; -------- Compute factorial --------
    mov eax, [num_str]   ; n
    cmp eax, 1
    jbe factorial_done   ; if n <= 1, result = 1

    mov ebx, eax
    dec ebx

factorial_loop:
    mov edx, 0
    mul ebx
    dec ebx
    cmp ebx, 1
    jg factorial_loop

factorial_done:
    ; -------- Convert result in EAX to string --------
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

    ; -------- Print "The factorial is: " --------
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    ; -------- Print factorial result --------
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, fact + 12
    sub edx, ecx
    int 0x80

    ; -------- Exit --------
    mov eax, 1
    xor ebx, ebx
    int 0x80
