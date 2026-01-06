section .data
    buffer times 12 db 0
    space db ' ', 0
    newline db 10, 0

section .bss
    n resd 1
    temp resd 1
    root resd 1
    sign resb 1
    first_output resb 1
    
section .text
    global _start

; Node structure: [value(4) | left(4) | right(4)] = 12 bytes

_start:
    ; Read N
    call read_int
    mov [n], eax
    
    ; Initialize root to NULL
    mov dword [root], 0
    
    ; Read and insert N integers
    mov ecx, [n]
.insert_loop:
    push ecx
    call read_int
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
    
    mov ebx, [ebp+8]
    cmp ebx, 0
    je .done
    
    ; Traverse left
    push dword [ebx+4]
    call inorder
    add esp, 4
    
    ; Print current node
    cmp byte [first_output], 1
    je .no_space
    
    mov eax, 4
    mov ecx, 1
    mov edx, space
    mov ecx, edx
    mov edx, 1
    int 0x80
    
.no_space:
    mov byte [first_output], 0
    mov eax, [ebx]
    call print_int
    
    ; Traverse right
    push dword [ebx+8]
    call inorder
    add esp, 4
    
.done:
    pop ebx
    pop ebp
    ret

; Read integer from stdin
read_int:
    push ebx
    push ecx
    push edx
    push esi
    
    xor eax, eax         ; result
    xor ebx, ebx         ; char
    xor esi, esi         ; sign (0=positive, 1=negative)
    
.read_loop:
    push eax
    mov eax, 3           ; sys_read
    mov ebx, 0
    mov ecx, buffer
    mov edx, 1
    int 0x80
    pop eax
    
    cmp eax, 0
    je .done
    
    movzx ebx, byte [buffer]
    
    ; Check for minus sign
    cmp ebx, '-'
    jne .check_digit
    mov esi, 1
    jmp .read_loop
    
.check_digit:
    ; Check if digit
    cmp ebx, '0'
    jl .done
    cmp ebx, '9'
    jg .done
    
    ; Convert and add
    sub ebx, '0'
    imul eax, 10
    add eax, ebx
    jmp .read_loop
    
.done:
    ; Apply sign
    cmp esi, 1
    jne .positive
    neg eax
    
.positive:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; Print integer
print_int:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov esi, eax
    mov edi, buffer
    add edi, 11
    mov byte [edi], 0
    dec edi
    
    ; Handle negative
    test esi, esi
    jns .positive
    neg esi
    
.positive:
    mov ecx, 10
    
.convert_loop:
    xor edx, edx
    mov eax, esi
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    mov esi, eax
    test eax, eax
    jnz .convert_loop
    
    ; Add minus if negative
    cmp dword [esp+16], 0
    jge .print
    mov byte [edi], '-'
    dec edi
    
.print:
    inc edi
    mov ecx, buffer
    add ecx, 11
    sub ecx, edi
    mov edx, ecx
    mov ecx, edi
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret