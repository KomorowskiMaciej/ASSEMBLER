.686 
.model flat 

public _szukaj4_max 

.code 

_szukaj4_max  PROC 
	push   ebp    ; zapisanie zawartoœci EBP na stosie 
	mov    ebp, esp  ; kopiowanie zawartoœci ESP do EBP 
 
	mov    eax, [ebp+8]  ; liczba x 
	cmp    eax, [ebp+12]  ; porownanie liczb x i y 
	jge    x_wieksza   ; skok, gdy x >= y 
 
	; przypadek x < y
	mov    eax, [ebp+12]  ; liczba y 
	cmp    eax, [ebp+16]  ; porownanie liczb y i z 
	jge    y_wieksza   ; skok, gdy y >= z 

x_mniejszyodz:
	;przypadek y < z
	mov eax, [ebp+16] ;liczba z
	cmp eax, [ebp+20] ;porownanie z i a
	jge z_wiekszy
 
	; przypadek z < a 
	; zatem a jest liczb¹ najwieksz¹ 
wpisz_a:  mov  eax, [ebp+20]  ; liczba a
 
zakoncz: 
	pop    ebp 
	ret 
 
x_wieksza: 
	cmp    eax, [ebp+16]  ; porownanie x i z 
	jge    x_wiekszyodz    ; skok, gdy x >= z 
	jmp x_mniejszyodz
 
y_wieksza: 
	mov    eax, [ebp+12]  ; liczba y 
	cmp		eax, [ebp+20] ;liczba a
	jge zakoncz
	jmp wpisz_a ;a jest najwieksze

x_wiekszyodz:
	cmp eax, [ebp+20] ;porownanie x i a
	jge zakoncz ;x jest najwiekszy
z_wiekszy:
	jmp zakoncz ;z jest najwiekszy


 
_szukaj4_max  ENDP 
END