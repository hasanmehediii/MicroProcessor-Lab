section .data
    prompt_msg1 db "Enter the first string: "
    len_prompt1 equ $ - prompt_msg1
    prompt_msg2 db "Enter the second string: "
    len_prompt2 equ $ - prompt_msg2
    equal_msg db "Strings are equal", 10
    len_equal equ $ - equal_msg
    greater_msg db "First string is greater", 10
    len_greater equ $ - greater_msg
    less_msg db "First string is less", 10
    len_less equ $ - less_msg

section .bss
    input_buf1 resb 256
    input_buf2 resb 256

section .text
    global _start

_start:
    ; Prompt for first string
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg1
    mov edx, len_prompt1
    int 0x80

    ; Read first string
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf1
    mov edx, 256
    int 0x80
    mov [eax + input_buf1 - 1], byte 0

    ; Prompt for second string
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg2
    mov edx, len_prompt2
    int 0x80

    ; Read second string
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf2
    mov edx, 256
    int 0x80
    mov [eax + input_buf2 - 1], byte 0

    ; --- String Compare ---
    mov esi, input_buf1
    mov edi, input_buf2
.strcmp_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, 10
    je .check_bl
    cmp al, bl
    jne .not_equal
    cmp al, 0
    je .equal
    inc esi
    inc edi
    jmp .strcmp_loop

.check_bl:
    cmp bl, 10
    je .equal
    jmp .not_equal

.not_equal:
    cmp al, bl
    jg .greater
    jmp .less

.equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, equal_msg
    mov edx, len_equal
    int 0x80
    jmp .exit

.greater:
    mov eax, 4
    mov ebx, 1
    mov ecx, greater_msg
    mov edx, len_greater
    int 0x80
    jmp .exit

.less:
    mov eax, 4
    mov ebx, 1
    mov ecx, less_msg
    mov edx, len_less
    int 0x80

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
