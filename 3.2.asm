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
 
_main:
	call wczytaj_do_EAX
	;koniec
	push 0 
	call _ExitProcess@4 
END 