section .data
    msg1 db "Enter first number: ", 0
    len1 equ $ - msg1
    msg2 db "Enter second number: ", 0
    len2 equ $ - msg2
    msg3 db "The maximum is: ", 0
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

    ; Call max_of_two(a, b)
    mov rdi, rbx
    mov rsi, rcx
    call max_of_two         ; rax = max

    ; Convert result to ASCII
    mov rdi, rax
    call itoa               ; result in [result], length in rdx

    ; Print "The maximum is: "
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
; max_of_two(a, b): return max(a, b)
; -------------------------------------------------------------
max_of_two:
    push rbp
    mov rbp, rsp
    mov rax, rdi
    cmp rax, rsi
    jge .done
    mov rax, rsi
.done:
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
    mov rcx, 1              ; sign multiplier

    ; Check for negative sign
    cmp byte [rsi], '-'
    jne .convert_loop
    mov rcx, -1
    inc rsi

.convert_loop:
    mov bl, [rsi]
    cmp bl, 10
    je .done
    cmp bl, 0
    je .done
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rsi
    jmp .convert_loop

.done:
    imul rax, rcx
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
    mov rcx, 0              ; length

    ; Check if negative
    test rax, rax
    jns .convert
    neg rax
    mov byte [rsi-1], '-'
    dec rsi
    inc rcx

.convert:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .convert

    ; Copy to result start
    mov rdi, result
    mov rdx, rcx
.copy:
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jnz .copy

    pop rbp
    ret
