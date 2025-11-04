section .data
    string db 'madam'
    len equ $ - string
    palindrome_msg db 'The string is a palindrome.'
    palindrome_len equ $ - palindrome_msg
    not_palindrome_msg db 'The string is not a palindrome.'
    not_palindrome_len equ $ - not_palindrome_msg

section .text
    global _start

_start:
    mov ecx, len
    shr ecx, 1
    mov esi, string
    mov edi, string + len - 1

check_palindrome:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne not_palindrome

    inc esi
    dec edi
    loop check_palindrome

    ; It is a palindrome
    mov eax, 4
    mov ebx, 1
    mov ecx, palindrome_msg
    mov edx, palindrome_len
    int 0x80
    jmp exit

not_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_palindrome_msg
    mov edx, not_palindrome_len
    int 0x80

exit:
    mov eax, 1
    int 0x80
