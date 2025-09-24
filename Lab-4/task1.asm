extern printf
extern scanf

SECTION .data
    in_fmt     db "%ld", 0
    out_fmt    db "%ld", 10, 0

SECTION .bss
    n      resq 1
    rev    resq 1
    rem    resq 1

SECTION .text
    global main

main:
    push rbp

    ; Scan input number
    mov rdi, in_fmt
    mov rsi, n
    call scanf

    mov rax, 0
    mov [rev], rax         ; rev = 0

    mov rax, [n]
.reverse_loop:
    cmp rax, 0
    je .done_reverse

    xor rdx, rdx
    mov rcx, 10
    div rcx                ; rax = n / 10, rdx = n % 10

    ; rev = rev * 10 + rdx
    mov rbx, [rev]
    imul rbx, rbx, 10
    add rbx, rdx
    mov [rev], rbx

    jmp .reverse_loop

.done_reverse:
    ; Print rev
    mov rdi, out_fmt
    mov rsi, [rev]
    mov rax, 0
    call printf

    pop rbp
    mov rax, 0
    ret
