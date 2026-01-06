section .data
    prompt_msg db "Enter the number of nodes: "
    len_prompt equ $ - prompt_msg
    node_prompt_msg db "Enter node data: "
    len_node_prompt equ $ - node_prompt_msg
    search_prompt_msg db "Enter value to search: "
    len_search_prompt equ $ - search_prompt_msg
    found_msg db "Value found in the BST", 10
    len_found equ $ - found_msg
    not_found_msg db "Value not found in the BST", 10
    len_not_found equ $ - not_found_msg
    space db " "
    newline db 10

section .bss
    input_buf resb 32
    output_buf resb 32
    node_pool resb 2048 ; Pool of 128 nodes (16 bytes each: 4 for data, 4 for left, 4 for right, 4 for parent)
    free_ptr resd 1
    root resd 1

section .text
    global _start

_start:
    ; Initialize memory manager
    mov dword [root], 0
    mov dword [free_ptr], node_pool

    ; Prompt for number of nodes
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_msg
    mov edx, len_prompt
    int 0x80

    ; Read number of nodes
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    
    mov esi, input_buf
    call parse_int
    mov ecx, eax

.create_loop:
    push ecx
    ; Prompt for node data
    mov eax, 4
    mov ebx, 1
    mov ecx, node_prompt_msg
    mov edx, len_node_prompt
    int 0x80
    
    ; Read node data
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    
    mov esi, input_buf
    call parse_int
    push eax

    ; --- BST Insertion ---
    call bst_insert

    pop ecx
    loop .create_loop

    ; Prompt for value to search
    mov eax, 4
    mov ebx, 1
    mov ecx, search_prompt_msg
    mov edx, len_search_prompt
    int 0x80

    ; Read value to search
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    
    mov esi, input_buf
    call parse_int
    
    ; --- BST Search ---
    call bst_search
    
    cmp eax, 1
    je .found

.not_found:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_found_msg
    mov edx, len_not_found
    int 0x80
    jmp .exit

.found:
    mov eax, 4
    mov ebx, 1
    mov ecx, found_msg
    mov edx, len_found
    int 0x80

.exit:
    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Allocate a new node ---
alloc_node:
    mov eax, [free_ptr]
    add dword [free_ptr], 16
    ret

; --- BST Insert ---
bst_insert:
    pop edx ; return address
    pop eax ; value
    push edx

    call alloc_node
    mov [eax], eax
    mov dword [eax+4], 0 ; left
    mov dword [eax+8], 0 ; right
    mov dword [eax+12], 0 ; parent

    mov ecx, [root]
    cmp ecx, 0
    je .set_root

    mov ebx, ecx
.insert_loop:
    cmp eax, [ebx]
    jge .go_right

.go_left:
    mov ecx, [ebx+4]
    cmp ecx, 0
    je .insert_left
    mov ebx, ecx
    jmp .insert_loop

.go_right:
    mov ecx, [ebx+8]
    cmp ecx, 0
    je .insert_right
    mov ebx, ecx
    jmp .insert_loop

.insert_left:
    mov [ebx+4], eax
    mov [eax+12], ebx
    ret

.insert_right:
    mov [ebx+8], eax
    mov [eax+12], ebx
    ret

.set_root:
    mov [root], eax
    ret

; --- BST Search ---
bst_search:
    mov ecx, [root]
.search_loop:
    cmp ecx, 0
    je .search_not_found
    
    cmp eax, [ecx]
    je .search_found
    jge .search_right

.search_left:
    mov ecx, [ecx+4]
    jmp .search_loop

.search_right:
    mov ecx, [ecx+8]
    jmp .search_loop

.search_found:
    mov eax, 1
    ret

.search_not_found:
    mov eax, 0
    ret

; --- Helper: Parse Integer ---
parse_int:
    xor edx, edx
.next_digit:
    movzx eax, byte [esi]
    cmp eax, '0'
    jl .done
    cmp eax, '9'
    jg .done
    sub eax, '0'
    imul edx, 10
    add edx, eax
    inc esi
    jmp .next_digit
.done:
    mov eax, edx
    ret
