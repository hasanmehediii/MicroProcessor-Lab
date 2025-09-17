section .data
    print_msg db "Enter 2 number for GCD: ",0
    fmt_in db "%ld",0
    fmt_out db "GCD is = %ld", 10, 0            ;10 = new line

    a dq 0      ; a = 0, b = 0
    b dq 0

section .text
    extern printf, scanf
    global main

main:
    push rbp        ; saved the old based pointer

                    ;In Linux x86-64 calling convention (System V ABI):
                    ;rdi = 1st argument
                    ;rsi = 2nd argument
                    ;rdx = 3rd argument
                    ;rcx = 4th argument
                    ;rax = set to 0 if calling variadic functions like printf or scanf

    ;print first message
    mov rax, 0
    mov rdi, print_msg
    call printf


    ;scan first number a
    mov rax, 0
    mov rdi, fmt_in         ; scanf("%d", __ )
    mov rsi, a
    call scanf              ; scanf("%d", &a)


    ;scan next num b
    mov rax, 0
    mov rdi, fmt_in
    mov rsi, b
    call scanf              ; scanf("%d", &b)


    ; GCD algorithm......
    mov rax, [a]
    mov rbx, [b]

    gcd_loop:
        cmp rbx, 0          ; while (b != 0) { ... }
        je gcd_done

        xor rdx, rdx
        div rbx             ; rax / rbx, Quotient = rax (a/b), Remainder = rbx (a%b)

        mov rax, rbx        ; a = b
        mov rbx, rdx        ; b = a%b (rem)

        jmp gcd_loop        ; repeat


    gcd_done:
        mov rdi, fmt_out
        mov rsi, rax
        xor rax, rax
        call printf


    pop rbp         ; restore the old base pointer
    mov rax, 60     ; syscall: exit
    xor rdi, rdi    ; status: 0
    syscall