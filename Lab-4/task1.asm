// reverse a number

extern printf
extern scanf

SECTION .data
    in_fmt: db "%ld",0
    out_fmt: db "%ld",10,0

SECTION .bss
    n: resq 1

SECTION .text
    global main
main:
    mov rdi,in_fmt
    lea rsi,[n]
    xor rax,rax
    call scanf

    mov rax,[n]
    mov rcx,0
.loop:
    cmp rax,0
    je .done
    mov rdx,0
    mov rbx,10
    div rbx
    imul rcx,rcx,10
    add rcx,rdx
    jmp .loop
.done:
    mov rdi,out_fmt
    mov rsi,rcx
    xor rax,rax
    call printf
    mov rax,0
    ret
