extern printf
extern scanf

SECTION .data
    x: dq 0
    sum: dq 0

    prompt: db "Enter a positive integer: ", 0
    int_fmt: db "%ld", 0
    out_fmt: db "Sum from 1 to %ld is %ld", 10, 0
    out_fmt2" db "%s", 0

SECTION .text
    global main
    main:
