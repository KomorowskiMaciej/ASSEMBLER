.686 
.model flat 
extern __read : PROC
extern  __write : PROC 
extern  _ExitProcess@4 : PROC 
public _main 
.data 
znaki      db  12 dup (?)   
obszar      db  12 dup (?)  
tekst		db 'Liczba musi byc mniejsza od 60000, inaczej program nic nie wyswietli', 10
koniec_tekstu db ?
.code

wczytaj_do_EAX  PROC 
	;zapamietanie rejestrow ogolnego przeznaczenia (bez EAX - bo to zepsuloby wynik dzialania podprogramu,
	;bez EBP - bo go nie modyfikujemy, i bez ESP - bo po dzialaniu podprogramu i tak bedzie pokazywa³ w to samo miejsce, co przed
	push ebx
	push ecx
	push edx
	push esi
	push edi

	push   dword PTR 12 ; max iloœæ znaków wczytywanej liczby  
	push   dword PTR OFFSET obszar  ; adres obszaru pamiêci 
	push   dword PTR 0; numer urz¹dzenia (0 dla klawiatury) 
	call   __read  ; odczytywanie znaków z klawiatury
	add    esp, 12    ; usuniêcie parametrów ze stosu 
 
	; zamiana cyfr w kodzie ASCII na liczbê binarn¹ 
	mov    esi, 0  ; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest w rejestrze ESI - przyjmujemy 0 jako wartoœæ pocz¹tkow¹ 
	mov    ebx, OFFSET obszar  ; adres obszaru ze znakami 

	; pobranie kolejnej cyfry w kodzie ASCII z tablicy ’obszar’ 
	nowy: 
	mov    al, [ebx] 
	inc    ebx    ; zwiêkszenie indeksu 
	cmp    al,10  ; sprawdzenie czy naciœniêto Enter 
	je    byl_enter ; skok, gdy naciœniêto Enter 
	sub    al, 30H  ; zamiana kodu ASCII na wartoœæ cyfry 
	movzx  edi, al  ; przechowanie wartoœci cyfry w rejestrze EDI 
	mov    eax, 10   ; mno¿na 
	mul    esi       ; mno¿enie wczeœniej obliczonej wartoœci razy 10 
	add    eax, edi  ; dodanie ostatnio odczytanej cyfry 
	mov    esi, eax  ; dotychczas obliczona wartoœæ 
	jmp    nowy   ; skok na pocz¹tek pêtli 
 
	byl_enter: 
	mov    eax, esi    ; przepisanie wyniku konwersji do rejestru EAX 
	; wartoœæ binarna wprowadzonej liczby znajduje siê teraz w rejestrze EAX 
	;przywrocenie rejestrow sprzed dzialania podprogramu
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret 
wczytaj_do_EAX  ENDP 
 
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
	;wyswietlenie tekstu poczatkowego
	mov ebx, (OFFSET koniec_tekstu) - (OFFSET tekst) 
	push ebx
	push dword PTR OFFSET tekst
	push dword PTR 1
	call __write
	add esp, 12

	call wczytaj_do_EAX
	cmp eax, 60000
	jae koniec

	mov edx, 0 ;zerowanie starszej czesci mnoznej - liczba jest mniejsza od 60000
	mul eax
	call wyswietl_EAX

koniec:
	push 0 
	call _ExitProcess@4 
END 