section .data
    format_int db "%ld", 0
    format_pair db "%ld %ld", 0xA, 0
    newline db 0xA, 0

section .bss
    n resq 1
    arr resq 1000      
    freq resq 1000     
    sorted resq 1000   

section .text
    global main
    extern printf, scanf, qsort

main:
    push rbp
    mov rbp, rsp
    
   
    mov rdi, format_int
    mov rsi, n
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
    call countFrequency
    
    
    call printFrequencyPairs

    mov rsp, rbp
    pop rbp
    ret


countFrequency:
    push rbp
    mov rbp, rsp
    sub rsp, 32        
    
 
    mov [rbp-8], rdi   
    mov [rbp-16], rsi  
    
 
    mov rdi, [rbp-8]  
    mov rsi, [rbp-16] 
    mov rdx, 8         
    mov rcx, compare   
    call qsort
    
    
    mov r12, [rbp-8]   
    mov r13, [rbp-16] 
    mov r14, freq      
    mov r15, sorted    
    xor rbx, rbx       
    xor rcx, rcx      
    
.count_loop:
    cmp rcx, r13
    jge .count_done
    
    mov rax, [r12 + rcx*8]  
    mov rdx, 1             
    

    mov r8, rcx
    inc r8
.find_consecutive:
    cmp r8, r13
    jge .store_freq
    mov r9, [r12 + r8*8]
    cmp rax, r9
    jne .store_freq
    inc rdx
    inc r8
    jmp .find_consecutive
    
.store_freq:
   
    mov [r15 + rbx*8], rax
    mov [r14 + rbx*8], rdx
    inc rbx
    
 
    mov rcx, r8
    jmp .count_loop
    
.count_done:
    mov [rbp-24], rbx 
    

    mov rdi, r15      
    mov rsi, rbx      
    mov rdx, 8        
    mov rcx, compare
    call qsort
    
    mov rax, r15      
    mov rdx, r14       
    mov rcx, [rbp-24]  
    
    mov rsp, rbp
    pop rbp
    ret


printFrequencyPairs:
    push rbp
    mov rbp, rsp
    

    
    mov r15, sorted    
    mov r14, freq     
    mov r13, rbx       
    xor r12, r12       
    
.print_loop:
    cmp r12, r13
    jge .print_done
    
    
    mov rdi, format_pair
    mov rsi, [r15 + r12*8]
    mov rdx, [r14 + r12*8]  
    xor eax, eax
    call printf
    
    inc r12
    jmp .print_loop
    
.print_done:
    mov rsp, rbp
    pop rbp
    ret


compare:
    push rbp
    mov rbp, rsp
    
    mov rax, [rdi]
    mov rdx, [rsi]     
    
    cmp rax, rdx
    jl .less
    jg .greater
    xor eax, eax       
    jmp .done
.less:
    mov eax, -1
    jmp .done
.greater:
    mov eax, 1
.done:
    mov rsp, rbp
    pop rbp
    ret