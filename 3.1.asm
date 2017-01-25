.686 
.model flat 
extern  __write : PROC 
extern  _ExitProcess@4 : PROC 
public _main 
.data 
znaki      db  12 dup (?)   
.code 
 
wyswietl_EAX  PROC 
	pusha  
	mov    esi, 11    ; indeks w tablicy 'znaki' 
	mov    ebx, 10    ; dzielnik równy 10 
	od_nowa: 
	mov    edx, 0  ; zerowanie starszej czêœci dzielnej 
	div    ebx    ; dzielenie przez 10, iloraz w EAX, reszta w EDX (reszta < 10) 
	add    dl, 30H  ; zamiana reszty z dzielenia na kod ASCII 
	mov    znaki [esi], dl; przes³anie cyfry w kodzie ASCII do tablicy ’znaki’ 
	dec    esi    ; zmniejszenie indeksu 
	cmp    eax, 0  ; sprawdzenie czy iloraz = 0 
	jne    od_nowa  ; skok, gdy iloraz niezerowy 

	; wype³nienie pozosta³ych bajtów spacjami 
	wypeln: 
	mov    byte PTR znaki [esi], 20H ; kod spacji 
	dec    esi    ; zmniejszenie indeksu 
	jnz    wypeln 
 
	mov    byte PTR znaki [esi], 0AH ; wpisanie znaku nowego wiersza 

	;wyœwietlenie cyfr na ekranie 
	push   dword PTR 12  ; liczba wyœwietlanych znaków 
	push   dword PTR OFFSET znaki  ; adres wyœw. obszaru 
	push   dword PTR 1; numer urz¹dzenia (ekran ma numer 1) 
	call   __write    ; wyœwietlenie liczby na ekranie 
	add    esp, 12    ; usuniêcie parametrów ze stosu 
	popa 
	ret 
wyswietl_EAX  ENDP 
 
_main:
	mov eax, 1 ;liczba do wyswietlenia
	mov ebx, 1 ;liczba do dodawania do kolejnych elekentow ciagu
	mov ecx, 1 ;licznik obiegow petli - liczb do wyswietlenia
kolejny_element:
	call wyswietl_EAX
	add eax, ebx
	inc ebx
	inc ecx
	cmp ecx, 50
	jna kolejny_element

	;koniec
	push 0 
	call _ExitProcess@4 
END 