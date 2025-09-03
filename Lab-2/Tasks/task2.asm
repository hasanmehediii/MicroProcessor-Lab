extern  printf
extern  scanf

SECTION .data
    x: dq 0
    sum: dq 0

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

    ; Compute sum = x * (x + 1) / 2
    mov rax, [x]         ; rax = x
    mov rbx, rax         ; rbx = x
    add rbx, 1           ; rbx = x + 1
    imul rax, rbx        ; rax = x * (x + 1)
    shr rax, 1           ; rax = rax / 2  (faster than div)
    mov [sum], rax       ; save result

    ; Print result
    mov rdi, out_fmt
    mov rsi, [x]         ; first %ld = x
    mov rdx, [sum]       ; second %ld = sum
    mov rax, 0
    call printf

    pop rbp
    mov rax, 0
    ret
