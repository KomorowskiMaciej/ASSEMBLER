; wczytywanie i wyœwietlanie tekstu wielkimi literami 
; (inne znaki siê nie zmieniaj¹) 
 
.686 
.model flat 
extern  _ExitProcess@4 : PROC 
extern  __write : PROC  ; (dwa znaki podkreœlenia) 
extern  __read  : PROC  ; (dwa znaki podkreœlenia) 
public  _main 
 
.data 
tekst_pocz  db  10, 'Proszê napisaæ jakiœ tekst ' 
db  'i nacisnac Enter', 10 
koniec_t    db  ? 
magazyn    db  80 dup (?) 
nowa_linia    db  10 
liczba_znakow  dd  ? 
 
.code 
_main: 
 
; wyœwietlenie tekstu informacyjnego 
 
; liczba znaków tekstu 
           mov     ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) 
           push    ecx 
 
           push    OFFSET tekst_pocz  ; adres tekstu 
           push    1  ; nr urz¹dzenia (tu: ekran - nr 1) 
           call    __write  ; wyœwietlenie tekstu pocz¹tkowego 
 
           add     esp, 12  ; usuniecie parametrów ze stosu 
 
; czytanie wiersza z klawiatury 
           push    80 ; maksymalna liczba znaków 
           push    OFFSET magazyn 
           push    0  ; nr urz¹dzenia (tu: klawiatura - nr 0) 
           call    __read ; czytanie znaków z klawiatury 
           add     esp, 12  ; usuniecie parametrów ze stosu 
; kody ASCII napisanego tekstu zosta³y wprowadzone 
; do obszaru 'magazyn' 
 
; funkcja read wpisuje do rejestru EAX liczbê 
; wprowadzonych znaków 
           mov     liczba_znakow, eax 
; rejestr ECX pe³ni rolê licznika obiegów pêtli 
           mov     ecx, eax 
           mov     ebx, 0    ; indeks pocz¹tkowy 
 
ptl:          
		   mov     dl, magazyn[ebx] ; pobranie kolejnego znaku 
		   cmp	   dl, 0A5H ; ¹
		   jne	   przeskocz_a ; nastepne instrukcje sa specyficzne dla litery ¹, jak jest jakakolwiek inna litera trzeba je pominac

	       sub	dl, 1 ; kod ma³ego ¹ to 165, du¿ego 164
		   mov	magazyn[ebx], dl ; wrzucenie zmienionej litery z rejestru do odpowiedniej komorki pamieci
		   inc  ebx
		   dec	ecx ; kolejny obieg petli, dla nastepnej litery
		   jnz	ptl

przeskocz_a:
		   cmp	dl, 86H ; æ
		   jne	przeskocz_c
		   add	dl, 9
		   mov	magazyn[ebx], dl
		   inc	ebx
		   dec ecx
		   jnz ptl

przeskocz_c:
		   cmp dl, 0A9H ;ê
		   jne przeskocz_e
		   sub dl, 1
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_e:
		   cmp dl, 88H ;³
		   jne przeskocz_l
		   add dl, 21
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_l:
		   cmp dl, 0E4H ;ñ
		   jne przeskocz_n
		   sub dl, 1
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_n:
		   cmp dl, 0A2H ;ó
		   jne przeskocz_o
		   add dl, 62
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_o:
		   cmp dl, 98H
		   jne przeskocz_s
		   sub dl, 1
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_s:
		   cmp dl, 0ABH
		   jne przeskocz_ziet
		   sub dl, 30
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_ziet:
		   cmp dl, 0BEH
		   jnz przeskocz_zet
		   sub dl, 1
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_zet:
           cmp     dl, 'a' 
           jb      dalej   ; skok, gdy znak nie wymaga zamiany 
           cmp     dl, 'z' 
           ja      dalej   ; skok, gdy znak nie wymaga zamiany 

           sub     dl, 20H ; zamiana na wielkie litery 
           mov     magazyn[ebx], dl ; odes³anie znaku do pamiêci

dalej:
		   inc     ebx     ; inkrementacja indeksu 
           dec ecx
		   jnz ptl     ; sterowanie pêtl¹ 

 
; wyœwietlenie przekszta³conego tekstu 
           push    liczba_znakow 
           push    OFFSET magazyn 
           push    1 
           call    __write  ; wyœwietlenie przekszta³conego tekstu 
           add     esp, 12  ; usuniecie parametrów ze stosu  
 
           push    0 
           call    _ExitProcess@4      ; zakoñczenie programu 
 
END