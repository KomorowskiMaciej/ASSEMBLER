#include <stdio.h> 
float srednia_harm(float *tablica, unsigned int n);
int main()
{
	float tablica[5] = { 5.5, 1.2, 2.33, 1, 7};

	printf("%f", srednia_harm(&tablica, 5));

	return 0;
}