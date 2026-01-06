section .data
    prompt_msg db "Enter the number of elements: "
    len_prompt equ $ - prompt_msg
    array_prompt_msg db "Enter the elements (sorted): "
    len_array_prompt equ $ - array_prompt_msg
    target_prompt_msg db "Enter the target element: "
    len_target_prompt equ $ - target_prompt_msg
    found_msg db "Element found at index: "
    len_found equ $ - found_msg
    not_found_msg db "Element not found"
    len_not_found equ $ - not_found_msg
    newline db 10

section .bss
    input_buf resb 32
    output_buf resb 32
    array resb 100 ; Array of 25 elements (4 bytes each)
    array_size resd 1
    target resd 1
    index resd 1

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

    ; Prompt for target element
    mov eax, 4
    mov ebx, 1
    mov ecx, target_prompt_msg
    mov edx, len_target_prompt
    int 0x80

    ; Read target element
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    
    mov esi, input_buf
    call parse_int
    mov [target], eax

    ; --- Binary Search ---
    mov eax, 0 ; low
    mov ecx, [array_size]
    dec ecx ; high
    mov ebx, [target]
.binary_search_loop:
    cmp eax, ecx
    jg .not_found

    mov edx, eax
    add edx, ecx
    shr edx, 1 ; mid = (low + high) / 2

    mov edi, [array + edx * 4]
    cmp edi, ebx
    je .found
    jg .go_left
    jmp .go_right

.go_left:
    mov ecx, edx
    dec ecx
    jmp .binary_search_loop

.go_right:
    mov eax, edx
    inc eax
    jmp .binary_search_loop


.found:
    mov [index], edx
    mov eax, 4
    mov ebx, 1
    mov ecx, found_msg
    mov edx, len_found
    int 0x80
    
    mov eax, [index]
    call print_int
    call print_newline
    jmp .exit


.not_found:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_found_msg
    mov edx, len_not_found
    int 0x80
    call print_newline

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
