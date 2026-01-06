section .data
    prompt_msg db "Enter the number of nodes: "
    len_prompt equ $ - prompt_msg
    node_prompt_msg db "Enter node data: "
    len_node_prompt equ $ - node_prompt_msg
    cycle_msg db "Cycle detected", 10
    len_cycle equ $ - cycle_msg
    no_cycle_msg db "No cycle detected", 10
    len_no_cycle equ $ - no_cycle_msg

section .bss
    input_buf resb 32
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

    ; --- Create a cycle for testing ---
    ; This will create a cycle from the last node to the second node
    mov ebx, [head]
    mov ecx, [ebx+4]
    
.find_tail_for_cycle:
    cmp dword [ebx+4], 0
    je .create_cycle_link
    mov ebx, [ebx+4]
    jmp .find_tail_for_cycle
.create_cycle_link:
    mov [ebx+4], ecx


    ; --- Detect Cycle ---
    call detect_cycle
    
    cmp eax, 1
    je .cycle_detected

.no_cycle:
    mov eax, 4
    mov ebx, 1
    mov ecx, no_cycle_msg
    mov edx, len_no_cycle
    int 0x80
    jmp .exit

.cycle_detected:
    mov eax, 4
    mov ebx, 1
    mov ecx, cycle_msg
    mov edx, len_cycle
    int 0x80
    
.exit:
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

; --- Detect Cycle in the linked list ---
detect_cycle:
    mov esi, [head] ; tortoise
    mov edi, [head] ; hare
.cycle_loop:
    cmp edi, 0
    je .no_cycle_found
    mov edi, [edi+4]
    cmp edi, 0
    je .no_cycle_found
    mov edi, [edi+4]
    mov esi, [esi+4]
    
    cmp esi, edi
    je .cycle_found

    jmp .cycle_loop

.no_cycle_found:
    mov eax, 0
    ret

.cycle_found:
    mov eax, 1
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
