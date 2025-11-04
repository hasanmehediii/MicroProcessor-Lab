section .data
    msg1 db "Enter a string: ", 0
    len1 equ $ - msg1
    msg2 db "The reversed string is: ", 0
    len2 equ $ - msg2
    newline db 10

section .bss
    str resb 100
    ;rev_str resb 100

section .text
    global _start

; -------------------------------------------------------------
; _start: program entry
; -------------------------------------------------------------
_start:
    ; Prompt for string
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, len1
    syscall

    ; Read string
    mov rax, 0
    mov rdi, 0
    mov rsi, str
    mov rdx, 100
    syscall

    ; rax contains length of string read
    ; Call reverse_str(str, rev_str, length)
    ;mov rdi, str
    ;mov rsi, rev_str
    ;mov rdx, rax
    ;call reverse_str

    ; Print "The reversed string is: "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall

    ; Print reversed string
    mov rax, 1
    mov rdi, 1
    ;mov rsi, rev_str
    ; rdx is already the length from reverse_str
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
; reverse_str(src, dest, len)
; -------------------------------------------------------------
reverse_str:
    push rbp
    mov rbp, rsp

    mov rcx, rdx        ; len
    dec rcx             ; ignore newline
    mov rdx, rcx        ; save length for later

    mov r8, rdi         ; src string
    mov r9, rsi         ; dest string

    add r8, rcx         ; r8 points to the end of the src string (after last char)
    dec r8              ; r8 points to the last char of the src string

.loop:
    cmp rcx, 0
    je .done

    mov al, [r8]
    mov [r9], al

    dec r8
    inc r9
    dec rcx
    jmp .loop

.done:
    mov byte [r9], 0    ; null terminate

    pop rbp
    ret