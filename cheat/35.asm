section .data
    prompt_msg1 db "Enter the main string: "
    len_prompt1 equ $ - prompt_msg1
    prompt_msg2 db "Enter the substring: "
    len_prompt2 equ $ - prompt_msg2
    found_msg db "Substring found at index: "
    len_found equ $ - found_msg
    not_found_msg db "Substring not found", 10
    len_not_found equ $ - not_found_msg
    newline db 10

section .bss
    input_buf1 resb 256
    input_buf2 resb 256
    output_buf resb 32

section .text
    global _start

_start:
    ; Prompt for main string
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg1
    mov edx, len_prompt1
    int 0x80

    ; Read main string
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf1
    mov edx, 256
    int 0x80
    mov [eax + input_buf1 - 1], byte 0

    ; Prompt for substring
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg2
    mov edx, len_prompt2
    int 0x80

    ; Read substring
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf2
    mov edx, 256
    int 0x80
    mov [eax + input_buf2 - 1], byte 0

    ; --- Find Substring ---
    mov esi, input_buf1
    mov edi, input_buf2
    mov ecx, 0 ; index
.outer_loop:
    mov al, [esi]
    cmp al, 0
    je .not_found
    cmp al, 10
    je .not_found

    push esi
    push edi
.inner_loop:
    mov al, [edi]
    cmp al, 0
    je .found
    cmp al, 10
    je .found
    
    mov bl, [esi]
    cmp bl, al
    jne .no_match

    inc esi
    inc edi
    jmp .inner_loop

.no_match:
    pop edi
    pop esi
    inc esi
    inc ecx
    jmp .outer_loop

.found:
    pop edi
    pop esi
    mov eax, 4
    mov ebx, 1
    mov ecx, found_msg
    mov edx, len_found
    int 0x80

    mov eax, ecx
    call print_int
    call print_newline
    jmp .exit

.not_found:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_found_msg
    mov edx, len_not_found
    int 0x80

.exit:
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
