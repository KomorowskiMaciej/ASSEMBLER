#include <stdio.h> 
void przestaw(int tabl[], int n);
int main()
{
	int tablica[10] = {5,2,6,1,7,10,44,55,0,23};

	int i;

	for (i = 0; i < 10; i++)
		printf("%d ", tablica[i]);
	printf("\n");
	printf("\n"); 

	for (i = 0; i < 9; i++)
		przestaw(&tablica, 10-i);

	for (i = 0; i < 10; i++)
		printf("%d ", tablica[i]);
	printf("\n");


	return 0;
}