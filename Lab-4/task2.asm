extern printf
extern scanf

SECTION .data
    in_fmt     db "%ld", 0
    out_fmt    db "%ld", 10, 0

SECTION .bss
    n      resq 1
    i      resq 1

SECTION .text
    global main

main:
    push rbp

    ; Scan n
    mov rdi, in_fmt
    mov rsi, n
    call scanf

    mov qword [i], 1

.loop:
    mov rax, [i]
    cmp rax, 11
    jge .end

    ; result = n * i
    mov rax, [n]
    mov rbx, [i]
    imul rax, rbx

    ; Print result
    mov rdi, out_fmt
    mov rsi, rax
    mov rax, 0
    call printf

    ; i++
    mov rax, [i]
    add rax, 1
    mov [i], rax

    jmp .loop

.end:
    pop rbp
    mov rax, 0
    ret

