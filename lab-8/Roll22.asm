section .data
    space db ' ', 0
    newline db 10, 0
    minus db '-', 0

section .bss
    n resd 1
    temp resd 1
    root resd 1
    input_buffer resb 1024
    output_buffer resb 12
    sign resb 1
    first_output resb 1
    
section .text
    global _start

; Node structure: [value(4) | left(4) | right(4)] = 12 bytes

_start:
    ; Read entire input line
    mov eax, 3           ; sys_read
    mov ebx, 0           ; stdin
    mov ecx, input_buffer
    mov edx, 1024
    int 0x80
    
    ; Parse N from input
    xor esi, esi         ; buffer index
    call parse_int
    mov [n], eax
    
    ; Initialize root to NULL
    mov dword [root], 0
    
    ; Read and insert N integers
    mov ecx, [n]
.insert_loop:
    push ecx
    call parse_int
    mov [temp], eax
    
    ; Allocate node
    mov eax, 45          ; sys_brk
    xor ebx, ebx
    int 0x80
    mov ebx, eax
    add ebx, 12          ; allocate 12 bytes
    mov eax, 45
    int 0x80
    
    ; Initialize node
    sub eax, 12
    mov ebx, [temp]
    mov [eax], ebx       ; value
    mov dword [eax+4], 0 ; left
    mov dword [eax+8], 0 ; right
    
    ; Insert into BST
    push eax
    call insert_node
    add esp, 4
    
    pop ecx
    loop .insert_loop
    
    ; Perform inorder traversal
    mov byte [first_output], 1
    push dword [root]
    call inorder
    add esp, 4
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Parse integer from input_buffer at position esi
; Returns value in eax, updates esi
parse_int:
    push ebx
    push ecx
    push edx
    
    xor eax, eax         ; result
    xor ebx, ebx         ; sign (0=positive, 1=negative)
    
    ; Skip whitespace
.skip_space:
    cmp esi, 1024
    jge .done
    movzx ecx, byte [input_buffer + esi]
    cmp ecx, ' '
    je .next_char
    cmp ecx, 10          ; newline
    je .next_char
    cmp ecx, 13          ; carriage return
    je .next_char
    cmp ecx, 9           ; tab
    je .next_char
    jmp .check_sign
.next_char:
    inc esi
    jmp .skip_space
    
.check_sign:
    movzx ecx, byte [input_buffer + esi]
    cmp ecx, '-'
    jne .parse_digits
    mov ebx, 1
    inc esi
    
.parse_digits:
    cmp esi, 1024
    jge .apply_sign
    movzx ecx, byte [input_buffer + esi]
    
    ; Check if digit
    cmp ecx, '0'
    jl .apply_sign
    cmp ecx, '9'
    jg .apply_sign
    
    ; Convert and add
    sub ecx, '0'
    imul eax, 10
    add eax, ecx
    inc esi
    jmp .parse_digits
    
.apply_sign:
    cmp ebx, 1
    jne .done
    neg eax
    
.done:
    pop edx
    pop ecx
    pop ebx
    ret

; Insert node into BST
; Args: [esp+4] = node to insert
insert_node:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    
    mov esi, [ebp+8]     ; new node
    
    ; If root is NULL, set as root
    cmp dword [root], 0
    jne .traverse
    mov [root], esi
    jmp .done
    
.traverse:
    mov edi, [root]      ; current node
    
.loop:
    mov eax, [esi]       ; new value
    mov ebx, [edi]       ; current value
    
    cmp eax, ebx
    jl .go_left
    
.go_right:
    cmp dword [edi+8], 0
    je .insert_right
    mov edi, [edi+8]
    jmp .loop
    
.insert_right:
    mov [edi+8], esi
    jmp .done
    
.go_left:
    cmp dword [edi+4], 0
    je .insert_left
    mov edi, [edi+4]
    jmp .loop
    
.insert_left:
    mov [edi+4], esi
    
.done:
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret

; Inorder traversal
; Args: [esp+4] = node
inorder:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    
    mov esi, [ebp+8]     ; Use esi for node pointer
    cmp esi, 0
    je .done
    
    ; Traverse left
    push dword [esi+4]
    call inorder
    add esp, 4
    
    ; Print current node
    cmp byte [first_output], 1
    je .no_space
    
    push esi             ; Save node pointer
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80
    pop esi              ; Restore node pointer
    
.no_space:
    mov byte [first_output], 0
    push esi             ; Save node pointer before print
    mov eax, [esi]       ; Get value to print
    call print_int
    pop esi              ; Restore node pointer
    
    ; Traverse right
    push dword [esi+8]
    call inorder
    add esp, 4
    
.done:
    pop esi
    pop ebx
    pop ebp
    ret

; Print integer in eax
print_int:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov edi, eax
    mov esi, output_buffer
    add esi, 11          ; Point to end of buffer
    mov byte [esi], 0
    
    ; Handle negative
    mov ebx, 0           ; sign flag
    test edi, edi
    jns .positive
    neg edi
    mov ebx, 1
    
.positive:
    ; Convert to string (reverse order)
    mov ecx, 10
    
.convert_loop:
    xor edx, edx
    mov eax, edi
    div ecx
    add dl, '0'
    dec esi
    mov [esi], dl
    mov edi, eax
    test eax, eax
    jnz .convert_loop
    
    ; Add minus sign if negative
    test ebx, ebx
    jz .print
    dec esi
    mov byte [esi], '-'
    
.print:
    ; Calculate length
    mov ecx, output_buffer
    add ecx, 11
    sub ecx, esi
    mov edx, ecx
    mov ecx, esi
    
    ; Write to stdout
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret