section .data
    prompt_msg db "Enter the number of nodes: "
    len_prompt equ $ - prompt_msg
    node_prompt_msg db "Enter node data: "
    len_node_prompt equ $ - node_prompt_msg
    list_msg db "Linked list: "
    len_list_msg equ $ - list_msg
    space db " "
    newline db 10

section .bss
    input_buf resb 32
    output_buf resb 32
    node_pool resb 1024 ; Pool of 128 nodes (8 bytes each: 4 for data, 4 for next)
    free_ptr resd 1
    head resd 1

section .text
    global _start

_start:
    ; Initialize memory manager
    mov dword [head], 0
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

    ; Allocate and insert node
    call insert_node
    pop ecx
    loop .create_loop

    ; Print linked list message
    mov eax, 4
    mov ebx, 1
    mov ecx, list_msg
    mov edx, len_list_msg
    int 0x80

    ; Print linked list
    call print_list

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Allocate a new node ---
alloc_node:
    mov eax, [free_ptr]
    add dword [free_ptr], 8
    ret

; --- Insert a new node at the end ---
insert_node:
    push ebx
    push ecx
    push edx
    
    call alloc_node
    mov [eax], edx ; data
    mov dword [eax+4], 0 ; next

    cmp dword [head], 0
    je .set_head
    
    mov ebx, [head]
.find_tail_loop:
    cmp dword [ebx+4], 0
    je .set_tail
    mov ebx, [ebx+4]
    jmp .find_tail_loop

.set_tail:
    mov [ebx+4], eax
    jmp .insert_done

.set_head:
    mov [head], eax

.insert_done:
    pop edx
    pop ecx
    pop ebx
    ret

; --- Print the linked list ---
print_list:
    mov esi, [head]
.print_loop:
    cmp esi, 0
    je .print_done
    
    mov eax, [esi]
    call print_int
    call print_space

    mov esi, [esi+4]
    jmp .print_loop
.print_done:
    call print_newline
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

; --- Helper: Print Space ---
print_space:
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
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
