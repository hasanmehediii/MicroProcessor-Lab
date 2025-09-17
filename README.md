# NASM Assembly Language Projects

This repository contains a collection of projects and lab assignments written in NASM (Netwide Assembler) assembly language.

## Assembling and Running NASM Programs

To assemble and run the `.asm` files, you will need to have NASM and a linker (like `ld`) installed.

**1. Assemble the code:**

Use the following command to assemble the `.asm` file into an object file (`.o`):

```bash
nasm -f elf32 -o <output_file.o> <input_file.asm>
```

For example, to assemble `hello.asm`:

```bash
nasm -f elf32 -o hello.o hello.asm
```

**2. Link the object file:**

Use the following command to link the object file and create an executable:

```bash
ld -m elf_i386 -o <executable_name> <object_file.o>
```

For example, to link `hello.o`:

```bash
ld -m elf_i386 -o hello hello.o
```

**3. Run the executable:**

```bash
./<executable_name>
```

For example:

```bash
./hello
```

## Projects

### Lab-1: Introduction to NASM

*   `hello.asm`: A simple "Hello, World!" program.

### Lab-2: General-Purpose Registers

*   `gpt1.asm`: Demonstrates the use of general-purpose registers.
*   `sample.asm`: A sample program for practice.
*   **Tasks:**
    *   `task1.asm`: Solution to task 1.
    *   `task2.asm`: Solution to task 2.
    *   `task2_loop.asm`: Solution to task 2 using a loop.
    *   `task3.asm`: Solution to task 3.

### Lab-3: Arithmetic and Logic Operations

*   `code.asm`: A collection of small code snippets.
*   `GCD.asm`: Calculates the Greatest Common Divisor (GCD) of two numbers.
*   `Max_3.asm`: Finds the maximum of three numbers.
*   `Prime.asm`: Checks if a number is prime.

### Game

*   `numberguess.asm`: A simple number guessing game.

## Resources

*   **Official NASM Documentation:** [https://www.nasm.us/docs.php](https://www.nasm.us/docs.php)
*   **NASM Tutorial:** [https://asmtutor.com/](https://asmtutor.com/)
*   **x86 Assembly Guide:** [https://www.cs.virginia.edu/~evans/cs216/guides/x86.html](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html)