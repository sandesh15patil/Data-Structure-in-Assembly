#include <stdio.h>
#include <stdlib.h>

#define N_MAX 	100000
#define CAP		10000

#define TRUE	1
#define FALSE	0

void get_array(int** pp_arr, int* pN);
void show_array(int* p_arr, int N, const char* msg);
void merge_sort(int* a, int start_index, int end_index);
void merge(int* a, int p, int q, int r);
void* xcalloc(int n, size_t size);

int main(void)
{
	int* p_arr = NULL;
	int N = -1;

	get_array(&p_arr, &N);
	show_array(p_arr, N, "Before SORT");
	merge_sort(p_arr, 0, N-1);
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

void merge_sort(int* a, int start_index, int end_index)
{
	int mid_index;
	if(start_index < end_index)
	{
		mid_index = (start_index + end_index) / 2;
		merge_sort(a, start_index, mid_index);
		merge_sort(a, mid_index+1, end_index);
		merge(a, start_index, mid_index, end_index);
	}
}

void merge(int* a, int p, int q, int r)
{
	int N1 = q-p+1;
	int N2 = r-q;
	int* a1 = NULL;
	int* a2 = NULL;
	int k1, k2, k;

	a1 = (int*)xcalloc(N1, sizeof(int));

	a2 = (int*)xcalloc(N2, sizeof(int));

	for(k = 0; k < N1; ++k)
		a1[k] = a[p+k];

	for(k = 0; k < N2; ++k)
		a2[k] = a[q+1+k];

	k = 0; 
	k1 = 0;
	k2 = 0;

	while(TRUE)
	{
		if(a1[k1] <= a2[k2])
		{
			a[p+k] = a1[k1];
			k++;
			k1++;


			if(k1 == N1)
			{
				while(k2 < N2)
				{
					a[p+k] = a2[k2];
					k++;
					k2++;
				}

				break;
			}
		}
		else
		{
			a[p+k] = a2[k2];
			k++;
			k2++;
			if(k2 == N2)
			{
				while(k1 < N1)
				{
					a[p+k] = a1[k1];
					k++;
					k1++;
				}

				break;
			}
		}
	}

	free(a1);
	a1 = NULL;

	free(a2);
	a2 = NULL;
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