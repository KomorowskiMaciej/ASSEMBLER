.686 
.model flat 
public  _nowy_exp
.code 
 
_nowy_exp PROC 
	push   ebp    ; zapisanie zawartoœci EBP na stosie 
	mov    ebp,esp  ; kopiowanie zawartoœci ESP do EBP 
	push ecx
	mov ecx, 18


  
	finit
	fld dword PTR [ebp+8] ; ST(4) = suma wyrazow szeregu
	fld dword PTR [ebp+8] ; ST(3) = x do wymnazania
	fld1 ; ST(2) = 1 do dodawania do st(3)
	fld1 ; ST(1) = 1 tu bedzie mianownik
	fld dword PTR [ebp+8] ; ST(0) = bierzacy wyraz szeregu
kolejny_wyraz:
	fmul st(0), st(3) ;wymnozenie biezacego wyrazu przez x
	fst st(5) ;skopiowanie wymnozonego wyrazu
	fstp st(0); ST(0) - mianownik ST1 - jedynka ST2 - x do wymnazania st3 - suma szeregu st4 - biezacy wyraz

	fadd st(0), st(1) ;zwiekszenie mianownika
	fst st(5);skopiowanie mianownika
	fstp st(0) ; ST(0) - jedynka ST1 - x do wymnazania ST2 - suma szereg st3 - biezacy wyraz st4 - mianownik
	fst st(5);skopiowanie jedynki
	fstp st(0) ; ST(0) - x do wymnazania ST1 - suma szereg ST2 - biezacy wyraz st3 - mianownik st4- jedynka

	fst st(5);skopiowanie x do wymn
	fstp st(0) ; ST(0) - suma szereg ST1 - biezacy wyraz ST2 - mianownik st3 - jedynka st4- x

	fst st(5);skopiowanie sumy sz
	fstp st(0) ; ST(0) -biezacy wyraz ST1 - mianownik ST2 -  jedynka st3 - x st4- suma szer

	fdiv st(0), st(1) ;dzielenie przez mianownik
	

	fadd st(4), st(0) ;dodanie biezacego wyrazu do sumy
	loop kolejny_wyraz

	fstp st(0)
	fstp st(0)
	fstp st(0)
	fstp st(0)
	fld1
	fadd st(0), st(1)

	pop ecx
	pop    ebp 
	ret        ; powrót do programu g³ównego 
_nowy_exp  ENDP 
END 