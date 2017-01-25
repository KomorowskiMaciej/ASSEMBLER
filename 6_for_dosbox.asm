.386 
rozkazy  SEGMENT  use16 
ASSUME  CS:rozkazy 
 
wyswietl_AL  PROC 
; wyswietlanie zawartosci rejestru AL na ekranie wg adresu  podanego w ES:BX
; stosowany jest bezposredni zapis do pamieci ekranu  
 
; przechowanie rejestrów 
  push ax  
  push cx 
  push dx
 
  mov  cl, 10  ; dzielnik 
         
  mov  ah, 0  ; zerowanie starszej czesci dzielnej 
 
; dzielenie liczby w AX przez liczbe w CL, iloraz w AL, reszta w AH (tu: dzielenie przez 10) 
  div  cl   
 
  add    ah, 30H ; zamiana na kod ASCII 
  mov    es:[bx+4], ah ; cyfra jednosci 
 
  mov    ah, 0 
  div    cl ; drugie dzielenie przez 10 
  add    ah, 30H ; zamiana na kod ASCII 
  mov    es:[bx+2], ah ; cyfra dziesiatek 
  add    al, 30H ; zamiana na kod ASCII 
  mov    es:[bx+0], al ; cyfra setek 
 
; wpisanie kodu koloru (intensywny bia³y) do pamieci ekranu 
  mov    al, 00001111B 
  mov    es:[bx+1],al 
  mov    es:[bx+3],al 
  mov    es:[bx+5],al 
  
; odtworzenie rejestrów 
  pop    dx 
  pop    cx 
  pop    ax 
  ret

wyswietl_AL  ENDP 


obsluga_zegara   PROC 
	; przechowanie uywanych rejestrów 

	push   ax       
	push   bx 
	push   es 
 	
	cmp cs:trigger, 1
	jne etk2
	inc cs:licznik
	etk2:
	
	mov al, cs:licznik
	call wyswietl_al
	pop    es 
	pop    bx 
	pop    ax 
 
	; skok do oryginalnej procedury obs³ugi przerwania zegarowego 
	jmp    dword PTR cs:wektor8 
 
	; dane programu ze wzgldu na specyfik obs³ugi przerwa 
	; umieszczone s w segmencie kodu 
	licznik    db  0  ; wywietlanie poczwszy od 2. wiersza
	wektor8    dd  ? 
obsluga_zegara          ENDP 

obsluga_klawiatury PROC	
	in al, 60H
	
	cmp al, 57
	jne etk1
	cmp cs:trigger2, 0
	jne etk1
		mov cs:trigger2, 1
		
		cmp cs:trigger, 0
		pushf
		mov cs:trigger, 0
		popf
		jne etk4
			mov cs:trigger, 1
		etk4:
	etk1:
	
	cmp al, 185
	jne etk3
		mov cs:trigger2, 0
	etk3:
	
	jmp dword PTR cs:wektor9

	wektor9 dd ?
	trigger    db  0
	trigger2   db  0 
obsluga_klawiatury ENDP
 
;============================================================ 
; program g³ówny 
 
zacznij: 
	mov al, 0
	mov ah, 5
	int 10
	mov ax, 0
	mov ds, ax
	
		; odczytanie zawartoci wektora nr 8 i zapisanie go w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamici 4 bajty poczwszy od adresu fizycznego 8 * 4 = 32) 
	mov    eax,ds:[32]  ; adres fizyczny 0*16 + 32 = 32 
	mov    cs:wektor9, eax   


	; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara' 
	mov    ax, SEG obsluga_zegara ; cz segmentowa adresu 
	mov    bx, OFFSET obsluga_zegara ; offset adresu 
 
	cli    ; zablokowanie przerwa  
 
	; zapisanie adresu procedury do wektora nr 9
	mov    ds:[32], bx   ; OFFSET           
	mov    ds:[34], ax   ; cz. segmentowa 
 
	sti      ;odblokowanie przerwa 
	

	; odczytanie zawartoci wektora nr 8 i zapisanie go w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamici 4 bajty poczwszy od adresu fizycznego 8 * 4 = 32) 
	mov    eax,ds:[36]  ; adres fizyczny 0*16 + 32 = 32 
	mov    cs:wektor8, eax   


	; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara' 
	mov    ax, SEG obsluga_klawiatury ; cz segmentowa adresu 
	mov    bx, OFFSET obsluga_klawiatury ; offset adresu 
 
	cli    ; zablokowanie przerwa  
 
	; zapisanie adresu procedury do wektora nr 9
	mov    ds:[36], bx   ; OFFSET           
	mov    ds:[38], ax   ; cz. segmentowa 
 
	sti      ;odblokowanie przerwa 

	push bx
	push cx
	push es
    mov cx, 0B800h ;adres pamieci ekranu
	mov es, cx
	mov bx, 0
aktywne_oczekiwanie: 
	mov ah,1       
	int 16H              
	; funkcja INT 16H (AH=1) BIOSu ustawia ZF=1 jeli nacinito jaki klawisz 
	jz    aktywne_oczekiwanie 
 
	; odczytanie kodu ASCII nacinitego klawisza (INT 16H, AH=0)  do rejestru AL 
	mov    ah, 0 
	int    16H 
	cmp    al, 1BH    ; porównanie z kodem klawisza esc
	je    koniec   ; skok, gdy esc

	mov bx, 0
	jmp aktywne_oczekiwanie
koniec:
	; zakoczenie programu 

	; odtworzenie oryginalnej zawartoci wektora nr 8 
	mov    eax, cs:wektor9
	cli 
	mov    ds:[36], eax  ; przes³anie wartoci oryginalnej do wektora 8 w tablicy wektorów przerwa 
	sti 

	pop es
	pop cx
	pop bx
	mov    al, 0 
	mov    ah, 4CH 
	int    21H 

rozkazy    ENDS 
   
nasz_stos   SEGMENT  stack 
	db    128 dup (?) 
nasz_stos   ENDS 
 
END  zacznij 