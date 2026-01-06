section .data
    prompt_msg db "Enter a string: "
    len_prompt equ $ - prompt_msg
    palindrome_msg db "The string is a palindrome", 10
    len_palindrome equ $ - palindrome_msg
    not_palindrome_msg db "The string is not a palindrome", 10
    len_not_palindrome equ $ - not_palindrome_msg

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

    ; --- Palindrome Check ---
    mov esi, input_buf
    call strlen
    mov edi, esi
    add edi, eax
    dec edi

.palindrome_loop:
    cmp esi, edi
    jge .is_palindrome

    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne .not_palindrome

    inc esi
    dec edi
    jmp .palindrome_loop


.is_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, palindrome_msg
    mov edx, len_palindrome
    int 0x80
    jmp .exit

.not_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_palindrome_msg
    mov edx, len_not_palindrome
    int 0x80

.exit:
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
