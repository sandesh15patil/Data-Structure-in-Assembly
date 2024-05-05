.include "./include/offset.S"

.equ	N_MAX, 		100000
.equ	CAP, 		10000
.equ	EXIT_SUCCESS, 	0
.equ	EXIT_FAILURE, 	-1
.equ	SIZE_OF_INT,	4
.equ	NULL,			0

.section .rodata
	msgS1:
	.string "%d"

	msg_before_sort:
	.string "Before SORT"

	msg_after_sort:
	.string "After SORT"

	msg_size_of_array:
	.string "Enter the size of array BETWEEN[1-1,00,000]:\t"

	msg_arr:
	.string "p_arr[%d]:%d\n"

	invalid_size_error:
	.string "Please Enter the size BETWEEN[1-1,00,000]"

	memory_allocation_error:
	.string "Error in allocating memory"


.section .text
.globl main
.type main, @function

.equ	p_arr, loc1
.equ	N, loc2

.equ	MAIN_LOCAL_STORAGE, 8

main:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$MAIN_LOCAL_STORAGE, %esp

####################
	#get_array(&p_arr, &N)
	leal	p_arr(%ebp), %eax
	leal	N(%ebp), %edx

	pushl	%edx
	pushl	%eax
	call	get_array
	addl	$8, %esp

####################
	#show_array(p_arr, N, "Before SORT")
	movl	p_arr(%ebp), %eax
	movl	N(%ebp), %edx
	pushl	$msg_before_sort
	pushl	%edx
	pushl	%eax
	call	show_array
	addl	$8, %esp


####################
	#insertion_sort(p_arr, N)
	movl	p_arr(%ebp), %eax
	movl	N(%ebp), %edx
	pushl	%edx
	pushl	%eax
	call	insertion_sort
	addl	$8, %esp


####################
	#show_array(p_arr, N, "After SORT")
	movl	p_arr(%ebp), %eax
	movl	N(%ebp), %edx
	pushl	$msg_after_sort
	pushl	%edx
	pushl	%eax
	call	show_array
	addl	$8, %esp

####################
	#free(p_arr)
	movl	p_arr(%ebp), %ebx
	pushl	%ebx
	call	free
	addl	$4, %esp

	movl	$NULL, p_arr(%ebp)

	pushl	$0
	call	exit


.globl	get_array
.type get_array, @function

.equ	pp_arr, p1
.equ	pN, p2

.equ	p_arr, loc1
.equ	N, loc2
.equ	i, loc3

.equ	GET_ARRAY_LOCAL_STORAGE, 16

get_array:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$GET_ARRAY_LOCAL_STORAGE, %esp

	pushl	$msg_size_of_array
	call	printf
	addl	$4, %esp

	leal	loc2(%ebp), %ebx
	pushl	%ebx
	pushl	$msgS1
	call	scanf
	addl	$8, %esp

	movl	N(%ebp), %eax
	cmpl	$0, %eax
	jle		bad_array_size
	
	cmpl	$N_MAX, %eax
	jg		bad_array_size

	movl	N(%ebp), %eax
	pushl	$SIZE_OF_INT
	pushl	%eax
	call	xcalloc
	addl	$8, %esp
	movl	%eax, p_arr(%ebp)

	movl	$0, i(%ebp)

	jmp		get_array_cond_1

get_array_for_1:
	
	call	rand
	movl	$0, %edx
	movl	$CAP, %ebx
	divl	%ebx

	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax
	movl	%edx, (%ebx, %eax, 4)

	addl	$1, i(%ebp)

get_array_cond_1:
	movl	i(%ebp), %eax
	cmpl	N(%ebp), %eax
	jl 		get_array_for_1

	movl	p_arr(%ebp), %eax
	movl	pp_arr(%ebp), %ebx
	movl	%eax, (%ebx)

	movl	N(%ebp), %eax
	movl	pN(%ebp), %ebx
	movl	%eax, (%ebx)

	movl	%ebp, %esp
	popl	%ebp
	ret

bad_array_size:
	pushl	$invalid_size_error
	call	puts
	addl	$4, %esp

	jmp		mn_exit_failure

mn_memory_allocation_error:
	pushl	$memory_allocation_error
	call	puts
	addl	$4, %esp

	jmp		mn_exit_failure

mn_exit_failure:
	pushl	$EXIT_FAILURE
	call	exit


.globl insertion_sort
.type insertion_sort, @function

.equ	p_arr, p1
.equ	N, p2

.equ	i, loc1
.equ	j, loc2
.equ	key, loc3

.equ	INSERTION_SORT_LOCAL_STORAGE, 	12

insertion_sort:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$INSERTION_SORT_LOCAL_STORAGE, %esp

	movl	$1, j(%ebp)
	jmp		insertion_sort_outer_loop_cond

insertion_sort_outer_loop:
	
	movl	p_arr(%ebp), %ebx
	movl	j(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx
	movl	%edx, key(%ebp)

	subl	$1, %eax
	movl	%eax, i(%ebp)

	jmp 	insertion_sort_inner_loop_cond	


		insertion_sort_inner_loop:
			movl	i(%ebp), %eax
			addl	$1, %eax
			movl	%ecx, (%ebx, %eax, 4)

			subl	$1, i(%ebp)


		insertion_sort_inner_loop_cond:
			movl	i(%ebp), %eax
			cmpl	$-1, %eax
			jng		insertion_sort_inner_loop_out

			movl	p_arr(%ebp), %ebx
			movl	i(%ebp), %eax
			movl	(%ebx, %eax, 4), %ecx 

			movl	key(%ebp), %edx

			cmpl	%edx, %ecx
			jg		insertion_sort_inner_loop
			

insertion_sort_inner_loop_out:	
	# p_arr[i+1] = key;
	movl	key(%ebp), %edx
	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax
	addl	$1, %eax

	movl	%edx, (%ebx, %eax, 4)


	addl	$1, j(%ebp)

insertion_sort_outer_loop_cond:
	movl	j(%ebp), %eax
	cmpl	N(%ebp), %eax
	jl 		insertion_sort_outer_loop	

	movl	%ebp, %esp
	popl	%ebp
	ret


###########################
.globl show_array
.type show_array, @function

.equ	p_arr, p1 
.equ	N, p2
.equ	msg, p3

.equ	i, loc1

.equ	SHOW_LOCAL_STORAGE, 4


show_array:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$SHOW_LOCAL_STORAGE, %esp

	movl	msg(%ebp), %eax
	cmpl	$NULL, %eax
	je		show_array_branch

	pushl	%eax
	call	puts
	addl	$4, %esp


show_array_branch:
	movl	$0, i(%ebp)
	jmp		show_cond_1

show_for_1:
	
	movl	p_arr(%ebp), %ebx
	movl	(%ebx, %eax, 4), %edx

	pushl	%edx
	pushl	%eax
	pushl	$msg_arr 
	call	printf
	addl	$12, %esp
	
	addl	$1, i(%ebp)


show_cond_1:
	movl	i(%ebp), %eax
	movl	N(%ebp), %edx
	cmpl	%edx, %eax
	jl		show_for_1


	movl	%ebp, %esp
	popl	%ebp
	ret


##################
.globl	xcalloc
.type xcalloc, @function

.equ n, p1
.equ size, p2

.equ temp, loc1

xcalloc:
	pushl	%ebp
	movl	%esp, %ebp


	movl	n(%ebp), %eax
	movl	size(%ebp), %edx

	pushl 	%edx
	pushl	%eax
	call 	calloc
	cmpl	$NULL, %eax
	je 		mem_error

	movl	%ebp, %esp
	popl	%ebp
	ret		

mem_error:
	pushl	$memory_allocation_error
	call 	puts
	addl	$4, %esp

	jmp 	mn_exit_failure
