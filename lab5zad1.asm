.686 
.model flat 
public  _srednia_aryt
.code 
 
_srednia_aryt PROC 
	push   ebp    ; zapisanie zawarto�ci EBP na stosie 
	mov    ebp,esp  ; kopiowanie zawarto�ci ESP do EBP 
	push   ebx    ; przechowanie zawarto�ci rejestru EBX
 
	mov    ebx, [ebp+8]  ; adres tablicy tabl 
	mov    ecx, [ebp+12]  ; liczba element�w tablicy 
	;1, 3.5, 4.44, 5.1, 7.2
	finit
	fldz ;suma elementow
kolejny_element: ;obliczenie mianownika ze wzoru
	fld dword PTR [ebx] ;wrzucenie kolejnego el tablicy na wierzcholek stosu kopr.
	fadd st(1), st(0)
	fstp st(0)
	add ebx, 4 ;kolejny element tablicy
	loop kolejny_element

	fild dword PTR [ebp+12]
	fdiv st(1), st(0)
	fstp st(0)

	pop    ebx    ; odtworzenie zawarto�ci rejestr�w 
	pop    ebp 
	ret        ; powr�t do programu g��wnego 
_srednia_aryt   ENDP 
END 