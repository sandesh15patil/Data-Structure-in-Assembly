.include "./include/offset.S"

.equ	N_MAX, 	100000
.equ	CAP, 	10000
.equ	TRUE,	1
.equ	FALSE, 	0

.equ	SIZE_OF_INT,	4
.equ	NULL, 			0
.equ	EXIT_SUCCESS,	1
.equ	EXIT_FAILURE,	-1

.section .rodata
	msgS1:
	.string "%d"

	msg_size_of_array:
	.string "Enter the size of array BETWEEN[1-1,00,000]:\t"

	invalid_size_of_error:
	.string "Please Enter the size BETWEEN[1-1,00,000]"

	memory_allocation_error:
	.string "Error in allocating memory"

	msg_before_sort:
	.string "Before SORT"

	msg_after_sort:
	.string "After SORT"

	msg_show_arr:
	.string "p_arr[%d]:%d\n"


.section .text
.globl	main
.type main, @function

.equ	p_arr, loc1
.equ	N, loc2

.equ	MAIN_LOCAL_STORAGE, 8

main:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$MAIN_LOCAL_STORAGE, %esp

##################
	#get_array(&p_arr, &N)
	leal	p_arr(%ebp), %eax 
	leal	N(%ebp), %edx

	pushl 	%edx
	pushl	%eax
	call	get_array
	addl	$8, %esp	

##################
	#show_array(p_arr, N, "Before SORT")
	movl	p_arr(%ebp), %eax
	movl	N(%ebp), %edx

	pushl	$msg_before_sort
	pushl	%edx
	pushl	%eax
	call	show_array
	addl	$12, %esp		 

##################
	#merge_sort(p_arr, 0, N-1)
	movl	p_arr(%ebp), %eax
	movl	$0, %ebx
	movl	N(%ebp), %ecx
	subl	$1, %ecx

	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	call 	merge_sort
	addl	$12, %esp

##################
	#show_array(p_arr, N, "After SORT")
	movl	p_arr(%ebp), %eax
	movl	N(%ebp), %edx

	pushl	$msg_after_sort
	pushl	%edx
	pushl	%eax
	call	show_array
	addl	$12, %esp

##################
	#free(p_arr)
	movl	p_arr(%ebp), %ebx
	pushl	%ebx
	call 	free
	addl	$4, %esp

	movl	$NULL, p_arr(%ebp)

	pushl	$0
	call	exit

mn_exit_failure:
	pushl	$EXIT_FAILURE
	call	exit

##################
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

	pushl	$msg_size_of_array
	call 	printf
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
	addl	$8, %esp

	movl	%eax, p_arr(%ebp)

	movl	$0, i(%ebp)

	jmp		get_array_for_cond

get_array_for:
	call	rand
	movl	$0, %edx
	movl	$CAP, %ebx
	divl	%ebx

	movl	p_arr(%ebp), %ebx
	movl	i(%ebp), %eax
	movl	%edx, (%ebx, %eax, 4)

	addl	$1, i(%ebp)

get_array_for_cond:
	movl	i(%ebp), %eax
	cmpl 	N(%ebp), %eax
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
	pushl	$invalid_size_of_error
	call	puts
	addl	$4, %esp

	jmp		mn_exit_failure


##################
.globl	show_array
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
	je 		show_array_branch

	pushl	%eax
	call	puts
	addl	$4, %esp


show_array_branch:
	movl	$0, i(%ebp)
	jmp		show_for_cond


show_for:
	movl	p_arr(%ebp), %ebx
	movl	(%ebx, %eax, 4), %edx

	pushl	%edx
	pushl	%eax
	pushl	$msg_show_arr
	call	printf
	addl	$12, %esp

	addl	$1, i(%ebp)

show_for_cond:
	movl	i(%ebp), %eax
	cmpl	N(%ebp), %eax
	jl 		show_for

	movl	%ebp, %esp
	popl	%ebp
	ret

##################
.globl merge_sort
.type merge_sort, @function

.equ	a, p1
.equ	start_index, p2
.equ	end_index, p3

.equ	mid_index, loc1

.equ	MERGE_SORT_LOCAL_STORAGE, 4

merge_sort:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$MERGE_SORT_LOCAL_STORAGE, %esp

	movl	start_index(%ebp), %eax
	cmpl	end_index(%ebp), %eax
	jge 	out_merge_sort	

	movl	start_index(%ebp), %eax
	movl	end_index(%ebp), %edx
	addl	%edx, %eax

	movl	$0, %edx
	movl	$2, %ebx
	divl	%ebx

	movl	%eax, mid_index(%ebp)

	movl	a(%ebp), %eax
	movl	start_index(%ebp), %ebx
	movl	mid_index(%ebp), %ecx

	pushl	%ecx 
	pushl	%ebx 
	pushl	%eax
	call 	merge_sort
	addl	$12, %esp

	movl	a(%ebp), %eax
	movl	mid_index(%ebp), %ebx
	addl	$1, %ebx
	movl	end_index(%ebp), %ecx 

	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	call 	merge_sort
	addl	$12, %esp

	movl	a(%ebp), %eax
	movl	start_index(%ebp), %ebx
	movl	mid_index(%ebp), %ecx
	movl	end_index(%ebp), %edx

	pushl	%edx
	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	call   	merge  
	addl	$16, %esp

out_merge_sort:
	movl	%ebp, %esp
	popl	%ebp
	ret


##################
.globl	merge
.type merge, @function

.equ	a, p1
.equ	p, p2
.equ	q, p3
.equ	r, p4

.equ	N1, loc1
.equ	N2, loc2
.equ	a1, loc3
.equ	a2, loc4
.equ	k1, loc5
.equ	k2, loc6
.equ	k, loc7

.equ	MERGE_LOCAL_STORAGE, 28

merge:
	pushl	%ebp
	movl	%esp, %ebp

	subl	$MERGE_LOCAL_STORAGE, %esp

	movl	q(%ebp), %eax
	movl	p(%ebp), %edx
	subl	%edx, %eax
	addl	$1, %eax
	movl	%eax, N1(%ebp)

	movl	r(%ebp), %eax
	movl	q(%ebp), %edx
	subl	%edx, %eax
	movl	%eax, N2(%ebp)

	movl	$NULL, a1(%ebp)
	movl	$NULL, a2(%ebp)

	movl	N1(%ebp), %eax
	pushl	$SIZE_OF_INT
	pushl	%eax
	call   	xcalloc
	movl	%eax, a1(%ebp) 


	movl	N2(%ebp), %eax
	pushl	$SIZE_OF_INT
	pushl	%eax
	call   	xcalloc
	movl	%eax, a2(%ebp)

	
	#for(k = 0; k < N1; ++k)
	movl	$0, k(%ebp)
	jmp		merge_for1_cond


merge_for1:
	movl	a(%ebp), %ebx
	movl	k(%ebp), %eax
	movl	p(%ebp), %ecx
	addl	%ecx, %eax
	movl	(%ebx, %eax, 4), %edx

	movl	a1(%ebp), %ebx
	movl	k(%ebp), %eax
	movl	%edx, (%ebx, %eax, 4)

	addl	$1, k(%ebp)

merge_for1_cond:
	movl	k(%ebp), %eax
	cmpl	N1(%ebp), %eax
	jl 		merge_for1	


	#for(k = 0; k < N2; ++k)
	movl	$0, k(%ebp)
	jmp		merge_for2_cond

merge_for2:
	movl	a(%ebp), %ebx
	movl	q(%ebp), %eax
	addl	k(%ebp), %eax
	addl	$1, %eax
	movl	(%ebx, %eax, 4), %edx

	movl	a2(%ebp), %ebx
	movl	k(%ebp), %eax
	movl	%edx, (%ebx, %eax, 4)

	addl	$1, k(%ebp)

merge_for2_cond:
	movl	k(%ebp), %eax
	cmpl	N2(%ebp), %eax
	jl 		merge_for2


	movl	$0, k(%ebp)
	movl	$0, k1(%ebp)
	movl	$0, k2(%ebp)

	jmp 	merge_main_while_cond

merge_main_while:
	# IF MAIN
	## if(a1[k1] <= a2[k2])

	movl	a1(%ebp), %ebx
	movl	k1(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	movl	a2(%ebp), %ebx
	movl	k2(%ebp), %eax
	movl	(%ebx, %eax, 4), %ecx

	cmpl	%ecx, %edx

	jg 		else_cond_outer	

	movl	a1(%ebp), %ebx
	movl	k1(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	movl	a(%ebp), %ebx
	movl	p(%ebp), %eax
	movl	k(%ebp), %ecx
	addl	%ecx, %eax
	movl	%edx, (%ebx, %eax, 4)

	addl	$1, k(%ebp)
	addl	$1, k1(%ebp)


	## if(k1 == N1)
	movl	k1(%ebp), %eax
	cmpl	N1(%ebp), %eax
	jne		merge_main_while_cond

	jmp		inner_if_while_cond

inner_if_while:
	#a[p+k] = a2[k2];
	
	movl	a2(%ebp), %ebx
	movl	k2(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	movl	a(%ebp), %ebx
	movl	p(%ebp), %eax
	movl	k(%ebp), %ecx
	addl	%ecx, %eax

	movl	%edx, (%ebx, %eax, 4)	

	addl 	$1, k(%ebp)
	addl	$1, k2(%ebp)


inner_if_while_cond:
	#while(k2 < N2)
	movl	k2(%ebp), %eax
	cmpl	N2(%ebp), %eax
	jl      inner_if_while

	jmp 	out_while_loop


	# ELSE MAIN
else_cond_outer:
	#a[p+k] = a2[k2];	
	movl	a2(%ebp), %ebx
	movl	k2(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	movl	a(%ebp), %ebx
	movl	p(%ebp), %eax
	movl	k(%ebp), %ecx
	addl	%ecx, %eax

	movl	%edx, (%ebx, %eax, 4)
	addl	$1, k(%ebp)
	addl	$1, k2(%ebp)

	## if(k2 == N2)
	movl	k2(%ebp), %eax
	cmpl	N2(%ebp), %eax
	jne		merge_main_while_cond

	#jmp 	inner_if_while_cond
	
	jmp 	inner_else_while_cond

inner_else_while:
	#a[p+k] = a1[k1];
	movl	a1(%ebp), %ebx
	movl	k1(%ebp), %eax
	movl	(%ebx, %eax, 4), %edx

	movl	a(%ebp), %ebx
	movl	p(%ebp), %eax
	movl	k(%ebp), %ecx
	addl	%ecx, %eax

	movl	%edx, (%ebx, %eax, 4)

	addl	$1, k(%ebp)
	addl	$1, k1(%ebp)	


inner_else_while_cond:
	#while(k1 < N1)
	movl	k1(%ebp), %eax
	cmpl	N1(%ebp), %eax
	jl    	inner_else_while

	jmp 	out_while_loop

merge_main_while_cond:
	jmp		merge_main_while


out_while_loop:

	#free(a1)
	movl	a1(%ebp), %ebx
	pushl	%ebx
	call 	free 
	addl	$4, %esp

	movl	$NULL, a1(%ebp)

	#free(a2);
	movl	a2(%ebp), %ebx
	pushl	%ebx
	call 	free	
	addl	$4, %esp

	movl	$NULL, a2(%ebp)

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
