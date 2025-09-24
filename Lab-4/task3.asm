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
    mov rbx, [n]
    cmp rax, rbx
    jg .end

    ; Check if n % i == 0
    mov rax, [n]
    xor rdx, rdx
    div qword [i]

    cmp rdx, 0
    jne .skip

    ; If divisible, print i
    mov rdi, out_fmt
    mov rsi, [i]
    mov rax, 0
    call printf

.skip:
    ; i++
    mov rax, [i]
    add rax, 1
    mov [i], rax
    jmp .loop

.end:
    pop rbp
    mov rax, 0
    ret
