.686 
.model flat 
extern __read : PROC
extern  __write : PROC 
extern  _ExitProcess@4 : PROC 
public _main 
.data 
znaki      db  12 dup (?)   
obszar      db  12 dup (?)  
dekoder  db  '0123456789ABCDEF' 
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
 
wyswietl_EAX_hex  PROC 
	; wy�wietlanie zawarto�ci rejestru EAX w postaci liczby szesnastkowej 
	pusha    ; przechowanie rejestr�w 
            
	; rezerwacja 12 bajt�w na stosie (poprzez zmniejszenie rejestru ESP) przeznaczonych na tymczasowe przechowanie cyfr szesnastkowych
	;wy�wietlanej liczby 
	sub    esp, 12 
	mov    edi, esp  ; adres zarezerwowanego obszaru pami�ci 
 
	; przygotowanie konwersji            
	mov    ecx, 8  ; liczba obieg�w p�tli konwersji 
	mov    esi, 1  ; indeks pocz�tkowy u�ywany przy zapisie cyfr 
 
	; p�tla konwersji 
	ptl3hex:    
	; przesuni�cie cykliczne (obr�t) rejestru EAX o 4 bity w lewo w szczeg�lno�ci, w pierwszym obiegu p�tli bity nr 31 - 28 
	; rejestru EAX zostan� przesuni�te na pozycje 3 - 0 
	rol    eax, 4       
 
	; wyodr�bnienie 4 najm�odszych bit�w i odczytanie z tablicy 'dekoder' odpowiadaj�cej im cyfry w zapisie szesnastkowym 
	mov    ebx, eax  ; kopiowanie EAX do EBX 
	and    ebx, 0000000FH ; zerowanie bit�w 31 - 4  rej.EBX 
	mov    dl, dekoder[ebx] ; pobranie cyfry z tablicy  
 
	; przes�anie cyfry do obszaru roboczego 
	mov    [edi][esi], dl  
 
	inc    esi    ;inkrementacja modyfikatora 
	loop   ptl3hex  ; sterowanie p�tl� 
            
	; wpisanie znaku nowego wiersza przed i po cyfrach 
	mov    byte PTR [edi][0], 10 
	mov    byte PTR [edi][9], 10 
 
	; wy�wietlenie przygotowanych cyfr 
	push   10  ; 8 cyfr + 2 znaki nowego wiersza 
	push   edi  ; adres obszaru roboczego 
	push   1  ; nr urz�dzenia (tu: ekran) 
	call   __write  ; wy�wietlenie
	; usuni�cie ze stosu 24 bajt�w, w tym 12 bajt�w zapisanych przez 3 rozkazy push przed rozkazem call 
	; i 12 bajt�w zarezerwowanych na pocz�tku podprogramu 
	add    esp, 24                 
	popa   ; odtworzenie rejestr�w 
	ret    ; powr�t z podprogramu 
wyswietl_EAX_hex  ENDP 

_main:

	call wczytaj_do_EAX

	call wyswietl_EAX_hex

	push 0 
	call _ExitProcess@4 
END