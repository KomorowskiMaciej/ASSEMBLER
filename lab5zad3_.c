#include <stdio.h>
void sumuj(float* tab1, float* tab2, float* wynik, unsigned int rozmiar);

#define ROZMIAR 16


int main()
{

	float tab1[ROZMIAR] = { 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, -8.1, 9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1 };
	float tab2[ROZMIAR] = { 1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, -8.1, -9.1, -10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 40000.0 };
	float wynik[ROZMIAR];

	sumuj(tab1, tab2, wynik, ROZMIAR);

	for (int i = 0; i < ROZMIAR; i++)
	{
		printf("%f ", wynik[i]);
	}
	return 0;
}