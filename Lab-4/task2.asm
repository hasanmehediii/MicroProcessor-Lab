extern printf
extern scanf

SECTION .data
    in_fmt: db "%ld",0
    mul_fmt: db "%ld x %ld = %ld",10,0

SECTION .bss
    n: resq 1

SECTION .text
    global main
main:
    mov rdi,in_fmt
    lea rsi,[n]
    xor rax,rax
    call scanf

    mov rbx,[n]
    mov rcx,1
.loop:
    cmp rcx,11
    jge .done
    mov rax,rbx
    imul rax,rcx
    mov rdi,mul_fmt
    mov rsi,rbx
    mov rdx,rcx
    mov rcx,rax
    xor rax,rax
    call printf
    inc rcx
    jmp .loop
.done:
    mov rax,0
    ret
