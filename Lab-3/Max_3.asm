section .data
    msg db "Enter three numbers (a, b, c): ",0
    fmt_in db "%ld",0
    fmt_out db "Maximum = %ld",10,0

    a dq 0
    b dq 0
    c dq 0

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

    ; scan c
    mov rax,0
    mov rdi,fmt_in
    mov rsi,c
    call scanf

    ; max logic
    mov rax,[a]
    mov rbx,[b]
    cmp rbx,rax
    jle skip1
    mov rax,rbx
skip1:
    mov rbx,[c]
    cmp rbx,rax
    jle skip2
    mov rax,rbx
skip2:

    ; print result
    mov rdi,fmt_out
    mov rsi,rax
    xor rax,rax
    call printf

    ; exit
    pop rbp
    mov rax,60
    xor rdi,rdi
    syscall
