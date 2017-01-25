#include <stdio.h> 

// to jest prototyp
float srednia_harm(float * tablica, unsigned int n);float nowy_exp(float x);
void _dodaj_SSE_char(char *, char *, char *);
void int2float(int * calkowite, float * zmienno_przec);
void pm_jeden(float * tabl);
int main()
{

	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };
	char wynik[16];
	float tablica[10] = { 1, 2, 3, 4, 5, 7, 8, 9, 10, 10};
	int a[2] = { -17, 24 };
	float r[4];
	float tablica1[4] = { 27.5, 143.57, 2100.0, -3.51 };
	float wyniki[4];
	//printf("%f", srednia_harm(tablica, 10)); //1
	//printf("%f", nowy_exp(5)); //2
	/*
	dodaj_SSE_char(&liczby_A, &liczby_B, &wynik); //3
	for (int i = 0; i < 16; i++)
		printf("%d ", wynik[i]);
	*/
	/*
	int2float(a, r);//4
	printf("\nKonwersja = %f  %f\n", r[0], r[1]);
	*/

	
	/* // 5
	printf("\n%f   %f   %f   %f\n", tablica1[0], tablica1[1], tablica1[2], tablica1[3]);
	pm_jeden(&tablica1);
	printf("\n%f   %f   %f   %f\n", tablica1[0], tablica1[1], tablica1[2], tablica1[3]);
	*/

	/* //6
	dodawanie_SSE(wyniki);
	printf("\nWyniki = %f  %f  %f  %f\n",
		wyniki[0], wyniki[1], wyniki[2], wyniki[3]);
	*/
	return 0;
}