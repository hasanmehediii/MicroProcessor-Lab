section .data
    prompt_msg db "Enter a string: "
    len_prompt equ $ - prompt_msg
    length_msg db "Length of the string is: "
    len_length_msg equ $ - length_msg
    newline db 10

section .bss
    input_buf resb 256
    output_buf resb 32

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

    ; --- String Length ---
    mov edi, input_buf
    mov ecx, 0
.strlen_loop:
    mov al, [edi]
    cmp al, 0
    je .strlen_done
    cmp al, 10 ; newline
    je .strlen_done
    inc edi
    inc ecx
    jmp .strlen_loop

.strlen_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, length_msg
    mov edx, len_length_msg
    int 0x80

    mov eax, ecx
    call print_int
    call print_newline

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Helper: Print Integer ---
print_int:
    pusha
    mov ecx, output_buf
    add ecx, 31
    mov byte [ecx], 0
    mov ebx, 10
.loop_print:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .loop_print
    
    mov edx, output_buf
    add edx, 31
    sub edx, ecx
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    popa
    ret

; --- Helper: Print Newline ---
print_newline:
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    popa
    ret
