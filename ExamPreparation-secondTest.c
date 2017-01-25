#include <stdint.h>
#include <stdio.h>

float half_to_float(uint16_t x);
uint16_t float_to_half(float x);
void test();
float uint48_float(uint64_t x);
wchar_t* zamien_na_base12(unsigned int liczba);
unsigned int zamien_z_base12(wchar_t* znaki);
int roznica(int * odjemna, int ** odjemnik);
int * kopia_tablicy(int tabl[], unsigned int n);
char * komunikat(char * tekst);
unsigned int kwadrat(unsigned int a);
unsigned char iteracja(unsigned char x);
void pole_kola(float * pr);
float avg_wg(int n, float* tablica, float* wagi);
unsigned int NWD(unsigned int a, unsigned int b);
float miesz2float(unsigned int p);
float float_razy_float(float a, float b);

int main() {
	printf("%f\n", half_to_float(0b1100000000000000));
	printf("%04x\n", float_to_half(-2.0f));

	test();
	printf("%f\n", uint48_float(0x4000));

	unsigned short str[4] = { 0x36, 0x32, 0x218A, 0 };

	printf("%s\n", zamien_na_base12(121));
	printf("%d\n", zamien_z_base12(str));

	int a, b, *wsk, wynik;
	wsk = &b;
	a = 21; b = 25;
	wynik = roznica(&a, &wsk);

	int arr[3] = { 1,2,3 };
	int* adr = kopia_tablicy(arr, 3);

	komunikat("abcdef");

	printf("%d\n", kwadrat(7));

	printf("%d\n", iteracja(32));

	float k = 5;
	pole_kola(&k);
	printf("\nPole ko³a wynosi %f\n", k);

	float tabs[3] = { 1.0f, 2.0f, 3.0f };
	float wagi[3] = { 3.0f, 2.0f, 2.0f };
	printf("%f\n", avg_wg(3, tabs, wagi));
	printf("%d\n", NWD(27, 18));

	printf("%f\n", miesz2float(0x940)); // 8.25

	printf("%f\n", float_razy_float(1.0f, 1.0f));
	printf("%f\n", float_razy_float(2.0f, 1.0f));
	printf("%f\n", float_razy_float(2.0f, 0.5f));
	printf("%f\n", float_razy_float(125.0f, 0.5f));
	printf("%f\n", float_razy_float(2.0f, 2.0f));
	printf("%f\n", float_razy_float(2.5f, 2.5f));

	return 0;
}