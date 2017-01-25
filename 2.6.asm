; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
extern _MessageBoxA@16 : PROC ; biblioteka do okienka 
extern _MessageBoxW@16 : PROC ; biblioteka do okienka 
public _main
.data
tytul_okna db 'Architektura komputerow zad5',0
tytul_okna_utf8 db 'A',0,'k',0,'o',0,0,0
tekst_pocz db 10, 'Prosze napisac jakiś tekst '
db 'i nacisnac Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
magazyn2 dw 180 dup (?)
nowa_linia db 10
liczba_znakow dd ? 


pl_znaki_latin2		db 0A5H, 0A4H, 86H, 8FH, 0A9H, 0A8H, 88H, 9DH, 0E4H, 0E3H ; ąĄćĆęĘłŁńŃ
					db 0A2H, 0E0H, 98H, 97H, 0ABH, 8DH, 0BEH, 0BDH ; óÓśŚźŹżŻ
pl_znaki_win1250	db 0A5H, 0A5H, 0C6H, 0C6H, 0CAH, 0CAH, 0A3H, 0A3H, 0D1H, 0D1H ; ąĄćĆęĘłŁńŃ
					db 0D3H, 0D3H, 8CH, 8CH, 8FH, 8FH, 0AFH, 0AFH ; óÓśŚźŹżŻ

pl_znaki_unicode	dw 0104H, 0104H, 0106H, 0106H, 0118H, 0118H, 0141H, 0141H, 0143H, 0143H ; ąĄćĆęĘłŁńŃ
					dw 00D3H, 00D3H, 015AH, 015AH, 0179H, 0179H, 017BH, 017BH ; óÓśŚźŹżŻ

.code
_main:
	; wyświetlenie tekstu informacyjnego
	; liczba znaków tekstu

	 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	 push ecx
	 push OFFSET tekst_pocz ; adres tekstu
	 push 1 ; nr urządzenia (tu: ekran - nr 1)

	 call __write ; wyświetlenie tekstu początkowego

	 add esp, 12 ; usuniecie parametrów ze stosu

	; czytanie wiersza z klawiatury
	 push 80 ; maksymalna liczba znaków
	 push OFFSET magazyn
	 push 0 ; nr urządzenia (tu: klawiatura - nr 0)
	 call __read ; czytanie znaków z klawiatury
	 add esp, 12 ; usuniecie parametrów ze stosu
	; kody ASCII napisanego tekstu zostały wprowadzone

	; do obszaru 'magazyn'
	; funkcja read wpisuje do rejestru EAX liczbę
	; wprowadzonych znaków
	 mov liczba_znakow, eax
	; rejestr ECX pełni rolę licznika obiegów pętli
	 mov ecx, eax
	 mov ebx, 0 ; indeks początkowy

ptl: 
	mov dl, magazyn[ebx] ; pobranie kolejnego znaku
	mov dh, 0 ;
	cmp dl, 'a'
	jb dalej ; skok, gdy znak nie wymaga zamiany

	;Wyszukiwanie polskich liter
	
	mov ebp,0
	ptl2:
		cmp dl,pl_znaki_latin2[ebp]
		
		jne jezeli_nie
			
			mov dl,pl_znaki_win1250[ebp] 
			mov magazyn[ebx], dl
			mov dx,pl_znaki_unicode[2*ebp] 
			mov magazyn2[2*ebx], dx;
			je dalej_2
jezeli_nie:
		inc ebp
		cmp ebp,18 ; liczba liter do podmiany
		jb ptl2
	;mov e

	cmp dl, 'z'
	ja dalej ; skok, gdy znak nie wymaga zamiany



	sub dl, 20H ; zamiana na wielkie litery
	
	; odesłanie znaku do pamięci
	dalej: 
	mov magazyn[ebx], dl
	mov magazyn2[2*ebx], dx;
	dalej_2:
	inc ebx ; inkrementacja indeksu
	dec ecx ; zmniejszenie o jeden ecx 
	jnz ptl ; bedzie skakał dopuki ecx wieksze od 0 

	push 0; MB_OK
	push OFFSET tytul_okna; tytul okna
	push OFFSET magazyn; wrzucenie przerobionego tekstu 
	push 0;
	call _MessageBoxA@16 ; Wywolanie funckji 

	push 0; MB_OK
	push OFFSET tytul_okna_utf8; tytul okna
	push OFFSET magazyn2; wrzucenie przerobionego tekstu 
	push 0;
	call _MessageBoxW@16 ; Wywolanie funckji 

	 push 0
	 call _ExitProcess@4 ; zakończenie programu
END 