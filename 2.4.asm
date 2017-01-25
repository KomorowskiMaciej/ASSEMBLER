; wczytywanie i wy�wietlanie tekstu wielkimi literami 
; (inne znaki si� nie zmieniaj�) 
 
.686 
.model flat 
extern  _ExitProcess@4 : PROC 
extern  __write : PROC  ; (dwa znaki podkre�lenia) 
extern  __read  : PROC  ; (dwa znaki podkre�lenia) 
public  _main 
 
.data 
tekst_pocz  db  10, 'Prosz� napisa� jaki� tekst ' 
db  'i nacisnac Enter', 10 
koniec_t    db  ? 
magazyn    db  80 dup (?) 
nowa_linia    db  10 
liczba_znakow  dd  ? 
 
.code 
_main: 
 
; wy�wietlenie tekstu informacyjnego 
 
; liczba znak�w tekstu 
           mov     ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) 
           push    ecx 
 
           push    OFFSET tekst_pocz  ; adres tekstu 
           push    1  ; nr urz�dzenia (tu: ekran - nr 1) 
           call    __write  ; wy�wietlenie tekstu pocz�tkowego 
 
           add     esp, 12  ; usuniecie parametr�w ze stosu 
 
; czytanie wiersza z klawiatury 
           push    80 ; maksymalna liczba znak�w 
           push    OFFSET magazyn 
           push    0  ; nr urz�dzenia (tu: klawiatura - nr 0) 
           call    __read ; czytanie znak�w z klawiatury 
           add     esp, 12  ; usuniecie parametr�w ze stosu 
; kody ASCII napisanego tekstu zosta�y wprowadzone 
; do obszaru 'magazyn' 
 
; funkcja read wpisuje do rejestru EAX liczb� 
; wprowadzonych znak�w 
           mov     liczba_znakow, eax 
; rejestr ECX pe�ni rol� licznika obieg�w p�tli 
           mov     ecx, eax 
           mov     ebx, 0    ; indeks pocz�tkowy 
 
ptl:          
		   mov     dl, magazyn[ebx] ; pobranie kolejnego znaku 
		   cmp	   dl, 0A5H ; �
		   jne	   przeskocz_a ; nastepne instrukcje sa specyficzne dla litery �, jak jest jakakolwiek inna litera trzeba je pominac

	       sub	dl, 1 ; kod ma�ego � to 165, du�ego 164
		   mov	magazyn[ebx], dl ; wrzucenie zmienionej litery z rejestru do odpowiedniej komorki pamieci
		   inc  ebx
		   dec	ecx ; kolejny obieg petli, dla nastepnej litery
		   jnz	ptl

przeskocz_a:
		   cmp	dl, 86H ; �
		   jne	przeskocz_c
		   add	dl, 9
		   mov	magazyn[ebx], dl
		   inc	ebx
		   dec ecx
		   jnz ptl

przeskocz_c:
		   cmp dl, 0A9H ;�
		   jne przeskocz_e
		   sub dl, 1
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_e:
		   cmp dl, 88H ;�
		   jne przeskocz_l
		   add dl, 21
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_l:
		   cmp dl, 0E4H ;�
		   jne przeskocz_n
		   sub dl, 1
		   mov magazyn[ebx], dl
		   inc ebx
		   dec ecx
		   jnz ptl
przeskocz_n:
		   cmp dl, 0A2H ;�
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
           mov     magazyn[ebx], dl ; odes�anie znaku do pami�ci

dalej:
		   inc     ebx     ; inkrementacja indeksu 
           dec ecx
		   jnz ptl     ; sterowanie p�tl� 

 
; wy�wietlenie przekszta�conego tekstu 
           push    liczba_znakow 
           push    OFFSET magazyn 
           push    1 
           call    __write  ; wy�wietlenie przekszta�conego tekstu 
           add     esp, 12  ; usuniecie parametr�w ze stosu  
 
           push    0 
           call    _ExitProcess@4      ; zako�czenie programu 
 
END