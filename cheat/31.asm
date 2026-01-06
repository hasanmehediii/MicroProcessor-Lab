section .data
    prompt_msg db "Enter a string: "
    len_prompt equ $ - prompt_msg
    copied_msg db "Copied string: "
    len_copied_msg equ $ - copied_msg

section .bss
    input_buf resb 256
    copied_buf resb 256

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

    ; --- String Copy ---
    mov esi, input_buf
    mov edi, copied_buf
.strcpy_loop:
    mov al, [esi]
    mov [edi], al
    cmp al, 0
    je .strcpy_done
    inc esi
    inc edi
    jmp .strcpy_loop

.strcpy_done:
    ; Print copied string message
    mov eax, 4
    mov ebx, 1
    mov ecx, copied_msg
    mov edx, len_copied_msg
    int 0x80

    ; Print copied string
    mov eax, 4
    mov ebx, 1
    mov ecx, copied_buf
    mov edx, 256
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
