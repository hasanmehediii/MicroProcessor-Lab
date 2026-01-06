section .data
    prompt_msg db "Enter a string: "
    len_prompt equ $ - prompt_msg
    reversed_msg db "Reversed string: "
    len_reversed_msg equ $ - reversed_msg
    newline db 10

section .bss
    input_buf resb 256
    reversed_buf resb 256

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
    mov [eax + input_buf -1], byte 0

    ; --- String Reverse ---
    mov esi, input_buf
    mov edi, reversed_buf
    call strlen
    add esi, eax
    dec esi
    mov ecx, eax

.reverse_loop:
    mov bl, [esi]
    mov [edi], bl
    inc edi
    dec esi
    loop .reverse_loop
    mov [edi], byte 0


    ; Print reversed string message
    mov eax, 4
    mov ebx, 1
    mov ecx, reversed_msg
    mov edx, len_reversed_msg
    int 0x80

    ; Print reversed string
    mov eax, 4
    mov ebx, 1
    mov ecx, reversed_buf
    mov edx, 256
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Helper: String Length ---
strlen:
    push edi
    mov edi, esi
    xor ecx, ecx
.strlen_loop:
    mov al, [edi]
    cmp al, 0
    je .strlen_done
    cmp al, 10
    je .strlen_done
    inc edi
    inc ecx
    jmp .strlen_loop
.strlen_done:
    mov eax, ecx
    pop edi
    ret
