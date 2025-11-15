section .data
    format_int db "%ld", 0
    format_int_print db "%ld ", 0
    format_two_int db "%ld %ld", 0
    newline db 0xA, 0

section .bss
    n resq 1
    k resq 1
    arr resq 1000      
    temp resq 1000     

section .text
    global main
    extern printf, scanf

main:
    push rbp
    mov rbp, rsp
    
   
    mov rdi, format_two_int
    mov rsi, n
    mov rdx, k
    xor eax, eax
    call scanf
    
   
    mov rcx, [n]
    mov rbx, arr
.read_loop:
    push rcx
    push rbx
    mov rdi, format_int
    mov rsi, rbx
    xor eax, eax
    call scanf
    pop rbx
    pop rcx
    add rbx, 8
    loop .read_loop
    
    
    mov rdi, arr
    mov rsi, [n]
    mov rdx, [k]
    call rotateArray
    
    
    mov rdi, arr
    mov rsi, [n]
    call printArray
    
    
    mov rsp, rbp
    pop rbp
    ret


rotateArray:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    
    mov r12, rdi      
    mov r13, rsi       
    mov r14, rdx      
    
    
    mov rax, r14
    xor rdx, rdx
    div r13         
    mov r14, rdx       ; k = k % n
    
   
    cmp r14, 0
    je .rotate_done
    
   
    mov rcx, r14       
    mov rsi, r12      
    mov rdi, temp      
    mov r15, r13      
    sub r15, r14      
    lea rsi, [r12 + r15*8]  
    
.copy_last_k:
    test rcx, rcx
    jz .copy_first_part
    mov rax, [rsi]
    mov [rdi], rax
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .copy_last_k
    
.copy_first_part:
   
    mov rcx, r13
    sub rcx, r14       
    mov rsi, r12       
    mov rdi, r12
    lea rdi, [rdi + r14*8] 
    
    
    lea rsi, [rsi + rcx*8 - 8]  
    lea rdi, [rdi + rcx*8 - 8]  
    
.copy_first_loop:
    test rcx, rcx
    jz .restore_last_k
    mov rax, [rsi]
    mov [rdi], rax
    sub rsi, 8
    sub rdi, 8
    dec rcx
    jmp .copy_first_loop
    
.restore_last_k:
    
    mov rcx, r14     
    mov rsi, temp      
    mov rdi, r12       
.copy_temp_back:
    test rcx, rcx
    jz .rotate_done
    mov rax, [rsi]
    mov [rdi], rax
    add rsi, 8
    add rdi, 8
    dec rcx
    jmp .copy_temp_back
    
.rotate_done:
    pop r15
    pop r14
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret


printArray:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    
    mov r12, rdi    
    mov r13, rsi      
    xor rbx, rbx       
    
.print_loop:
    cmp rbx, r13
    jge .print_done
    
    
    mov rdi, format_int_print
    mov rsi, [r12 + rbx*8]
    xor eax, eax
    call printf
    
    inc rbx
    jmp .print_loop
    
.print_done:
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret