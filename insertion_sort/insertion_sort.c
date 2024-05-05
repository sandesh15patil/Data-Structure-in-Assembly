#include <stdio.h>
#include <stdlib.h>

#define N_MAX 	100000
#define CAP 	10000

#define TRUE	1
#define FALSE	0

void get_array(int** pp_arr, int* pN);
void show_array(int* p_arr, int N, const char* msg);
void insertion_sort(int* p_arr, int N);
void* xcalloc(int n, size_t size);

int main(void)
{
	int* p_arr = NULL;
	int N;

	get_array(&p_arr, &N);
	show_array(p_arr, N, "Before SORT");
	insertion_sort(p_arr, N);
	show_array(p_arr, N, "After SORT");

	free(p_arr);
	p_arr = NULL;

	exit(0);
}

void get_array(int** pp_arr, int* pN)
{
	int* p_arr = NULL;
	int N;
	int i;

	printf("Enter the size of array BETWEEN[1-1,00,000]:\t");

	scanf("%d", &N);

	if(N <= 0 || N > N_MAX)
	{
		puts("Please Enter the size BETWEEN[1-1,00,000]");
		exit(EXIT_FAILURE);
	} 

	p_arr = (int*)xcalloc(N, sizeof(int));

	for(i = 0; i < N; ++i)
		p_arr[i] = rand() % CAP;

	*pp_arr = p_arr;
	*pN = N;
}

void insertion_sort(int* p_arr, int N)
{
	int i, j;
	int key;

	for(j = 1; j < N; ++j)
	{
		key = p_arr[j];
		i = j - 1;
		
		while(i > -1 && p_arr[i] > key)
		{
			p_arr[i+1] = p_arr[i];
			i = i - 1;
		}
		p_arr[i+1] = key;
	}
}


void show_array(int* p_arr, int N, const char* msg)
{
	int i;
	if(msg)
		puts(msg);

	for(i = 0; i < N; ++i)
		printf("p_arr[%d]:%d\n", i, p_arr[i]);
}

void* xcalloc(int n, size_t size)
{
	void* temp = calloc(n, size);
	if(temp == NULL)
	{
		puts("Error in allocating memory");
		exit(EXIT_FAILURE);
	}

	return temp;
}