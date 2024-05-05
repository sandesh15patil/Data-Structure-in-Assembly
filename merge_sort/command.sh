gcc -o merge_sort_c merge_sort.c
as -o merge_sort.o merge_sort.S -32
ld -o merge_sort_s merge_sort.o -lc -dynamic-linker /lib/ld-linux.so.2 -m elf_i386 -e main
