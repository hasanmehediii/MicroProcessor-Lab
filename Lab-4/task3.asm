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

    mov rbx,[n]
    mov rcx,1
.loop:
    cmp rcx,rbx
    jg .done
    mov rax,rbx
    xor rdx,rdx
    div rcx
    cmp rdx,0
    jne .skip
    mov rdi,out_fmt
    mov rsi,rcx
    xor rax,rax
    call printf
.skip:
    inc rcx
    jmp .loop
.done:
    mov rax,0
    ret
