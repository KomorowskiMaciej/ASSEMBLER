#include <stdio.h>

int szukaj4_max(int a, int b, int c, int d);

int main()
{
	int a = 5, b = 21, c = 22, d = 1;
	int wynik = szukaj4_max(a, b, c, d);

	printf("%d", wynik);

	return 0;
}