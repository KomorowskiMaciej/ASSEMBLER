#include <stdio.h> 
float srednia_aryt(float *tablica, unsigned int n);
int main()
{
	float tablica[5] = { 1.0, -3.5, 4.44, 5.1, 7.2 };

	printf("%f", srednia_aryt(&tablica, 5));

	return 0;
}