section .data
    prompt db "Enter a string: ", 0
    prompt_len equ $ - prompt
    result_msg db "Reversed: ", 0
    result_msg_len equ $ - result_msg
    newline db 10

section .bss
    input resb 100
    output resb 100

section .text
    global main

main:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 100
    syscall
    mov rsi, input
    mov rdi, output
    call reverse_str
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_msg_len
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, 100
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    xor rax, rax
    ret

reverse_str:
    push rbx
    push rcx
    mov rbx, rsi
    xor rcx, rcx
.find_length:
    movzx rax, byte [rsi]
    cmp rax, 10
    je .reverse
    cmp rax, 0
    je .reverse
    inc rsi
    inc rcx
    jmp .find_length
.reverse:
    dec rsi
.copy_loop:
    cmp rcx, 0
    je .done
    movzx rax, byte [rsi]
    mov [rdi], al
    inc rdi
    dec rsi
    dec rcx
    jmp .copy_loop
.done:
    mov byte [rdi], 10
    inc rdi
    mov byte [rdi], 0
    pop rcx
    pop rbx
    ret
