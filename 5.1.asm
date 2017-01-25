.686 
.model flat 
public  _srednia_harm
.code 
 
_srednia_harm PROC 
	push   ebp    ; zapisanie zawarto�ci EBP na stosie 
	mov    ebp,esp  ; kopiowanie zawarto�ci ESP do EBP 
	push   ebx    ; przechowanie zawarto�ci rejestru EBX, uzywamy go tu do pozbywania sie smieci ze stosu
 
	mov    ebx, [ebp+8]  ; adres tablicy tabl 
	mov    ecx, [ebp+12]  ; liczba element�w tablicy 

	push dword PTR 1
	
	finit
	fldz ;zaladowanie zera, zeby w 1 obiegu petli prawidlowo dodalo sie 0
kolejny_element: ;obliczenie mianownika ze wzoru
	fld dword PTR [ebx] ;wrzucenie kolejnego el tablicy na wierzcholek stosu kopr.
	fild dword PTR [esp] ;wrzucenie jedynki na stos
	fdiv st(0), st(1) ;dzielenie 1/element
	fadd st(0), st(2) ;suma poprzednich dzielen z aktualnym. w pierwszym obiegu petli zostanie dodane 0
	fst st(2) ;\
	fstp st(0) ;|usuniecie niepotrzebnych danych ze stosu
	fstp st(0);/
	add ebx, 4 ;kolejny element tablicy
	loop kolejny_element

	;dzielenie licznika przez mianownik
	fild dword PTR [ebp+12]
	fdiv st(0), st(1)
	
	pop		ebx ;wywalenie jedynki ze stosu
	pop    ebx    ; odtworzenie zawarto�ci rejestr�w 
	pop    ebp 
	ret        ; powr�t do programu g��wnego 
_srednia_harm   ENDP 
END 