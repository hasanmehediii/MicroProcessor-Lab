default rel

extern printf
extern scanf
extern srand
extern rand
extern time

global main

SECTION .data
prompt1     db "I'm thinking of a number between 1 and 100.",10,0
prompt2     db "You have 7 tries. Try to guess it.",10,0
ask         db "Enter your guess: ",0
out_correct db "Correct! You guessed it in %d tries.",10,0
out_low     db "Too low.",10,0
out_high    db "Too high.",10,0
out_fail    db "Out of tries! The number was %d.",10,0
fmt_int     db "%d",0

SECTION .bss
target      resd 1
guess       resd 1
tries       resd 1
maxtries    resd 1

SECTION .text

main:
    push rbp
    mov rbp, rsp

    ; seed srand(time(NULL))
    xor rdi, rdi        ; time(NULL) -> arg = 0
    call time
    mov edi, eax        ; srand takes unsigned int in edi
    call srand

    ; Print intro lines
    lea rdi, [rel prompt1]
    xor rax, rax
    call printf

    lea rdi, [rel prompt2]
    xor rax, rax
    call printf

    ; Generate random number: target = (rand() % 100) + 1
    call rand           ; returns in eax
    xor edx, edx
    mov ecx, 100
    div ecx             ; quotient in eax, remainder in edx
    inc edx             ; 1..100
    mov [target], edx

    ; initialize tries and maxtries
    mov dword [tries], 0
    mov dword [maxtries], 7

.loop_start:
    ; Prompt user
    lea rdi, [rel ask]
    xor rax, rax
    call printf

    ; Read guess: scanf("%d", &guess)
    lea rdi, [rel fmt_int]
    lea rsi, [rel guess]
    xor rax, rax
    call scanf

    ; increment tries
    mov eax, [tries]
    inc eax
    mov [tries], eax

    ; compare guess with target
    mov eax, [guess]
    mov ebx, [target]
    cmp eax, ebx
    je .correct
    jl .too_low

    ; guess > target
    lea rdi, [rel out_high]
    xor rax, rax
    call printf
    jmp .check_tries

.too_low:
    lea rdi, [rel out_low]
    xor rax, rax
    call printf
    jmp .check_tries

.correct:
    ; print success message with tries
    mov eax, [tries]
    mov esi, eax
    lea rdi, [rel out_correct]
    xor rax, rax
    call printf
    jmp .done

.check_tries:
    mov eax, [tries]
    mov ebx, [maxtries]
    cmp eax, ebx
    jl .loop_start

    ; out of tries -> reveal number
    mov eax, [target]
    mov esi, eax
    lea rdi, [rel out_fail]
    xor rax, rax
    call printf

.done:
    xor eax, eax
    pop rbp
    ret
