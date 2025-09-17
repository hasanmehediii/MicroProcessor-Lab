section .data
    msg db "Enter a number: ",0
    fmt_in db "%ld",0
    fmt_str db "%s",10,0
    prime_yes db "It is Prime",0
    prime_no  db "Not Prime",0

    x dq 0

section .text
    extern printf, scanf
    global main

main:
    push rbp

    ; print message
    mov rax,0
    mov rdi,msg
    call printf

    ; scan x
    mov rax,0
    mov rdi,fmt_in
    mov rsi,x
    call scanf

    mov rax,[x]
    cmp rax,2
    jl not_prime
    mov rcx,2
prime_loop:
    mov rbx,rcx
    imul rbx,rbx
    cmp rbx,rax
    jg is_prime

    xor rdx,rdx
    div rcx
    cmp rdx,0
    je not_prime
    inc rcx
    jmp prime_loop

is_prime:
    mov rax,0
    mov rdi,fmt_str
    mov rsi,prime_yes
    call printf
    jmp prime_done

not_prime:
    mov rax,0
    mov rdi,fmt_str
    mov rsi,prime_no
    call printf

prime_done:
    pop rbp
    mov rax,60
    xor rdi,rdi
    syscall
