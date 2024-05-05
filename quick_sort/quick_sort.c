#include <stdio.h>
#include <stdlib.h>

#define N_MAX	100000
#define CAP		10000

#define TRUE	1
#define FALSE	0

void get_array(int** pp_arr, int* pN);
void show_array(int* p_arr, int N, const char* msg);
void quick_sort(int* p_arr, int p, int r);
int partition(int* p_arr, int p, int r);
void* xcalloc(int n, size_t size);

int main(void)
{
	int* p_arr = NULL;
	int N;

	get_array(&p_arr, &N);
	show_array(p_arr, N, "Before SORT");

	quick_sort(p_arr, 0, N-1);

	show_array(p_arr, N, "After SORT");

	free(p_arr);
	p_arr = NULL;

	exit(EXIT_SUCCESS);
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
	{
		p_arr[i] = rand() % CAP;
	}

	*pp_arr = p_arr;
	*pN = N;
}

void show_array(int* p_arr, int N, const char* msg)
{
	int i;

	if(msg)
		puts(msg);

	for(i = 0; i < N; ++i)
		printf("p_arr[%d]:%d\n", i, p_arr[i]);
}

void quick_sort(int* p_arr, int p, int r)
{
	int q;

	if(p < r)
	{
		q = partition(p_arr, p, r);
		quick_sort(p_arr, p, q-1);
		quick_sort(p_arr, q+1, r);
	}
}

int partition(int* p_arr, int p, int r)
{
	int i, j;
	int pivot;
	int tmp;

	pivot = p_arr[r];
	i = p - 1;

	for(j = p; j < r; ++j)
	{
		if(p_arr[j] <= pivot)
		{
			i = i+1;
			tmp = p_arr[j];
			p_arr[j] = p_arr[i];
			p_arr[i] = tmp;
		}
	}

	tmp = p_arr[r];
	p_arr[r] = p_arr[i+1];
	p_arr[i+1] = tmp;

	return (i+1);
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