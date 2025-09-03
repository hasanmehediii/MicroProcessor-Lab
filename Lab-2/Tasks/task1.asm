extern  printf
extern  scanf

SECTION .data
    a: dq 0
    b: dq 0
    c: dq 0
    result: dq 0

    enter: db "Enter three numbers: ", 0
    in_fmt: db "%ld", 0
    out_fmt: db "2*%ld + 3*%ld + %ld = %ld", 10, 0
    out_str: db "%s", 0

SECTION .text
global main
main:
    push rbp

    ; Print prompt
    mov rax, 0
    mov rdi, out_str       ; "%s"
    mov rsi, enter         ; "Enter three numbers: "
    call printf

    ; Read a
    mov rax, 0
    mov rdi, in_fmt        ; "%ld"
    mov rsi, a             ; &a
    call scanf

    ; Read b
    mov rax, 0
    mov rdi, in_fmt
    mov rsi, b             ; &b
    call scanf

    ; Read c
    mov rax, 0
    mov rdi, in_fmt
    mov rsi, c             ; &c
    call scanf

    ; Compute result = 2a + 3b + c
    mov rax, [a]           ; rax = a
    imul rax, rax, 2       ; rax = 2*a

    mov rbx, [b]           ; rbx = b
    imul rbx, rbx, 3       ; rbx = 3*b
    add rax, rbx           ; rax = 2a + 3b

    add rax, [c]           ; rax = 2a + 3b + c
    mov [result], rax

    ; Print result
    mov rdi, out_fmt       ; format string
    mov rsi, [a]           ; a
    mov rdx, [b]           ; b
    mov rcx, [c]           ; c
    mov r8, [result]       ; result
    mov rax, 0
    call printf

    pop rbp
    mov rax, 0
    ret
