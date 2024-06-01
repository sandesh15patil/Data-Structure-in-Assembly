#include <stdio.h>
#include <stdlib.h>

#define SUCCESS                 1
#define LIST_DATA_NOT_FOUND     2
#define LIST_EMPTY              3

#define TRUE                    1
#define FALSE                   0

/* Node layout */
struct node
{
    int data;
    struct node* next;
};

struct node* create_list(void);
void* xcalloc(int nr_elements, int size_per_element);
int insert_start(struct node* p_head_node, int new_data);
int insert_end(struct node* p_head_node, int new_data);
void show_list(struct node* p_head_node, const char* msg);
int insert_after(struct node* p_head_node, int e_data, int new_data);
int insert_before(struct node* p_head_node, int e_data, int new_data);
int get_start(struct node* p_head_node, int* p_start_data);
int get_end(struct node* p_head_node, int* p_end_data);
int pop_start(struct node* p_head_node, int* p_start_data);
int pop_end(struct node* p_head_node, int* p_end_data);
int remove_start(struct node* p_head_node);
int remove_end(struct node* p_head_node);
int get_length(struct node* p_head_node);
int remove_data(struct node* p_head_node, int r_data);
int find(struct node* p_head_node, int f_data);
int is_list_empty(struct node* p_head_node);
void destroy_list(struct node* p_head_node);

int main(void)
{
    struct node* p_head_node = NULL;
    int data;

    p_head_node = create_list();

    if(is_list_empty(p_head_node) == TRUE)
        puts("List is empty now");

    show_list(p_head_node, "Before insert_start()");
    
    for(data= 5; data <= 25; data+=5)
        insert_start(p_head_node, data);

    show_list(p_head_node, "After insert_start()");

    show_list(p_head_node, "Before insert_end()");
    
    for(data= 7; data <= 35; data+=7)
        insert_end(p_head_node, data);

    show_list(p_head_node, "After insert_end");

    insert_after(p_head_node, 5, 100); 
    show_list(p_head_node, "After insert_after():"); 

    insert_before(p_head_node, 7, 200); 
    show_list(p_head_node, "After insert_before():"); 

    get_start(p_head_node, &data); 
    printf("Current start:%d\n", data); 

    get_end(p_head_node, &data); 
    printf("Current end:%d\n", data); 

    pop_start(p_head_node, &data); 
    printf("Removed Start:%d\n", data); 
    show_list(p_head_node, "after pop_start():"); 

    pop_end(p_head_node, &data); 
    printf("Removed End:%d\n", data); 
    show_list(p_head_node, "after pop_end():"); 

    remove_start(p_head_node); 
    show_list(p_head_node, "After remove_start():"); 

    remove_end(p_head_node); 
    show_list(p_head_node, "After remove_end():"); 

    printf("LENGTH=%d\n", get_length(p_head_node)); 

    remove_data(p_head_node, 5); 
    show_list(p_head_node, "After remove_data():"); 

    if(find(p_head_node, 100) == TRUE)
        puts("100 is present in list"); 
    
    if(find(p_head_node, -100) == FALSE)
        puts("-100 is not in list");

    if(is_list_empty(p_head_node) == FALSE)
        puts("List is not empty now");

    destroy_list(p_head_node); 
    p_head_node = NULL;

    exit(EXIT_SUCCESS);
}

struct node* create_list(void)
{
    struct node* p_head_node = NULL;

    p_head_node = (struct node*)xcalloc(1, sizeof(struct node));

    p_head_node->data = 0;
    p_head_node->next = p_head_node;

    return (p_head_node);
}

void* xcalloc(int nr_elements, int size_per_element)
{
	void* ptr = NULL; 

	ptr = calloc(nr_elements, size_per_element); 
	if(ptr == NULL)
    {
		puts("Error in allocating memory"); 
		exit(EXIT_FAILURE);
	}

	return (ptr); 
}

int insert_start(struct node* p_head_node, int new_data)
{
    struct node* p_new_node = NULL;

    p_new_node = (struct node*)xcalloc(1, sizeof(struct node));

    p_new_node->data = new_data;
    p_new_node->next = NULL;

    p_new_node->next = p_head_node->next;
    p_head_node->next = p_new_node;

    return (SUCCESS);
}

int insert_end(struct node* p_head_node, int new_data)
{
    struct node* p_new_node = NULL;
    struct node* p_end_node = NULL;

    p_end_node = p_head_node->next;
    while(p_end_node->next != p_head_node)
        p_end_node = p_end_node->next;

    p_new_node = (struct node*)xcalloc(1, sizeof(struct node));

    p_new_node->data = new_data;
    p_new_node->next = NULL;

    p_end_node->next = p_new_node;
    p_new_node->next = p_head_node;

    return (SUCCESS);
}

int insert_after(struct node* p_head_node, int e_data, int new_data)
{
    struct node* p_ext_node = NULL; /*Pointer to store the address of first occurrence of e_data */
    struct node* p_new_node = NULL;

    p_ext_node = p_head_node->next;
    while(p_ext_node != p_head_node)
    {
        if(p_ext_node->data == e_data)
            break;
        p_ext_node = p_ext_node->next;
    }

    if(p_ext_node == p_head_node)
        return (LIST_DATA_NOT_FOUND);
    
    p_new_node = (struct node*)xcalloc(1, sizeof(struct node));

    p_new_node->data = new_data;
    p_new_node->next = NULL;

    p_new_node->next = p_ext_node->next;
    p_ext_node->next = p_new_node;

    return (SUCCESS);
}

int insert_before(struct node* p_head_node, int e_data, int new_data)
{
    struct node* p_ext_node = NULL; 
    struct node* p_ext_node_prev = NULL;
    struct node* p_new_node = NULL;

    p_ext_node_prev = p_head_node;
    p_ext_node = p_head_node->next;
    while(p_ext_node != p_head_node)
    {
        if(p_ext_node->data == e_data)
            break;
        p_ext_node_prev = p_ext_node;
        p_ext_node = p_ext_node->next;
    }

    if(p_ext_node == p_head_node)
        return (LIST_DATA_NOT_FOUND);
    
    p_new_node = (struct node*)xcalloc(1, sizeof(struct node));

    p_new_node->data = new_data;
    p_new_node->next = NULL;

    p_new_node->next = p_ext_node;
    p_ext_node_prev->next = p_new_node;

    return (SUCCESS);
}

int get_start(struct node* p_head_node, int* p_start_data)
{
    if(p_head_node->next == p_head_node)
        return (LIST_EMPTY);
    
    *p_start_data = p_head_node->next->data;
    return (SUCCESS);
}

int get_end(struct node* p_head_node, int* p_end_data)
{
    struct node* p_run = NULL;

    if(p_head_node->next == p_head_node)
        return (LIST_EMPTY);

    p_run = p_head_node;
    while(p_run->next != p_head_node)
        p_run = p_run->next;

    *p_end_data = p_run->data;

    return (SUCCESS);
}

int pop_start(struct node* p_head_node, int* p_start_data)
{
    struct node* p_first_node = NULL;

    if(p_head_node->next == p_head_node)
        return (LIST_EMPTY);
    
    *p_start_data = p_head_node->next->data;
    p_first_node = p_head_node->next;
    p_head_node->next = p_first_node->next;
    free(p_first_node);
    return (SUCCESS);
}

int pop_end(struct node* p_head_node, int* p_end_data)
{
    struct node* p_run = NULL;
    struct node* p_run_prev = NULL;
    
    if(p_head_node->next == p_head_node)
        return (LIST_EMPTY);

    p_run = p_head_node->next;
    p_run_prev = p_head_node;
    while(p_run->next != p_head_node)
    {
        p_run_prev = p_run;
        p_run = p_run->next;
    }

    *p_end_data = p_run->data;
    p_run_prev->next = p_run->next;
    free(p_run);
    return (SUCCESS);
}

int remove_start(struct node* p_head_node)
{
    struct node* p_first_node = NULL;

    if(p_head_node->next == p_head_node)
        return (LIST_EMPTY);
    
    p_first_node = p_head_node->next;
    p_head_node->next = p_first_node->next;
    free(p_first_node);
    return (SUCCESS);
}

int remove_end(struct node* p_head_node)
{
    struct node* p_run = NULL;
    struct node* p_run_prev = NULL;
    
    if(p_head_node->next == p_head_node)
        return (LIST_EMPTY);

    p_run = p_head_node->next;
    p_run_prev = p_head_node;
    while(p_run->next != p_head_node)
    {
        p_run_prev = p_run;
        p_run = p_run->next;
    }

    p_run_prev->next = p_run->next;
    free(p_run);
    return (SUCCESS);
}

int get_length(struct node* p_head_node)
{
    int L = 0;
    struct node* p_run = NULL;

    for(p_run = p_head_node->next; p_run != p_head_node; p_run = p_run->next, ++L)
        ;

    return (L);
}

int remove_data(struct node* p_head_node, int r_data)
{
    struct node* p_run = NULL;
    struct node* p_run_prev = NULL;

    p_run = p_head_node->next;
    p_run_prev = p_head_node;

    while(p_run != p_head_node)
    {
        if(p_run->data == r_data)
            break;
        
        p_run_prev = p_run;
        p_run = p_run->next;
    }

    if(p_run == p_head_node)
        return (LIST_DATA_NOT_FOUND);
    
    p_run_prev->next = p_run->next;
    free(p_run);
    p_run = NULL;

    return (SUCCESS);

}

int find(struct node* p_head_node, int f_data)
{
    struct node* p_run = NULL;

    for(p_run = p_head_node->next; p_run != p_head_node; p_run = p_run->next)
        if(p_run->data == f_data)
            return (TRUE);
    
    return (FALSE);
}

int is_list_empty(struct node* p_head_node)
{
    return (p_head_node->next == p_head_node);
}

void show_list(struct node* p_head_node, const char* msg)
{
    struct node* p_run = NULL;

    if(msg)
        puts(msg);

    printf("[START]<->");

    for(p_run = p_head_node->next; p_run != p_head_node; p_run = p_run->next)
        printf("[%d]<->",p_run->data);

    puts("[END]");
}

void destroy_list(struct node* p_head_node)
{
    struct node* p_run = NULL;
    struct node* p_run_next = NULL;

    p_run = p_head_node->next;
    while(p_run != p_head_node)
    {
        printf("Node deleted: %d\n", p_run->data);
        p_run_next = p_run->next;
        free(p_run);
        p_run = p_run_next;
    }

    free(p_head_node);
}