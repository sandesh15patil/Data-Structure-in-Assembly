# Include general offset file
.include "./include/offset.S"

# Offset of members of struct node
# with respect to base address of ANY 
# instance of struct node 

.equ    data,   0
.equ    next,   4


# Symbolic Constants
.equ    SUCCESS,                 1
.equ    LIST_DATA_NOT_FOUND,     2
.equ    LIST_EMPTY,              3

.equ    TRUE,                    1
.equ    FALSE,                   0

.equ    SIZE_OF_NODE,            8
.equ    NULL,                    0

.equ    EXIT_SUCCESS,            0
.equ    EXIT_FAILURE,            1


.section .rodata
    msgP1:
    .string "Start of the Assembly Program"

    msg_calloc_error:
    .string "fatal:calloc:out of memory"

    msg_start:
    .string "[START]<->"

    msg_end:
    .string "[END]"

    msg_before_insert_start:
    .string "Before insert_start()"

    msg_after_insert_start:
    .string "After insert_start()"

    msg_before_insert_end:
    .string "Before insert_end()"

    msg_after_insert_end:
    .string "After insert_end()"

    msg_after_insert_after:
    .string "After insert_after()"

    msg_after_insert_before:
    .string "After insert_before()"

    msg_current_start:
    .string "Current Start:%d\n"

    msg_current_end:
    .string "Current End:%d\n"

    msg_removed_start:
    .string "Removed Start:%d\n"

    msg_removed_end:
    .string "Removed End:%d\n"

    msg_after_pop_start:
    .string "after pop_start():"

    msg_after_pop_end:
    .string "after pop_end():"

    msg_after_remove_start:
    .string "After remove_start():"

    msg_after_remove_end:
    .string "After remove_end():"

    msg_after_remove_data:
    .string "After remove_data():"

    msg_length:
    .string "LENGTH=%d\n"

    msg_data:
    .string "[%d]<->"

    msg_find_data_present:
    .string "100 is present in list"

    msg_find_data_not_present:
    .string "-100 is not in list"

    msg_list_is_not_empty:
    .string "List is not empty now"

    msg_list_is_empty:
    .string "List is empty now"

    msg_node_deleted:
    .string "Node deleted: %d\n"

.section .text

.globl main
.type main, @function

.equ    p_head_node, loc1
.equ    data, loc2

.equ    MAIN_LOCAL_STORAGE, 8

main:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $MAIN_LOCAL_STORAGE, %esp

    movl    $NULL, p_head_node(%ebp)
##################
    # p_head_node = create_list();
    call    create_list
    movl    %eax, p_head_node(%ebp)
##################
    ##if(is_list_empty(p_head_node) == TRUE)
    #    puts("List is empty now");
    movl    p_head_node(%ebp), %ebx
    pushl   %ebx
    call    is_list_empty
    addl    $4, %esp
    cmpl    $TRUE, %eax
    jne     main_is_list_empty_true_continue

    pushl   $msg_list_is_empty
    call    puts
    addl    $4, %esp

main_is_list_empty_true_continue:
##################
    # show_list(p_head_node, "Before insert start");
    movl    p_head_node(%ebp), %eax
    pushl   $msg_before_insert_start
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    #for(data= 5; data <= 25; data+=5)
    #    insert_start(p_head_node, data);
    movl    $5, data(%ebp)
    jmp     main_for_cond_insert_start

main_for_insert_start:
    movl    p_head_node(%ebp), %ebx
    pushl   %eax
    pushl   %ebx
    call    insert_start
    addl    $8, %esp 

    movl    data(%ebp), %eax
    addl    $5, %eax
    movl    %eax, data(%ebp)

main_for_cond_insert_start:
    movl    data(%ebp), %eax
    cmpl    $25, %eax
    jle     main_for_insert_start
##################
    #show_list(p_head_node, "After insert start");
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_insert_start
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    #show_list(p_head_node, "Before insert end");
    movl    p_head_node(%ebp), %eax
    pushl   $msg_before_insert_end
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    #for(data= 7; data <= 35; data+=7)
    #    insert_end(p_head_node, data);
    movl    $7, data(%ebp)
    jmp     main_for_cond_insert_end

main_for_insert_end:
    
    movl    p_head_node(%ebp), %ebx
    pushl   %eax
    pushl   %ebx
    call    insert_end
    addl    $8, %esp 

    movl    data(%ebp), %eax
    addl    $7, %eax
    movl    %eax, data(%ebp)

main_for_cond_insert_end:
    movl    data(%ebp), %eax
    cmpl    $35, %eax
    jle     main_for_insert_end
##################
    #show_list(p_head_node, "After insert end");
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_insert_end
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    #insert_after(p_head_node, 5, 100); 
    movl    p_head_node(%ebp), %ebx
    pushl   $100
    pushl   $5
    pushl   %ebx
    call    insert_after
    addl    $12, %esp

    #show_list(p_head_node, "After insert_after():"); 
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_insert_after
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    #insert_before(p_head_node, 7, 200); 
    movl    p_head_node(%ebp), %ebx
    pushl   $200
    pushl   $7
    pushl   %ebx
    call    insert_before
    addl    $12, %esp

    #show_list(p_head_node, "After insert_before():"); 
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_insert_before
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    #get_start(p_head_node, &data); 
    movl    p_head_node(%ebp), %eax
    leal    data(%ebp), %ebx

    pushl   %ebx
    pushl   %eax
    call    get_start
    addl    $8, %esp

    #printf("Current start:%d\n", data);
    movl    data(%ebp), %ecx
    pushl   %ecx
    pushl   $msg_current_start
    call    printf
    addl    $8, %esp
##################
    #get_end(p_head_node, &data);  
    movl    p_head_node(%ebp), %eax
    leal    data(%ebp), %ebx

    pushl   %ebx
    pushl   %eax
    call    get_end
    addl    $8, %esp

    #printf("Current end:%d\n", data);
    movl    data(%ebp), %ecx
    pushl   %ecx
    pushl   $msg_current_end
    call    printf
    addl    $8, %esp
##################
    #pop_start(p_head_node, &data); 
    movl    p_head_node(%ebp), %eax
    leal    data(%ebp), %ebx

    pushl   %ebx
    pushl   %eax
    call    pop_start
    addl    $8, %esp

    #printf("Removed Start:%d\n", data); 
    movl    data(%ebp), %ecx
    pushl   %ecx
    pushl   $msg_removed_start
    call    printf
    addl    $8, %esp

    #show_list(p_head_node, "after pop_start():"); 
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_pop_start
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    # pop_end(p_head_node, &data);
    movl    p_head_node(%ebp), %eax
    leal    data(%ebp), %ebx

    pushl   %ebx
    pushl   %eax
    call    pop_end
    addl    $8, %esp

    # printf("Removed End:%d\n", data);
    movl    data(%ebp), %ecx
    pushl   %ecx
    pushl   $msg_removed_end
    call    printf
    addl    $8, %esp

    # show_list(p_head_node, "after pop_end():"); 
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_pop_end
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    # remove_start(p_head_node); 
    movl    p_head_node(%ebp), %eax
    pushl   %eax
    call    remove_start
    addl    $4, %esp

    # show_list(p_head_node, "After remove_start():"); 
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_remove_start
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    # remove_end(p_head_node); 
    movl    p_head_node(%ebp), %eax
    pushl   %eax
    call    remove_end
    addl    $4, %esp

    # show_list(p_head_node, "After remove_end():"); 
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_remove_end
    pushl   %eax
    call    show_list
    addl    $8, %esp
##################
    # printf("LENGTH=%d\n", get_length(p_head_node)); 
    movl    p_head_node(%ebp), %ebx
    pushl   %ebx
    call    get_length
    addl    $4, %esp

    pushl   %eax
    pushl   $msg_length
    call    printf
    addl    $4, %esp
##################
    # remove_data(p_head_node, 5); 
    movl    p_head_node(%ebp), %ebx
    pushl   $5
    pushl   %ebx
    call    remove_data
    addl    $8, %esp

    # show_list(p_head_node, "After remove_data():"); 
    movl    p_head_node(%ebp), %eax
    pushl   $msg_after_remove_data
    pushl   %eax
    call    show_list
    addl    $8, %esp
################## 
    ##if(find(p_head_node, 100) == TRUE)
    #   puts("100 is present in list");   
    movl    p_head_node(%ebp), %ebx
    pushl   $100
    pushl   %ebx
    call    find
    addl    $8, %esp

    cmpl    $TRUE, %eax
    jne     main_find_true_continue

    pushl   $msg_find_data_present
    call    puts
    addl    $4, %esp

main_find_true_continue:
##################
    ##if(find(p_head_node, -100) == FALSE)
    #    puts("-100 is not in list");
    movl    p_head_node(%ebp), %ebx
    pushl   $-100
    pushl   %ebx
    call    find
    addl    $8, %esp

    cmpl    $FALSE, %eax
    jne     main_find_false_continue

    pushl   $msg_find_data_not_present
    call    puts
    addl    $4, %esp

main_find_false_continue:
##################
    ##if(is_list_empty(p_head_node) == FALSE)
    #   puts("List is not empty now");
    movl    p_head_node(%ebp), %ebx
    pushl   %ebx
    call    is_list_empty
    addl    $4, %esp
    cmpl    $FALSE, %eax
    jne     main_is_list_empty_continue

    pushl   $msg_list_is_not_empty
    call    puts
    addl    $4, %esp

main_is_list_empty_continue:
##################
    #destroy_list(p_head_node); 
    movl    p_head_node(%ebp), %ebx
    pushl   %ebx
    call    destroy_list
    addl    $4, %esp

    movl    $NULL, p_head_node(%ebp)
##################
    pushl   $EXIT_SUCCESS
    call    exit

##################
.globl create_list
.type create_list, @function

.equ    p_head_node, loc1

.equ    CREATE_LIST_LOCAL_STORAGE, 4

create_list:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $CREATE_LIST_LOCAL_STORAGE, %esp

    movl    $NULL, p_head_node(%ebp)

    pushl   $SIZE_OF_NODE
    pushl   $1
    call    xcalloc
    addl    $8, %esp

    movl    %eax, p_head_node(%ebp)

    movl    p_head_node(%ebp), %ebx

    movl    $500, data(%ebx)
    movl    %eax, next(%ebx)

    movl    p_head_node(%ebp), %eax

    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl insert_start   
.type insert_start, @function

.equ    p_head_node, p1
.equ    new_data, p2

.equ    p_new_node, loc1

.equ    INSERT_START_LOCAL_STORAGE, 4

insert_start:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $INSERT_START_LOCAL_STORAGE, %esp

    movl    $NULL, p_new_node(%ebp)

    movl    $SIZE_OF_NODE, %eax

    pushl   %eax
    pushl   $1
    call    xcalloc
    addl    $8, %esp

    movl    %eax, p_new_node(%ebp)

    movl    new_data(%ebp), %edx
    movl    %edx, data(%eax)
    movl    $NULL, next(%eax)

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, next(%eax)

    movl    %eax, next(%ebx)

    movl    $SUCCESS, %eax

    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl insert_end   
.type insert_end, @function

.equ    p_head_node, p1
.equ    new_data, p2

.equ    p_new_node, loc1
.equ    p_end_node, loc2

.equ    INSERT_END_LOCAL_STORAGE, 8

insert_end:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $INSERT_END_LOCAL_STORAGE, %esp

    movl    $NULL, p_new_node(%ebp)
    movl    $NULL, p_end_node(%ebp)

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, p_end_node(%ebp)
    jmp     insert_end_for_cond

insert_end_for:
    movl    %ebx, p_end_node(%ebp)    
    
insert_end_for_cond:
    movl    p_end_node(%ebp), %ebx
    movl    next(%ebx), %ebx
    cmpl    p_head_node(%ebp), %ebx
    jne     insert_end_for

    movl    $SIZE_OF_NODE, %eax

    pushl   %eax
    pushl   $1
    call    xcalloc
    addl    $8, %esp

    movl    %eax, p_new_node(%ebp)

    movl    new_data(%ebp), %edx
    movl    %edx, data(%eax)
    movl    $NULL, next(%eax)

    movl    p_end_node(%ebp), %ebx
    movl    %eax, next(%ebx)

    movl    p_head_node(%ebp), %ebx
    movl    %ebx, next(%eax)

    movl    $SUCCESS, %eax

    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl insert_after   
.type insert_after, @function

.equ    p_head_node, p1
.equ    e_data, p2
.equ    new_data, p3

.equ    p_ext_node, loc1
.equ    p_new_node, loc2

.equ    INSERT_AFTER_LOCAL_STORAGE, 8

insert_after:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $INSERT_AFTER_LOCAL_STORAGE, %esp

    movl    $NULL, p_ext_node(%ebp)
    movl    $NULL, p_new_node(%ebp)

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, p_ext_node(%ebp)
    jmp     insert_after_for_cond

insert_after_for:
    movl    data(%ebx), %edx
    cmpl    e_data(%ebp), %edx
    jne     insert_after_for_if_out

    jmp     insert_after_for_out

insert_after_for_if_out:            
    movl    next(%ebx), %ebx
    movl    %ebx, p_ext_node(%ebp)    
    
insert_after_for_cond:
    movl    p_ext_node(%ebp), %ebx
    cmpl    p_head_node(%ebp), %ebx
    jne     insert_after_for

insert_after_for_out:
    movl    p_ext_node(%ebp), %ebx
    cmpl    p_head_node(%ebp), %ebx
    je      insert_after_data_not_found

    movl    $SIZE_OF_NODE, %eax

    pushl   %eax
    pushl   $1
    call    xcalloc
    addl    $8, %esp

    movl    %eax, p_new_node(%ebp)

    movl    new_data(%ebp), %edx
    movl    %edx, data(%eax)
    movl    $NULL, next(%eax)

    movl    p_ext_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, next(%eax)

    movl    %eax, next(%ebx)

    movl    $SUCCESS, %eax
    jmp     insert_after_out

insert_after_data_not_found:
    movl    $LIST_DATA_NOT_FOUND, %eax

insert_after_out:
    movl    %ebp, %esp
    popl    %ebp
    ret 
##################
.globl insert_before   
.type insert_before, @function

.equ    p_head_node, p1
.equ    e_data, p2
.equ    new_data, p3

.equ    p_ext_node, loc1
.equ    p_ext_node_prev, loc2
.equ    p_new_node, loc3

.equ    INSERT_BEFORE_LOCAL_STORAGE, 12

insert_before:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $INSERT_BEFORE_LOCAL_STORAGE, %esp

    movl    $NULL, p_ext_node(%ebp)
    movl    $NULL, p_ext_node_prev(%ebp)
    movl    $NULL, p_new_node(%ebp)

    movl    p_head_node(%ebp), %ebx
    movl    %ebx, p_ext_node_prev(%ebp)

    movl    next(%ebx), %edx
    movl    %edx, p_ext_node(%ebp)
    jmp     insert_before_for_cond

insert_before_for:
    movl    data(%ebx), %edx
    cmpl    e_data(%ebp), %edx
    jne     insert_before_for_if_out

    jmp     insert_before_for_out

insert_before_for_if_out:  
    movl    %ebx, p_ext_node_prev(%ebp)

    movl    next(%ebx), %ebx
    movl    %ebx, p_ext_node(%ebp)    
    
insert_before_for_cond:
    movl    p_ext_node(%ebp), %ebx
    cmpl    p_head_node(%ebp), %ebx
    jne     insert_before_for

insert_before_for_out:
    movl    p_ext_node(%ebp), %ebx
    cmpl    p_head_node(%ebp), %ebx
    je      insert_before_data_not_found

    movl    $SIZE_OF_NODE, %eax

    pushl   %eax
    pushl   $1
    call    xcalloc
    addl    $8, %esp

    movl    %eax, p_new_node(%ebp)

    movl    new_data(%ebp), %edx
    movl    %edx, data(%eax)
    movl    $NULL, next(%eax)

    movl    p_ext_node(%ebp), %ebx
    movl    %ebx, next(%eax)

    movl    p_ext_node_prev(%ebp), %ebx
    movl    %eax, next(%ebx)

    movl    $SUCCESS, %eax
    jmp     insert_before_out

insert_before_data_not_found:
    movl    $LIST_DATA_NOT_FOUND, %eax

insert_before_out:
    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl get_start
.type get_start, @function

.equ    p_head_node, p1
.equ    p_start_data, p2

get_start:
    pushl   %ebp
    movl    %esp, %ebp

    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, next(%ebx)
    je      get_start_list_empty

    movl    next(%ebx), %ebx
    movl    data(%ebx), %edx

    movl    p_start_data(%ebp), %eax
    movl    %edx, (%eax)

    movl    $SUCCESS, %eax
    jmp     get_start_out

get_start_list_empty:
    movl    $LIST_EMPTY, %eax

get_start_out:
    movl    %ebp, %esp
    popl    %ebp
    ret  
##################
.globl get_end
.type get_end, @function

.equ    p_head_node, p1
.equ    p_end_data, p2

.equ    p_run, loc1

.equ    GET_END_LOCAL_STORAGE, 4

get_end:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $GET_END_LOCAL_STORAGE, %esp

    movl    $NULL, p_run(%ebp)

    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, next(%ebx)
    je      get_end_list_empty

    movl    %ebx, p_run(%ebp)
    jmp     get_end_for_cond

get_end_for:
    movl    %edx, p_run(%ebp)

get_end_for_cond:
    movl    p_run(%ebp), %eax
    movl    next(%eax), %edx
    cmpl    p_head_node(%ebp), %edx
    jne     get_end_for 

    movl    data(%eax), %edx

    movl    p_end_data(%ebp), %eax
    movl    %edx, (%eax)

    movl    $SUCCESS, %eax
    jmp     get_end_out

get_end_list_empty:
    movl    $LIST_EMPTY, %eax

get_end_out:
    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl pop_start
.type pop_start, @function

.equ    p_head_node, p1
.equ    p_start_data, p2

.equ    p_first_node, loc1

.equ    POP_START_LOCAL_STORAGE, 4

pop_start:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $POP_START_LOCAL_STORAGE, %esp

    movl    $NULL, p_first_node(%ebp)

    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, next(%ebx)
    je      pop_start_list_empty

    movl    next(%ebx), %ecx
    movl    data(%ecx), %edx

    movl    p_start_data(%ebp), %eax
    movl    %edx, (%eax)

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, p_first_node(%ebp)

    movl    p_first_node(%ebp), %eax
    movl    next(%eax), %edx
    movl    %edx, next(%ebx)

    pushl   %eax
    call    free 
    addl    $4, %esp

    movl    $SUCCESS, %eax
    jmp     pop_start_out

pop_start_list_empty:
    movl    $LIST_EMPTY, %eax

pop_start_out:
    movl    %ebp, %esp
    popl    %ebp
    ret 
##################
.globl pop_end
.type pop_end, @function

.equ    p_head_node, p1
.equ    p_end_data, p2

.equ    p_run, loc1
.equ    p_run_prev, loc2

.equ    POP_END_LOCAL_STORAGE, 8

pop_end:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $POP_END_LOCAL_STORAGE, %esp

    movl    $NULL, p_run(%ebp)
    movl    $NULL, p_run_prev(%ebp)

    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, next(%ebx)
    je      pop_end_list_empty

    movl    next(%ebx), %edx
    movl    %edx, p_run(%ebp)    

    movl    %ebx, p_run_prev(%ebp)
    jmp     pop_end_for_cond

pop_end_for:
    movl    %eax, p_run_prev(%ebp)
    movl    %edx, p_run(%ebp)

pop_end_for_cond:
    movl    p_run(%ebp), %eax
    movl    next(%eax), %edx
    cmpl    p_head_node(%ebp), %edx
    jne     pop_end_for 

    movl    data(%eax), %edx

    movl    p_end_data(%ebp), %ebx
    movl    %edx, (%ebx)

    movl    p_run(%ebp), %ebx
    movl    p_run_prev(%ebp), %eax

    movl    next(%ebx), %edx
    movl    %edx, next(%eax)

    pushl   %ebx
    call    free
    addl    $4, %esp   

    movl    $SUCCESS, %eax
    jmp     pop_end_out

pop_end_list_empty:
    movl    $LIST_EMPTY, %eax

pop_end_out:
    movl    %ebp, %esp
    popl    %ebp
    ret 
##################
.globl remove_start
.type remove_start, @function

.equ    p_head_node, p1

.equ    p_first_node, loc1

.equ    REMOVE_START_LOCAL_STORAGE, 4

remove_start:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $REMOVE_START_LOCAL_STORAGE, %esp

    movl    $NULL, p_first_node(%ebp)

    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, next(%ebx)
    je      remove_start_list_empty

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, p_first_node(%ebp)

    movl    p_first_node(%ebp), %eax
    movl    next(%eax), %edx
    movl    %edx, next(%ebx)

    pushl   %eax
    call    free 
    addl    $4, %esp

    movl    $SUCCESS, %eax
    jmp     remove_start_out

remove_start_list_empty:
    movl    $LIST_EMPTY, %eax

remove_start_out:
    movl    %ebp, %esp
    popl    %ebp
    ret 
##################
.globl remove_end
.type remove_end, @function

.equ    p_head_node, p1

.equ    p_run, loc1
.equ    p_run_prev, loc2

.equ    REMOVE_END_LOCAL_STORAGE, 8

remove_end:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $REMOVE_END_LOCAL_STORAGE, %esp

    movl    $NULL, p_run(%ebp)
    movl    $NULL, p_run_prev(%ebp)


    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, next(%ebx)
    je      remove_end_list_empty

    movl    next(%ebx), %edx
    movl    %edx, p_run(%ebp)    

    movl    %ebx, p_run_prev(%ebp)
    jmp     remove_end_for_cond

remove_end_for:
    movl    %eax, p_run_prev(%ebp)
    movl    %edx, p_run(%ebp)

remove_end_for_cond:
    movl    p_run(%ebp), %eax
    movl    next(%eax), %edx
    cmpl    p_head_node(%ebp), %edx
    jne     remove_end_for 

    movl    p_run(%ebp), %ebx
    movl    p_run_prev(%ebp), %eax

    movl    next(%ebx), %edx
    movl    %edx, next(%eax)

    pushl   %ebx
    call    free
    addl    $4, %esp   

    movl    $SUCCESS, %eax
    jmp     remove_end_out

remove_end_list_empty:
    movl    $LIST_EMPTY, %eax

remove_end_out:
    movl    %ebp, %esp
    popl    %ebp
    ret    
##################
.globl get_length    
.type get_length, @function

.equ    p_head_node, p1

.equ    L, loc1
.equ    p_run, loc2

.equ    GET_LENGTH_LOCAL_STORAGE, 8

get_length:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $GET_LENGTH_LOCAL_STORAGE, %esp

    movl    $0, L(%ebp)
    movl    $NULL, p_run(%ebp)

    movl    p_head_node(%ebp), %eax
    movl    next(%eax), %eax
    movl    %eax, p_run(%ebp)
    jmp     get_length_cond

get_length_for:
    addl    $1, L(%ebp)

    movl    p_run(%ebp), %eax
    movl    next(%eax), %eax
    movl    %eax, p_run(%ebp)

get_length_cond:
    movl    p_run(%ebp), %eax
    cmpl    p_head_node(%ebp), %eax
    jne     get_length_for

    movl    L(%ebp), %eax

    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl remove_data    
.type remove_data, @function

.equ    p_head_node, p1
.equ    r_data, p2

.equ    p_run, loc1
.equ    p_run_prev, loc2

.equ    REMOVE_DATA_LOCAL_STORAGE, 8

remove_data:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $REMOVE_DATA_LOCAL_STORAGE, %esp

    movl    $NULL, p_run(%ebp)
    movl    $NULL, p_run_prev(%ebp)

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, p_run(%ebp)

    movl    %ebx, p_run_prev(%ebp)

    jmp     remove_data_for_cond

remove_data_for:
    movl    r_data(%ebp), %edx
    cmpl    %edx, data(%eax)
    je      remove_data_for_out

    movl    %eax, p_run_prev(%ebp)
    movl    next(%eax), %edx
    movl    %edx, p_run(%ebp)

remove_data_for_cond:
    movl    p_run(%ebp), %eax
    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, %eax
    jne     remove_data_for

remove_data_for_out:
    movl    p_head_node(%ebp), %ebx
    cmpl    %ebx, p_run(%ebp)
    je      remove_data_list_data_not_found

    movl    p_run(%ebp), %eax
    movl    p_run_prev(%ebp), %ebx

    movl    next(%eax), %edx
    movl    %edx, next(%ebx)

    pushl   %eax
    call    free
    addl    $4, %esp

    movl    $NULL, p_run(%ebp)

    movl    $SUCCESS, %eax
    jmp     remove_data_out 

remove_data_list_data_not_found:
    movl    $LIST_DATA_NOT_FOUND, %eax

remove_data_out:
    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl find    
.type find, @function

.equ    p_head_node, p1
.equ    f_data, p2

.equ    p_run, loc1

.equ    FIND_LOCAL_STORAGE, 4

find:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $FIND_LOCAL_STORAGE, %esp

    movl    $NULL, p_run(%ebp)

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, p_run(%ebp)

    jmp     find_for_cond

find_for:
    movl    data(%eax), %edx
    cmpl    %edx, f_data(%ebp)
    je      find_true

    movl    next(%eax), %eax
    movl    %eax, p_run(%ebp)    

find_for_cond:
    movl    p_run(%ebp), %eax
    cmpl    p_head_node(%ebp), %eax
    jne     find_for

    movl    $FALSE, %eax
    jmp     find_out

find_true:
    movl    $TRUE, %eax

find_out:
    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl is_list_empty    
.type is_list_empty, @function

.equ    p_head_node, p1

is_list_empty:
    pushl   %ebp
    movl    %esp, %ebp

    movl    p_head_node(%ebp), %ebx
    cmpl    next(%ebx), %ebx

    jne     is_list_empty_false         
    
    movl    $TRUE, %eax
    jmp     is_list_empty_out

is_list_empty_false:
    movl    $FALSE, %eax

is_list_empty_out:
    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl show_list    
.type show_list, @function

.equ    p_head_node, p1
.equ    msg, p2

.equ    p_run, loc1

.equ    SHOW_LIST_LOCAL_STORAGE, 4

show_list:
    pushl   %ebp
    movl    %esp, %ebp

    subl    $SHOW_LIST_LOCAL_STORAGE, %esp

    movl    $NULL, p_run(%ebp)

    movl    msg(%ebp), %eax
    cmpl    $NULL, %eax
    je      show_continue

    pushl   %eax
    call    puts
    addl    $4, %esp

show_continue:
    pushl   $msg_start
    call    printf 
    addl    $4, %esp

    movl    p_head_node(%ebp), %eax
    movl    next(%eax), %eax
    movl    %eax, p_run(%ebp)
    jmp     show_cond_1

show_for_1:
    movl    data(%eax), %edx
    pushl   %edx
    pushl   $msg_data
    call    printf
    addl    $8, %esp

    movl    p_run(%ebp), %eax
    movl    next(%eax), %eax
    movl    %eax, p_run(%ebp)

show_cond_1:
    movl    p_run(%ebp), %eax
    cmpl    p_head_node(%ebp), %eax
    jne     show_for_1

    pushl   $msg_end
    call    puts
    addl    $4, %esp

    movl    %ebp, %esp
    popl    %ebp
    ret
##################
.globl  xcalloc
.type xcalloc, @function

.equ    nr_elements, p1 
.equ    size_per_element, p2 

.equ    ptr, loc1 

.equ    LOCAL_STORAGE, 4

xcalloc:
    pushl   %ebp
    movl    %esp, %ebp 

    subl    $LOCAL_STORAGE, %esp

    movl    $NULL, ptr(%ebp)

    movl    nr_elements(%ebp), %eax
    movl    size_per_element(%ebp), %edx

    pushl   %edx
    pushl   %eax
    call    calloc
    cmpl    $0, %eax
    je      xc_calloc_error

    movl    %eax, ptr(%ebp)
    movl    ptr(%ebp), %eax
    jmp     xc_out

xc_calloc_error:
    pushl   $msg_calloc_error
    call    puts
    addl    $4, %esp

    pushl   $EXIT_FAILURE
    call    exit  

xc_out: 
    movl    %ebp, %esp
    popl    %ebp
    ret 
##################
.globl  destroy_list
.type destroy_list, @function

.equ    p_head_node, p1 

.equ    p_run, loc1 
.equ    p_run_next, loc2 

.equ    DESTROY_LIST_LOCAL_STORAGE, 8

destroy_list:
    pushl   %ebp
    movl    %esp, %ebp 

    subl    $DESTROY_LIST_LOCAL_STORAGE, %esp

    movl    $NULL, p_run(%ebp)
    movl    $NULL, p_run_next(%ebp)

    movl    p_head_node(%ebp), %ebx
    movl    next(%ebx), %edx
    movl    %edx, p_run(%ebp)

    jmp     destroy_list_for_cond

destroy_list_for:
    movl    data(%eax), %edx
    pushl   %edx
    pushl   $msg_node_deleted
    call    printf
    addl    $8, %esp

    movl    p_run(%ebp), %eax
    movl    next(%eax), %edx
    movl    %edx, p_run_next(%ebp)
    
    pushl   %eax
    call    free 
    addl    $4, %esp

    movl    p_run_next(%ebp), %eax
    movl    %eax, p_run(%ebp)

destroy_list_for_cond:
    movl    p_run(%ebp), %eax
    cmpl    p_head_node(%ebp), %eax
    jne     destroy_list_for     

    movl    p_head_node(%ebp), %ebx
    pushl   %ebx
    call    free

    movl    %ebp, %esp
    popl    %ebp
    ret 
##################
