.686
.model flat

extern _malloc : PROC

public _half_to_float
public _float_to_half
public _test
public _uint48_float
public _zamien_na_base12
public _zamien_z_base12
public _roznica
public _kopia_tablicy
public _komunikat
public _kwadrat
public _iteracja
public _pole_kola
public _avg_wg
public _NWD
public _miesz2float
public _float_razy_float

.data
	testb db 5
	testw dw 10
	testd dd 15
	testq dq 20

	val dd 0
		  db 0A0h
		  db 0FFh
		  db 43h
	tval  db 00h
	tval0 db 20h
		  db 7Fh
		  db 0C3h

	znaki dw 30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 218Ah, 218Bh

	blad db 'B', '³', '¹', 'd', '.', 0
 
.code

_zamien_z_base12 PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]

	xor ebx, ebx
	xor eax, eax
	mov edi, 0

petla:
	mov bx, [esi+edi*2]
	inc edi

	cmp bx, 0
	je koniec

	add eax, ebx

	cmp bx, 39h
	jng cyfra

	; znaki 218A i 218B
	sub eax, 2180h
	jmp petla

koniec:

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret

cyfra:
	sub eax, 30h
	jmp petla

_zamien_z_base12 ENDP

; wchar_t* zamien_na_base12(unsigned int liczba)
_zamien_na_base12 PROC
	push ebp
	mov ebp, esp
	push esi
	push ebx
	push edi
	

	push 9
	call _malloc
	add esp, 4
	mov edi, eax
	mov esi, edi

	mov eax, [ebp+8] ; liczba

petla:
	mov ebx, 12
	xor edx, edx
	div ebx ; eax = edx:eax / 12, edx = rest

	mov bx, [znaki + edx*2]
	mov [edi], bx

	inc edi
	cmp eax, 0
	jne petla

	mov [edi], word ptr 0


	pop edi
	pop ebx
	mov eax, esi
	pop esi
	pop ebp
	ret
_zamien_na_base12 ENDP


_uint48_float PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ecx, 127 ; wykladnik

	mov eax, [ebp+6] ; bierze jakies 2 randomowe bajty wczesniej i je zeruje, zeby liczby calkowite byly w ebx, a ulamek w eax
	shr eax, 16
	shl eax, 16
	mov ebx, [ebp+10]

	cmp ebx, 0
	je ulamek

petlaCalkowite:
	cmp ebx, 1
	je koniec

	inc ecx
	shr ebx, 1 ; pierwszy bit do CF
	rcr eax, 1 ; bierze z CF
	jmp petlaCalkowite

ulamek:
	cmp ebx, 1
	je koniec

	dec ecx
	shl eax, 1
	rcl ebx, 1
	jmp ulamek

koniec:
	mov ebx, ecx
	shl ebx, 23
	shr eax, 9
	or ebx, eax
	mov val, ebx

	fld val
	pop ebx
	pop ebp
	ret
_uint48_float ENDP


_half_to_float PROC ; 1 10000 1000000000 -> 1(znak) 10...(8b) 10...(23b)
	finit
	push ebp
	mov ebp, esp
	push ebx

	xor eax, eax

	mov ax, [ebp+8]

	; sam wykladnik
	shl ax, 1
	shr ax, 11

	; 5 bitow - 11111 - -15 - 16
	sub ax, 15

	add ax, 127
	shl eax, 23

	; ustawianie znaku
	xor ebx, ebx
	mov bx, [ebp+8]
	shr ebx, 15
	shl ebx, 31

	or eax, ebx

	;ustawianie mantysy
	xor ebx, ebx
	mov bx, [ebp+8]
	shl bx, 6
	shl ebx, 7

	or eax, ebx

	mov val, eax

	fld val
	pop ebx
	pop ebp
	ret
_half_to_float ENDP

_float_to_half PROC
	push ebp
	mov ebp, esp
	push ebx

	; sam wykladnik
	mov eax, [ebp+8]
	shl eax, 1
	shr eax, 24

	sub eax, 127
	add eax, 15

	shl ax, 10

	; znak
	mov ebx, [ebp+8]
	shr ebx, 31
	shl ebx, 15

	or eax, ebx
	
	; mantysa
	mov ebx, [ebp+8]
	shl ebx, 22
	shr ebx, 9

	or eax, ebx

	pop ebx
	pop ebp
	ret
_float_to_half ENDP

_test PROC
	mov eax, 15
	sub eax, 17
	;finit
	;fld dword ptr tval
	ret
_test ENDP

_roznica PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ebx, [ebp+8]
	mov eax, [ebx]
	mov ebx, [ebp+12]
	mov edx, [ebx]
	mov ebx, [edx]
	; eax = odjemna
	; ebx = odjemnik
	sub eax, ebx

	pop ebx
	pop ebp
	ret
_roznica ENDP

_kopia_tablicy PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8]
	mov ecx, [ebp+12]

	push ecx
	call _malloc ; adres alokowanej pamieci w eax
	add esp, 4
	mov edi, eax

	mov ecx, [ebp+12]

petla:
	mov ebx, [esi]
	mov [edi], ebx
	add esi, 4
	add edi, 4
	loop petla

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_kopia_tablicy ENDP

; int len(char* str)
_len PROC
	mov eax, 0
	mov ecx, [esp+4]
petla:
	mov dl, [ecx]
	cmp dl, 0
	je koniec

	add ecx, 1 ; sizeof(char)
	inc eax
	jmp petla
koniec:
	ret
_len ENDP

_komunikat PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov esi, [ebp+8] ; adres zrodla

	push esi
	call _len ; dlugosc w eax
	add esp, 4

	add eax, 6

	push eax
	call _malloc
	mov edi, eax
	add esp, 4

kopiuj:
	mov bl, [esi]
	cmp bl, 0
	je dalej
	mov [edi], bl

	inc esi
	inc edi
	jmp kopiuj

dalej:
	mov esi, OFFSET[blad]
	
kopiuj2:
	mov bl, [esi]
	cmp bl, 0
	je koniec
	mov [edi], bl

	inc esi
	inc edi
	jmp kopiuj2

koniec:
	mov bl, 0
	mov [edi], bl

	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_komunikat ENDP

_kwadrat PROC
	push ebp
	mov ebp, esp
	push ebx

	mov eax, [ebp+8]
	cmp eax, 1
	jng koniec
	
	mov ebx, eax
	add ebx, eax
	add ebx, eax
	add ebx, eax ; 4*a
	sub ebx, 4

	sub eax, 2
	push eax
	call _kwadrat
	add esp, 4

	add eax, ebx
koniec:

	pop ebx
	pop ebp
	ret
_kwadrat ENDP

_iteracja PROC
	 push ebp
	 mov ebp, esp

	 mov al, [ebp+8]
	 sal al, 1
		; SAL wykonuje przesuniecie logiczne
		; w lewo
	 jc zakoncz

	 inc al
	 push eax
	 call _iteracja
	 add esp, 4
	 pop ebp
	 ret

zakoncz: 
	rcr al, 1
		; rozkaz RCR wykonuje przesuniêcie
		; cykliczne w prawo przez CF
	 pop ebp
	 ret
_iteracja ENDP

_pole_kola PROC
	push ebp
	mov ebp, esp
	finit

	mov eax, [ebp+8] ; adres floata
	fld dword ptr [eax]
	fld st(0)
	fldpi
	fmulp
	fmulp

	fstp dword ptr [eax]

	pop ebp
	ret
_pole_kola ENDP

_avg_wg PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	finit

	mov ecx, [ebp+8] ;  n
	mov esi, [ebp+12] ; tablica
	mov edi, [ebp+16] ; wagi

	fldz

petla:
	fld dword ptr [esi]
	fld dword ptr [edi]
	fmulp
	faddp
	add esi, 4
	add edi, 4
	loop petla

	fild dword ptr [ebp+8]
	fdivp st(1), st(0)



	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_avg_wg ENDP

_NWD PROC
	push ebp
	mov ebp, esp
	push esi
	push edi

	mov esi, [ebp+8] ; a
	mov edi, [ebp+12] ; b

	cmp esi, edi
	je rowne
	jg wieksze

	;mniejsze
	sub edi, esi ; b = b - a
	push esi
	push edi
	call _NWD
	add esp, 8

koniec:

	pop edi
	pop esi
	pop ebp
	ret

rowne:
	mov eax, esi
	jmp koniec

wieksze:
	sub esi, edi ; a = a - b
	push esi
	push edi
	call _NWD
	add esp, 8
	jmp koniec

_NWD ENDP

_miesz2float PROC
	push ebp
	mov ebp, esp
	push ebx

	mov ebx, [ebp+8] ; miesz32
	mov ecx, 127 ; float

	cmp ebx, 100h
	jng ulamek

przesun:
	cmp ebx, 1FFh; 1,0
	jng dalej
	
	shr ebx, 1
	inc ecx ; wspolczynnik
	jmp przesun

ulamek:
	cmp ebx, 100h
	jg dalej

	shl ebx, 1
	dec ecx
	jmp ulamek

dalej:
	and ebx, 0FFh ; zostaw tylko mantyse
	shl ebx, 23-8
	shl ecx, 23
	or ebx, ecx
	
	push ebx
	fld dword ptr [esp]
	add esp, 4
	pop ebx
	pop ebp
	ret
_miesz2float ENDP

_float_razy_float PROC
	push ebp
	mov ebp, esp
	push ebx

	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	; z zalozenia liczby dodatnie

	shr eax, 23 ; sam wykladnik
	shr ebx, 23

	sub eax, 127
	sub ebx, 127

	add eax, ebx
	mov ecx, eax ; ecx - suma wykladnikow

	mov eax, [ebp+8]
	mov ebx, [ebp+12]

	shl eax, 9 ; czyszczenie wykladnika i znaku
	shr eax, 9
	shl ebx, 9
	shr ebx, 9

	or eax, 800000h ; jedynka niejawna
	or ebx, 800000h

	mul ebx ; edx:eax = eax * ebx

	mov ebx, 23 ; musimy cofnac wszystko o 23 bity
przesunedx: ; edx:eax - przesuwamy edx i eax razem, bo wynik jest w obu rejestrach
	cmp edx, 0
	je przesunoebx

	shr edx, 1
	rcr eax, 1

	dec ebx
	jmp przesunedx

przesunoebx: ; jak juz "wysunelismy" z edx wszystko do eax, to przesuwamy same eax
	cmp ebx, 0
	je przesun

	shr eax, 1
	dec ebx
	jmp przesunoebx

przesun:
	cmp eax, 800000h
	jnb przesunwdol

przesunwgore: ; jesli jedynka niejawna jest na mlodszym niz 24 bit(->)
	cmp eax, 800000h
	ja dalej ; jesli jedynka jest na swoim miejscu to dalej

	shl eax, 1
	dec ecx
	jmp przesunwgore
	
przesunwdol: ; jesli jedynka niejawna jest na starszym niz 24 bit(<-)
	cmp eax, 1000000h
	jb dalej ; jesli jedynka jest na swoim miejscu to dalej

	shr eax, 1
	inc ecx
	jmp przesunwdol

dalej:
	and eax, 7FFFFFh ; usuwam jedynke niejawna
	add ecx, 127 ; do wskaznika
	shl ecx, 23 ; wskaznik na swoje miejsce
	or eax, ecx ; wrzucam wskaznik do floata

	push eax
	fld dword ptr [esp]
	add esp, 4
	pop ebx
	pop ebp
	ret
_float_razy_float ENDP

END