gcc -o singly_circular_linked_list_c singly_circular_linked_list.c
as -o singly_circular_linked_list.o singly_circular_linked_list.S -32
ld -o singly_circular_linked_list_s singly_circular_linked_list.o -lc -dynamic-linker /lib/ld-linux.so.2 -m elf_i386 -e main
