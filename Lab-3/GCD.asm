section .data
    msg db "Enter two numbers (a, b): ",0
    fmt_in db "%ld",0
    fmt_out db "GCD = %ld",10,0

    a dq 0
    b dq 0

section .text
    extern printf, scanf
    global main

main:
    push rbp

    ; print message
    mov rax,0
    mov rdi,msg
    call printf

    ; scan a
    mov rax,0
    mov rdi,fmt_in
    mov rsi,a
    call scanf

    ; scan b
    mov rax,0
    mov rdi,fmt_in
    mov rsi,b
    call scanf

    ; Euclidean algorithm
    mov rax,[a]    ; a
    mov rbx,[b]    ; b
gcd_loop:
    cmp rbx,0
    je gcd_done
    xor rdx,rdx
    div rbx        ; rax / rbx
    mov rax,rbx    ; a = b
    mov rbx,rdx    ; b = remainder
    jmp gcd_loop

gcd_done:
    ; rax holds gcd
    mov rdi,fmt_out
    mov rsi,rax
    xor rax,rax
    call printf

    ; exit
    pop rbp
    mov rax,60
    xor rdi,rdi
    syscall
