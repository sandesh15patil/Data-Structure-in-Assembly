gcc -o quick_sort_c quick_sort.c
as -o quick_sort.o quick_sort.S -32
ld -o quick_sort_s quick_sort.o -lc -dynamic-linker /lib/ld-linux.so.2 -m elf_i386 -e main
