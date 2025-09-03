extern  printf
extern  scanf

SECTION .data
    x: dq 0
    sum: dq 0
    i: dq 0             ; loop counter

    prompt: db "Enter a positive integer: ", 0
    in_fmt: db "%ld", 0
    out_fmt: db "Sum from 1 to %ld = %ld", 10, 0
    out_str: db "%s", 0

SECTION .text
global main
main:
    push rbp

    ; Print prompt
    mov rax, 0
    mov rdi, out_str
    mov rsi, prompt
    call printf

    ; Read x
    mov rax, 0
    mov rdi, in_fmt
    mov rsi, x
    call scanf

    ; Initialize sum = 0, i = 1
    mov qword [sum], 0
    mov qword [i], 1

loop_start:
    mov rax, [i]         ; rax = i
    mov rbx, [sum]       ; rbx = sum
    add rbx, rax         ; sum = sum + i
    mov [sum], rbx

    ; increment i
    mov rax, [i]
    add rax, 1
    mov [i], rax

    ; check if i <= x
    mov rax, [i]
    cmp rax, [x]
    jle loop_start       ; if i <= x, repeat

    ; Print result
    mov rdi, out_fmt
    mov rsi, [x]         ; first %ld = x
    mov rdx, [sum]       ; second %ld = sum
    mov rax, 0
    call printf

    pop rbp
    mov rax, 0
    ret
