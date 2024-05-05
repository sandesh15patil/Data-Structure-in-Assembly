.include "./include/offset.S"

.equ	N_MAX, 	100000
.equ	CAP,	10000

.equ	SIZE_OF_INT,	4
.equ	EXIT_SUCCESS, 	0
.equ	EXIT_FAILURE,	-1
.equ	NULL, 			0

.equ	TRUE,	1
.equ	FALSE,	0


.section .rodata
	msgS1:
	.string "%d"

	msg_before_sort:
	.string "Before SORT"

	msg_after_sort:
	.string "After SORT"

	memory_allocation_error:
	.string "Error in allocating memory"

	msg_array_size:
	.string "Enter the size of array BETWEEN[1-1,00,000]:\t"

	bad_array_size:
	.string "Please Enter the size BETWEEN[1-1,00,000]"

	msg_show_array:
	.string "p_arr[%d]:%d\n"


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

###############
	#get_array(&p_arr, &N)
	leal	p_arr(%ebp), %eax 
	leal	N(%ebp), %ebx

	pushl	%ebx
	pushl	%eax
	call	get_array
	addl	$8, %esp	

###############
	#show_array(p_arr, N, "Before SORT")
	movl	p_arr(%ebp), %eax
	movl	N(%ebp), %ebx 

	pushl	$msg_before_sort
	pushl	%ebx
	pushl	%eax
	call	show_array
	addl	$12, %esp

###############
	#quick_sort(p_arr, 0, N-1)
	movl	p_arr(%ebp), %eax
	movl	$0, %ebx
	movl	N(%ebp), %ecx 
	subl	$1, %ecx

	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	call	quick_sort
	addl	$12, %esp

###############
	#show_array(p_arr, N, "After SORT")
	movl	p_arr(%ebp), %eax
	movl	N(%ebp), %ebx 

	pushl	$msg_after_sort
	pushl	%ebx
	pushl	%eax
	call	show_array
	addl	$12, %esp

###############
	#free(p_arr)
	movl	p_arr(%ebp), %ebx
	pushl	%ebx
	call 	free
	addl	$4, %esp

	movl	$NULL, p_arr(%ebp)

	###############

mn_exit_success:
	pushl	$EXIT_SUCCESS
	call	exit


mn_exit_failure:
	pushl	$EXIT_FAILURE
	call	exit


###############
.globl	get_array
.type get_array, @function

.equ	pp_arr, p1 
.equ	pN, p2

.equ	p_arr, loc1
.equ	N, loc2
.equ	i, loc3

.equ	GET_ARRAY_LOCAL_STORAGE, 12

get_array:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$GET_ARRAY_LOCAL_STORAGE, %esp

	movl	$NULL, p_arr(%ebp)

	pushl	$msg_array_size
	call	printf
	addl	$4, %esp

	leal	N(%ebp), %ebx
	pushl	%ebx
	pushl	$msgS1
	call	scanf
	addl	$8, %esp


	movl	N(%ebp), %eax
	cmpl	$0, %eax
	jle		bad_size_array	

	cmpl	$N_MAX, %eax
	jg		bad_size_array

	
	movl	N(%ebp), %eax

	pushl	$SIZE_OF_INT
	pushl	%eax
	call	xcalloc

	movl	%eax, p_arr(%ebp)

	movl	$0, i(%ebp)
	jmp		get_array_for_cond

get_array_for:
	call 	rand
	movl	$0, %edx
	movl	$CAP, %ebx
	divl	%ebx

	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax

	movl	%edx, (%ebx, %eax, 4)

	addl	$1, i(%ebp)		

get_array_for_cond:
	movl	i(%ebp), %eax
	cmpl	N(%ebp), %eax
	jl 		get_array_for

	movl	p_arr(%ebp), %eax
	movl	pp_arr(%ebp), %ebx

	movl	%eax, (%ebx)

	movl	N(%ebp), %eax
	movl	pN(%ebp), %ebx

	movl	%eax, (%ebx)

	movl	%ebp, %esp
	popl	%ebp
	ret


bad_size_array:
	pushl	$bad_array_size
	call	puts
	addl	$4, %esp

	jmp		mn_exit_failure

bad_memory_error:
	pushl	$memory_allocation_error
	call 	puts
	addl	$4, %esp

	jmp		mn_exit_failure


###############
.globl show_array
.type show_array, @function

.equ	p_arr, p1
.equ	N, p2
.equ	msg, p3

.equ	i, loc1

.equ	SHOW_ARRAY_LOCAL_STORAGE, 4

show_array:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$SHOW_ARRAY_LOCAL_STORAGE, %esp

	movl	msg(%ebp), %eax
	cmpl	$NULL, %eax
	je 		show_array_for_branch

	pushl	%eax
	call 	puts
	addl	$4, %esp

show_array_for_branch:
	movl	$0, i(%ebp)
	jmp		show_array_for_cond	
	

show_array_for:
	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	pushl	%edx
	pushl	%eax
	pushl	$msg_show_array
	call    printf
	addl	$12, %esp
	
	addl	$1, i(%ebp)

show_array_for_cond:
	movl	i(%ebp), %eax
	cmpl	N(%ebp), %eax
	jl 		show_array_for	


	movl	%ebp, %esp
	popl	%ebp
	ret


###############
.globl	quick_sort
.type quick_sort, @function 

.equ	p_arr, p1
.equ	p, p2
.equ	r, p3

.equ	q, loc1

.equ	QUICK_SORT_LOCAL_STORAGE, 4

quick_sort:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$QUICK_SORT_LOCAL_STORAGE, %esp

	movl	p(%ebp), %eax
	cmpl	r(%ebp), %eax
	jge		out_quick_sort

	#q = partition(p_arr, p, r);
	movl	p_arr(%ebp), %eax
	movl	p(%ebp), %ebx
	movl	r(%ebp), %ecx

	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	call 	partition
	addl	$12, %esp

	movl	%eax, q(%ebp)

	#quick_sort(p_arr, p, q-1);
	movl	p_arr(%ebp), %eax
	movl	p(%ebp), %ebx
	movl	q(%ebp), %ecx
	subl	$1, %ecx

	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	call 	quick_sort
	addl	$12, %esp

	#quick_sort(p_arr, q+1, r);
	movl	p_arr(%ebp), %eax
	movl	q(%ebp), %ebx
	addl	$1, %ebx
	movl	r(%ebp), %ecx

	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	call 	quick_sort
	addl	$12, %esp	

out_quick_sort:
	movl	%ebp, %esp
	popl	%ebp
	ret

###############
.globl	partition
.type partition, @function

.equ	p_arr, p1
.equ	p, p2
.equ	r, p3

.equ	i, loc1
.equ	j, loc2
.equ	pivot, loc3
.equ	tmp, loc4

.equ	PARTITION_LOCAL_STORAGE, 16	

partition:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$PARTITION_LOCAL_STORAGE, %esp

	movl	p_arr(%ebp), %ebx
	movl	r(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	movl	%edx, pivot(%ebp)

	movl	p(%ebp), %eax
	subl	$1, %eax
	movl	%eax, i(%ebp)

	movl	p(%ebp), %eax
	movl	%eax, j(%ebp)

	jmp		partition_for_cond


partition_for:
	movl	p_arr(%ebp), %ebx
	movl	j(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	cmpl	pivot(%ebp), %edx
	jg 		out_if_cond	

	#i = i+1;
	addl	$1, i(%ebp)

	#tmp = p_arr[j];
	movl	p_arr(%ebp), %ebx
	movl	j(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx
	movl	%edx, tmp(%ebp)

	#p_arr[j] = p_arr[i];
	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	movl	j(%ebp), %ecx
	movl	%edx, (%ebx, %ecx, 4)

	#p_arr[i] = tmp;
	movl	tmp(%ebp), %edx

	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax

	movl	%edx, (%ebx, %eax, 4)

out_if_cond:
	addl	$1, j(%ebp)

partition_for_cond:
	movl	j(%ebp), %eax
	cmpl	r(%ebp), %eax
	jl 		partition_for

	#tmp = p_arr[r];
	movl	p_arr(%ebp), %ebx
	movl	r(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx
	movl	%edx, tmp(%ebp)

	#p_arr[r] = p_arr[i+1];
	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax
	addl	$1, %eax
	movl	(%ebx, %eax, 4), %edx

	movl	p_arr(%ebp), %ebx
	movl	r(%ebp), %eax
	movl	%edx, (%ebx, %eax, 4)
	
	#p_arr[i+1] = tmp;
	movl	tmp(%ebp), %edx
	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax
	addl	$1, %eax

	movl	%edx, (%ebx, %eax, 4)


	#return (i+1);
	movl	i(%ebp), %eax
	addl	$1, %eax

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
	call 	printf
	addl	$4, %esp

	jmp 	mn_exit_failure
