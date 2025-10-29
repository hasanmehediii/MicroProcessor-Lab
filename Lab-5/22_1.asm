section .data
    prompt1 db "Enter first number: ", 0
    prompt1_len equ $ - prompt1
    prompt2 db "Enter second number: ", 0
    prompt2_len equ $ - prompt2
    result_msg db "Sum: ", 0
    result_msg_len equ $ - result_msg
    newline db 10

section .bss
    num1 resb 10
    num2 resb 10
    result resb 10

section .text
    global main

main:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num1
    mov rdx, 10
    syscall

    mov rsi, num1
    call atoi
    mov r12, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, prompt2_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 10
    syscall

    mov rsi, num2
    call atoi
    mov r13, rax

    mov rdi, r12
    mov rsi, r13
    call sum
    mov r14, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_msg_len
    syscall

    mov rax, r14
    mov rsi, result
    call itoa

    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 10
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    xor rax, rax
    ret

sum:
    mov rax, rdi
    add rax, rsi
    ret

atoi:
    xor rax, rax
    xor rcx, rcx
.loop:
    movzx rdx, byte [rsi]
    cmp rdx, 10
    je .done
    cmp rdx, 0
    je .done
    sub rdx, '0'
    imul rax, 10
    add rax, rdx
    inc rsi
    jmp .loop
.done:
    ret

itoa:
    push rbx
    push rcx
    push rdx
    
    mov rbx, 10
    xor rcx, rcx
    
.divide:
    xor rdx, rdx
    div rbx
    add rdx, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .divide
    
.write:
    pop rax
    mov [rsi], al
    inc rsi
    loop .write
    
    mov byte [rsi], 0
    
    pop rdx
    pop rcx
    pop rbx
    ret
