gcc -o insertion_sort_c insertion_sort.c
as -o insertion_sort.o insertion_sort.S -32
ld -o insertion_sort_s insertion_sort.o -lc -dynamic-linker /lib/ld-linux.so.2 -m elf_i386 -e main
