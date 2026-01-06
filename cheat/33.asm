section .data
    prompt_msg db "Enter a string: "
    len_prompt equ $ - prompt_msg
    vowel_count_msg db "Number of vowels: "
    len_vowel_count_msg equ $ - vowel_count_msg
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
    mov [eax + input_buf - 1], byte 0

    ; --- Count Vowels ---
    mov esi, input_buf
    mov ebx, 0 ; vowel count
.count_vowels_loop:
    mov al, [esi]
    cmp al, 0
    je .count_vowels_done
    cmp al, 10
    je .count_vowels_done

    cmp al, 'a'
    je .is_vowel
    cmp al, 'e'
    je .is_vowel
    cmp al, 'i'
    je .is_vowel
    cmp al, 'o'
    je .is_vowel
    cmp al, 'u'
    je .is_vowel
    cmp al, 'A'
    je .is_vowel
    cmp al, 'E'
    je .is_vowel
    cmp al, 'I'
    je .is_vowel
    cmp al, 'O'
    je .is_vowel
    cmp al, 'U'
    je .is_vowel

    inc esi
    jmp .count_vowels_loop

.is_vowel:
    inc ebx
    inc esi
    jmp .count_vowels_loop

.count_vowels_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, vowel_count_msg
    mov edx, len_vowel_count_msg
    int 0x80

    mov eax, ebx
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
