section .data
    msg1 db "Enter first number: ", 0
    len1 equ $ - msg1
    msg2 db "Enter second number: ", 0
    len2 equ $ - msg2
    msg3 db "The sum is: ", 0
    len3 equ $ - msg3
    newline db 10

section .bss
    num1 resb 20
    num2 resb 20
    result resb 20

section .text
    global _start

; -------------------------------------------------------------
; _start: program entry
; -------------------------------------------------------------
_start:
    ; Prompt first number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, len1
    syscall

    ; Read first number
    mov rax, 0
    mov rdi, 0
    mov rsi, num1
    mov rdx, 20
    syscall

    ; Convert num1 ASCII -> int
    mov rdi, num1
    call atoi
    mov rbx, rax            ; save first integer

    ; Prompt second number
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall

    ; Read second number
    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 20
    syscall

    ; Convert num2 ASCII -> int
    mov rdi, num2
    call atoi
    mov rcx, rax            ; save second integer

    ; Call sum(a, b)
    mov rdi, rbx
    mov rsi, rcx
    call sum                ; rax = sum

    ; Convert result to ASCII
    mov rdi, rax
    call itoa               ; result in [result], length in rdx

    ; Print "The sum is: "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, len3
    syscall

    ; Print result (use correct length)
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall


; -------------------------------------------------------------
; sum(a, b): return a + b
; -------------------------------------------------------------
sum:
    push rbp
    mov rbp, rsp
    mov rax, rdi
    add rax, rsi
    pop rbp
    ret


; -------------------------------------------------------------
; atoi(str): convert ASCII string → integer
; -------------------------------------------------------------
atoi:
    push rbp
    mov rbp, rsp
    xor rax, rax
    mov rsi, rdi
.next:
    mov bl, [rsi]
    cmp bl, 10
    je .done
    cmp bl, 0
    je .done
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rsi
    jmp .next
.done:
    pop rbp
    ret


; -------------------------------------------------------------
; itoa(num): convert integer → ASCII string
;   returns: string in 'result', length in rdx
; -------------------------------------------------------------
itoa:
    push rbp
    mov rbp, rsp

    mov rax, rdi        ; number
    mov rbx, 10
    mov rsi, result + 19
    mov byte [rsi], 0   ; null terminator

.convert:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .convert

    ; Copy to result start
    mov rdi, result
    xor rcx, rcx
.copy:
    mov al, [rsi]
    mov [rdi], al
    cmp al, 0
    je .done_copy
    inc rsi
    inc rdi
    inc rcx
    jmp .copy
.done_copy:
    mov rdx, rcx        ; length in rdx

    pop rbp
    ret
