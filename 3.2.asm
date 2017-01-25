.686 
.model flat 
extern __read : PROC
extern  __write : PROC 
extern  _ExitProcess@4 : PROC 
public _main 
.data 
obszar      db  12 dup (?)   
.code 
 
wczytaj_do_EAX  PROC 
	;zapamietanie rejestrow ogolnego przeznaczenia (bez EAX - bo to zepsuloby wynik dzialania podprogramu,
	;bez EBP - bo go nie modyfikujemy, i bez ESP - bo po dzialaniu podprogramu i tak bedzie pokazywa� w to samo miejsce, co przed
	push ebx
	push ecx
	push edx
	push esi
	push edi

	push   dword PTR 12 ; max ilo�� znak�w wczytywanej liczby  
	push   dword PTR OFFSET obszar  ; adres obszaru pami�ci 
	push   dword PTR 0; numer urz�dzenia (0 dla klawiatury) 
	call   __read  ; odczytywanie znak�w z klawiatury
	add    esp, 12    ; usuni�cie parametr�w ze stosu 
 
	; zamiana cyfr w kodzie ASCII na liczb� binarn� 
	mov    esi, 0  ; bie��ca warto�� przekszta�canej liczby przechowywana jest w rejestrze ESI - przyjmujemy 0 jako warto�� pocz�tkow� 
	mov    ebx, OFFSET obszar  ; adres obszaru ze znakami 

	; pobranie kolejnej cyfry w kodzie ASCII z tablicy �obszar� 
	nowy: 
	mov    al, [ebx] 
	inc    ebx    ; zwi�kszenie indeksu 
	cmp    al,10  ; sprawdzenie czy naci�ni�to Enter 
	je    byl_enter ; skok, gdy naci�ni�to Enter 
	sub    al, 30H  ; zamiana kodu ASCII na warto�� cyfry 
	movzx  edi, al  ; przechowanie warto�ci cyfry w rejestrze EDI 
	mov    eax, 10   ; mno�na 
	mul    esi       ; mno�enie wcze�niej obliczonej warto�ci razy 10 
	add    eax, edi  ; dodanie ostatnio odczytanej cyfry 
	mov    esi, eax  ; dotychczas obliczona warto�� 
	jmp    nowy   ; skok na pocz�tek p�tli 
 
	byl_enter: 
	mov    eax, esi    ; przepisanie wyniku konwersji do rejestru EAX 
	; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX 
	;przywrocenie rejestrow sprzed dzialania podprogramu
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret 
wczytaj_do_EAX  ENDP 
 
_main:
	call wczytaj_do_EAX
	;koniec
	push 0 
	call _ExitProcess@4 
END 