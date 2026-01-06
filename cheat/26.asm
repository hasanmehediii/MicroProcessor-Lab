section .data
    prompt_msg db "Enter the number of elements: "
    len_prompt equ $ - prompt_msg
    array_prompt_msg db "Enter the elements: "
    len_array_prompt equ $ - array_prompt_msg
    sorted_msg db "Array is sorted", 10
    len_sorted equ $ - sorted_msg
    not_sorted_msg db "Array is not sorted", 10
    len_not_sorted equ $ - not_sorted_msg
    newline db 10

section .bss
    input_buf resb 32
    array resb 100 ; Array of 25 elements (4 bytes each)
    array_size resd 1

section .text
    global _start

_start:
    ; Prompt for array size
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, len_prompt
    int 0x80

    ; Read array size
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    
    mov esi, input_buf
    call parse_int
    mov [array_size], eax

    ; Prompt for array elements
    mov eax, 4
    mov ebx, 1
    mov ecx, array_prompt_msg
    mov edx, len_array_prompt
    int 0x80

    ; Read array elements
    mov edi, array
    mov ecx, [array_size]
.read_loop:
    push ecx
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    
    mov esi, input_buf
    call parse_int
    mov [edi], eax
    add edi, 4
    pop ecx
    loop .read_loop

    ; --- Check Sorted ---
    mov ecx, [array_size]
    dec ecx
    mov esi, array
.check_sorted_loop:
    cmp ecx, 0
    je .is_sorted
    mov eax, [esi]
    mov ebx, [esi + 4]
    cmp eax, ebx
    jg .not_sorted
    add esi, 4
    dec ecx
    jmp .check_sorted_loop
.is_sorted:
    mov eax, 4
    mov ebx, 1
    mov ecx, sorted_msg
    mov edx, len_sorted
    int 0x80
    jmp .exit
.not_sorted:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_sorted_msg
    mov edx, len_not_sorted
    int 0x80

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Helper: Parse Integer ---
parse_int:
    xor eax, eax
.next_digit:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .done
    cmp edx, '9'
    jg .done
    sub edx, '0'
    imul eax, 10
    add eax, edx
    inc esi
    jmp .next_digit
.done:
    ret
