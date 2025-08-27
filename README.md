### How to Run Code ?

 - 1. Assemble
      ```bash
      nasm -f elf64 mycode.asm -o mycode.o
      ```

 - 2. Link (disable PIE)
      ```bash
      gcc -no-pie -o mycode mycode.o
      ```

 - 3. Run
      ```bash
      ./mycode
      ```
