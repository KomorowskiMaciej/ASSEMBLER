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
 
wyswietl_EAX_hex  PROC 
	; wyœwietlanie zawartoœci rejestru EAX w postaci liczby szesnastkowej 
	pusha    ; przechowanie rejestrów 
            
	; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie rejestru ESP) przeznaczonych na tymczasowe przechowanie cyfr szesnastkowych
	;wyœwietlanej liczby 
	sub    esp, 12 
	mov    edi, esp  ; adres zarezerwowanego obszaru pamiêci 
 
	; przygotowanie konwersji            
	mov    ecx, 8  ; liczba obiegów pêtli konwersji 
	mov    esi, 1  ; indeks pocz¹tkowy u¿ywany przy zapisie cyfr 
 
	; pêtla konwersji 
	ptl3hex:    
	; przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28 
	; rejestru EAX zostan¹ przesuniête na pozycje 3 - 0 
	rol    eax, 4       
 
	; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym 
	mov    ebx, eax  ; kopiowanie EAX do EBX 
	and    ebx, 0000000FH ; zerowanie bitów 31 - 4  rej.EBX 
	mov    dl, dekoder[ebx] ; pobranie cyfry z tablicy  
 
	; przes³anie cyfry do obszaru roboczego 
	mov    [edi][esi], dl  
 
	inc    esi    ;inkrementacja modyfikatora 
	loop   ptl3hex  ; sterowanie pêtl¹ 
            
	; wpisanie znaku nowego wiersza przed i po cyfrach 
	mov    byte PTR [edi][0], 10 
	mov    byte PTR [edi][9], 10 
 
	; wyœwietlenie przygotowanych cyfr 
	push   10  ; 8 cyfr + 2 znaki nowego wiersza 
	push   edi  ; adres obszaru roboczego 
	push   1  ; nr urz¹dzenia (tu: ekran) 
	call   __write  ; wyœwietlenie
	; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych przez 3 rozkazy push przed rozkazem call 
	; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu 
	add    esp, 24                 
	popa   ; odtworzenie rejestrów 
	ret    ; powrót z podprogramu 
wyswietl_EAX_hex  ENDP 

_main:

	call wczytaj_do_EAX

	call wyswietl_EAX_hex

	push 0 
	call _ExitProcess@4 
END