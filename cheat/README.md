# Assembly Language DSA Problem Set

This document contains 60 programming problems focused on Data Structures, Algorithms, and low-level logic, designed for implementation in x86 Assembly (NASM syntax).

## Problem List

### I. Basic Arithmetic & Number Theory
1. **Factorial Calculation:** Input `N`, output `N!` (recursive or iterative).
2. **Fibonacci Sequence:** Print the first `N` numbers of the Fibonacci sequence.
3. **Prime Checker:** Input `N`, print "Prime" or "Not Prime".
4. **Greatest Common Divisor (GCD):** Input two numbers, print their GCD.
5. **Least Common Multiple (LCM):** Input two numbers, print their LCM.
6. **Sum of Digits:** Calculate the sum of digits of a given integer `N`.
7. **Reverse Integer:** Input an integer, output the number with digits reversed.
8. **Power Function:** Calculate `x^y` using a loop or recursion.
9. **Perfect Number:** Check if a number is equal to the sum of its proper divisors.
10. **Armstrong Number:** Check if a number equals the sum of its digits each raised to the power of the number of digits.

### II. Array Manipulations
11. **Array Sum:** Calculate the sum of `N` integers in an array.
12. **Find Maximum:** Find the maximum value in an array of `N` integers.
13. **Find Minimum:** Find the minimum value in an array of `N` integers.
14. **Reverse Array:** Reverse the elements of an array in place.
15. **Rotate Array:** Rotate an array to the right by `K` positions.
16. **Remove Duplicates:** Remove duplicate elements from a sorted array.
17. **Merge Arrays:** Merge two sorted arrays into a single sorted array.
18. **Scalar Multiplication:** Multiply all elements of an array by a scalar `K`.
19. **Count Occurrences:** Count how many times a target `T` appears in an array.
20. **Cumulative Sum:** Transform an array so that the element at `i` is the sum of 0 to `i`.

### III. Sorting & Searching
21. **Bubble Sort:** Sort `N` integers in ascending order using Bubble Sort.
22. **Selection Sort:** Sort `N` integers using Selection Sort.
23. **Insertion Sort:** Sort `N` integers using Insertion Sort.
24. **Linear Search:** Find the index of a target `T` in an array (or -1 if not found).
25. **Binary Search:** Find the index of `T` in a sorted array using Binary Search.
26. **Check Sorted:** Determine if an array is sorted in ascending order.
27. **Find Median:** Find the median of a sorted array.

### IV. Strings
28. **String Length:** Calculate the length of a null-terminated string.
29. **String Reverse:** Reverse a string in place.
30. **Palindrome Check:** Check if a string is a palindrome.
31. **String Copy:** Implement `strcpy` logic.
32. **String Compare:** Implement `strcmp` logic (-1, 0, 1).
33. **Count Vowels:** Count the number of vowels in a string.
34. **To Uppercase:** Convert a lowercase string to uppercase.
35. **Find Substring:** Find the starting index of a substring within a string.

### V. Linked Lists (Dynamic Memory)
36. **Create Linked List:** Insert `N` integers into a linked list and print them.
37. **Reverse Linked List:** Reverse a singly linked list.
38. **Delete Node:** Delete a node with value `V` from a linked list.
39. **Linked List Size:** Count the number of nodes in a linked list.
40. **Find Midpoint:** Find the middle element of a linked list (Tortoise/Hare).
41. **Detect Cycle:** Check if a linked list contains a cycle.

### VI. Trees (BST)
42. **BST Insertion:** (The problem provided in the prompt).
43. **BST Search:** Check if a value `V` exists in the BST.
44. **Find Minimum in BST:** Output the smallest value in the BST.
45. **BST Height:** Calculate the maximum depth of the tree.
46. **Preorder Traversal:** Print the tree in preorder (Root, Left, Right).
47. **Postorder Traversal:** Print the tree in postorder (Left, Right, Root).
48. **Count Leaves:** Count the number of leaf nodes in the BST.
49. **Invert BST:** Mirror the tree (swap left and right children recursively).

### VII. Stacks & Recursion
50. **Implement Stack:** Implement push/pop operations using an array.
51. **Balanced Parentheses:** Check if a string of `()` is balanced using a stack.
52. **Reverse String via Stack:** Push characters to stack and pop to reverse.
53. **Towers of Hanoi:** Solve for `N` disks (print moves).
54. **Ackermann Function:** Implement the Ackermann function (deep recursion test).

### VIII. Bit Manipulation
55. **Count Set Bits:** Count the number of 1s in the binary representation of `N`.
56. **Power of Two:** Check if `N` is a power of two using bitwise logic.
57. **Swap via XOR:** Swap two variables without a temporary register.
58. **Find Missing Number:** Given 1 to `N+1` with one missing, find it using XOR.
59. **Reverse Bits:** Reverse the bits of a 32-bit integer.
60. **Parity Check:** Check the parity (odd/even) of a number.

---

## Solutions (First 5 Problems)

The following solutions use NASM syntax for x86 Linux (32-bit). They utilize standard syscalls (`sys_read`, `sys_write`, `sys_exit`).

### 1. Factorial Calculation (Recursive)
**Problem:** Input `N`, Output `N!`.
**Constraints:** Input N <= 12 (to fit in 32-bit register).

```asm
section .data
    newline db 10

section .bss
    input_buf resb 32
    output_buf resb 32
    n resd 1

section .text
    global _start

_start:
    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    ; Parse N
    mov esi, input_buf
    call parse_int
    mov [n], eax

    ; Call factorial
    push dword [n]
    call factorial
    add esp, 4

    ; Print result
    call print_int
    
    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

factorial:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8] ; Get argument n
    
    cmp eax, 1
    jle .base_case
    
    dec eax
    push eax
    call factorial
    add esp, 4
    
    mov ebx, [ebp+8]
    mul ebx          ; edx:eax = eax * ebx
    jmp .end

.base_case:
    mov eax, 1
    
.end:
    pop ebp
    ret

; --- Helper: Parse Integer ---
parse_int:
    xor eax, eax
.next_digit:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .done
    cmp edx, '9'
    jg .done
    sub edx, '0'
    imul eax, 10
    add eax, edx
    inc esi
    jmp .next_digit
.done:
    ret

; --- Helper: Print Integer ---
print_int:
    mov ecx, output_buf
    add ecx, 31
    mov byte [ecx], 0
    mov ebx, 10
.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .loop
    
    mov edx, output_buf
    add edx, 31
    sub edx, ecx
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
```

### 2. Fibonacci Sequence
**Problem:** Input N. Print the first N Fibonacci numbers (0 1 1 2 3...).

```asm
section .data
    space db ' '
    newline db 10

section .bss
    input_buf resb 32
    output_buf resb 32
    n resd 1
    a resd 1
    b resd 1
    temp resd 1

section .text
    global _start

_start:
    ; Read N
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    mov esi, input_buf
    call parse_int
    mov [n], eax

    ; Initialize Fib(0) and Fib(1)
    mov dword [a], 0
    mov dword [b], 1
    
    ; Handle N=0
    cmp dword [n], 0
    jle .exit

    ; Print first term (0)
    mov eax, [a]
    call print_int
    dec dword [n]
    jz .exit_newline
    
    call print_space

    ; Print second term (1)
    mov eax, [b]
    call print_int
    dec dword [n]
    jz .exit_newline
    
    call print_space

.fib_loop:
    ; temp = a + b
    mov eax, [a]
    add eax, [b]
    mov [temp], eax
    
    ; Print temp
    call print_int
    
    ; Update a = b, b = temp
    mov eax, [b]
    mov [a], eax
    mov eax, [temp]
    mov [b], eax
    
    dec dword [n]
    jz .exit_newline
    
    call print_space
    jmp .fib_loop

.exit_newline:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_space:
    push eax
    push ebx
    push ecx
    push edx
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 0x80
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; --- Helper: Parse Integer ---
parse_int:
    xor eax, eax
.next_digit:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .done
    cmp edx, '9'
    jg .done
    sub edx, '0'
    imul eax, 10
    add eax, edx
    inc esi
    jmp .next_digit
.done:
    ret

; --- Helper: Print Integer ---
print_int:
    mov ecx, output_buf
    add ecx, 31
    mov byte [ecx], 0
    mov ebx, 10
.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .loop
    
    mov edx, output_buf
    add edx, 31
    sub edx, ecx
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
```

### 3. Prime Checker
**Problem:** Input N. Output "Prime" or "Not Prime".

```asm
section .data
    msg_prime db "Prime", 10
    len_prime equ $ - msg_prime
    msg_not   db "Not Prime", 10
    len_not   equ $ - msg_not

section .bss
    input_buf resb 32
    n resd 1

section .text
    global _start

_start:
    ; Read N
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    mov esi, input_buf
    call parse_int
    mov [n], eax

    ; Check if N < 2
    cmp eax, 2
    jl .not_prime

    ; Loop from i = 2 to i*i <= n
    mov ecx, 2      ; Divisor

.check_loop:
    mov eax, ecx
    mul ecx         ; eax = i * i
    cmp eax, [n]
    jg .is_prime    ; if i*i > n, we found no divisors

    ; Check divisibility
    mov eax, [n]
    xor edx, edx
    div ecx         ; eax / ecx, remainder in edx
    test edx, edx
    jz .not_prime   ; Remainder 0 implies composite

    inc ecx
    jmp .check_loop

.is_prime:
    mov ecx, msg_prime
    mov edx, len_prime
    jmp .print_result

.not_prime:
    mov ecx, msg_not
    mov edx, len_not

.print_result:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

; --- Helper: Parse Integer ---
parse_int:
    xor eax, eax
.next_digit:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .done
    cmp edx, '9'
    jg .done
    sub edx, '0'
    imul eax, 10
    add eax, edx
    inc esi
    jmp .next_digit
.done:
    ret
```

### 4. Greatest Common Divisor (GCD)
**Problem:** Input two integers A and B separated by space. Output their GCD using Euclid's Algorithm.

```asm
section .data
    newline db 10

section .bss
    input_buf resb 64
    output_buf resb 32
    num1 resd 1
    num2 resd 1

section .text
    global _start

_start:
    ; Read Input
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 64
    int 0x80

    ; Parse First Number
    mov esi, input_buf
    call parse_int_skip
    mov [num1], eax

    ; Parse Second Number (esi is already at next pos)
    call parse_int_skip
    mov [num2], eax

    ; Euclidean Algorithm
    ; while(b != 0) { t = b; b = a % b; a = t; }
    mov eax, [num1] ; a
    mov ebx, [num2] ; b

.gcd_loop:
    test ebx, ebx
    jz .done
    
    xor edx, edx
    div ebx         ; edx = a % b
    
    mov eax, ebx    ; a = old b
    mov ebx, edx    ; b = remainder
    jmp .gcd_loop

.done:
    ; Result is in eax
    call print_int
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

; Revised parser that skips non-digits automatically
parse_int_skip:
    xor eax, eax
.skip:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .next_char
    cmp edx, '9'
    jle .digits
.next_char:
    inc esi
    jmp .skip
.digits:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .ret
    cmp edx, '9'
    jg .ret
    sub edx, '0'
    imul eax, 10
    add eax, edx
    inc esi
    jmp .digits
.ret:
    ret

; --- Helper: Print Integer ---
print_int:
    mov ecx, output_buf
    add ecx, 31
    mov byte [ecx], 0
    mov ebx, 10
.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .loop
    
    mov edx, output_buf
    add edx, 31
    sub edx, ecx
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
```

### 5. Least Common Multiple (LCM)
**Problem:** Input A and B. Output LCM(A, B). Logic: LCM(a, b) = (a * b) / GCD(a, b)

```asm
section .data
    newline db 10

section .bss
    input_buf resb 64
    output_buf resb 32
    num1 resd 1
    num2 resd 1
    gcd_res resd 1

section .text
    global _start

_start:
    ; Read Input
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 64
    int 0x80

    mov esi, input_buf
    call parse_int_skip
    mov [num1], eax
    call parse_int_skip
    mov [num2], eax

    ; Calculate GCD first
    mov eax, [num1]
    mov ebx, [num2]

.gcd_loop:
    test ebx, ebx
    jz .gcd_done
    xor edx, edx
    div ebx
    mov eax, ebx
    mov ebx, edx
    jmp .gcd_loop

.gcd_done:
    mov [gcd_res], eax

    ; Calculate LCM = (num1 * num2) / gcd
    mov eax, [num1]
    mov ebx, [num2]
    mul ebx          ; edx:eax = num1 * num2
    
    ; Divide by GCD
    div dword [gcd_res]

    ; Print Result
    call print_int
    
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

; Revised parser that skips non-digits automatically
parse_int_skip:
    xor eax, eax
.skip:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .next_char
    cmp edx, '9'
    jle .digits
.next_char:
    inc esi
    jmp .skip
.digits:
    movzx edx, byte [esi]
    cmp edx, '0'
    jl .ret
    cmp edx, '9'
    jg .ret
    sub edx, '0'
    imul eax, 10
    add eax, edx
    inc esi
    jmp .digits
.ret:
    ret

; --- Helper: Print Integer ---
print_int:
    mov ecx, output_buf
    add ecx, 31
    mov byte [ecx], 0
    mov ebx, 10
.loop:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .loop
    
    mov edx, output_buf
    add edx, 31
    sub edx, ecx
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
```