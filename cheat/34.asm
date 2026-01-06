section .data
    prompt_msg db "Enter a string: "
    len_prompt equ $ - prompt_msg
    uppercase_msg db "Uppercase string: "
    len_uppercase_msg equ $ - uppercase_msg

section .bss
    input_buf resb 256

section .text
    global _start

_start:
    ; Prompt for string
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, len_prompt
    int 0x80

    ; Read string
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 256
    int 0x80
    mov [eax + input_buf - 1], byte 0

    ; --- To Uppercase ---
    mov esi, input_buf
.toupper_loop:
    mov al, [esi]
    cmp al, 0
    je .toupper_done
    cmp al, 10
    je .toupper_done

    cmp al, 'a'
    jl .not_lowercase
    cmp al, 'z'
    jg .not_lowercase

    sub al, 32
    mov [esi], al

.not_lowercase:
    inc esi
    jmp .toupper_loop

.toupper_done:
    ; Print uppercase string message
    mov eax, 4
    mov ebx, 1
    mov ecx, uppercase_msg
    mov edx, len_uppercase_msg
    int 0x80

    ; Print uppercase string
    mov eax, 4
    mov ebx, 1
    mov ecx, input_buf
    mov edx, 256
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
