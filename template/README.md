# Assembly Lab Practice

This folder contains 20 basic assembly lab questions and their solutions.

## Questions

The questions are listed in `questions.txt`.

## Solutions

The solutions are in the `s*.asm` files, where `*` is the question number.

## How to Run

To assemble and run the assembly code, you need `nasm` and `ld`. You can use the following commands:

```bash
# To assemble the code (e.g., for s1.asm)
nasm -f elf32 s1.asm -o s1.o

# To link the object file
ld -m elf_i386 s1.o -o s1

# To run the executable
./s1
```

Replace `s1` with the corresponding solution number you want to run.
nasm -f elf32 s1.asm -o s1.o && ld -m elf_i386 s1.o -o s1 && ./s1