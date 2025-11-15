section .data
    format_int db "%ld", 0
    format_two_int db "%ld %ld", 0
    format_float db "%.2lf", 0xA, 0
    format_float_zero db "0", 0xA, 0
    zero dq 0.0

section .bss
    n resq 1
    threshold resq 1
    arr resq 1000      

section .text
    global main
    extern printf, scanf

main:
    push rbp
    mov rbp, rsp
    
    
    mov rdi, format_two_int
    mov rsi, n
    mov rdx, threshold
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
    mov rdx, [threshold]
    call averageAboveThreshold
    
    
    movsd xmm1, xmm0
    mov rdi, format_float
    mov eax, 1
    call printf
    
    
    mov rsp, rbp
    pop rbp
    ret


averageAboveThreshold:
    push rbp
    mov rbp, rsp
    
    mov r12, rdi      
    mov r13, rsi       
    mov r14, rdx       
    
    ; Initialize variables
    xorpd xmm0, xmm0   
    xor r15, r15      
    xor rbx, rbx       
    
.loop:
    cmp rbx, r13
    jge .end_loop
    
    mov rax, [r12 + rbx*8]  
    
    
    cmp rax, r14
    jle .skip
    
    
    add r15, 1         
    
    
    cvtsi2sd xmm1, rax
    addsd xmm0, xmm1
    
.skip:
    inc rbx
    jmp .loop

.end_loop:
   
    cmp r15, 0
    je .no_elements
    
    
    cvtsi2sd xmm1, r15
    divsd xmm0, xmm1
    jmp .done
    
.no_elements:
    ; Return 0.0
    xorpd xmm0, xmm0
    
.done:
    mov rsp, rbp
    pop rbp
    ret