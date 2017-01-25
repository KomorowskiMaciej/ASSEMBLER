.686
.XMM
.model flat 
.data
tablica dd 1.0, 1.0, 1.0, 1.0
aux dd 0.0


ALIGN 16 
tabl_A  dd  1.0, 2.0, 3.0, 4.0 
tabl_B  dd  2.0, 3.0, 4.0, 5.0 
liczba  db  1 
tabl_C  dd  3.0, 4.0, 5.0, 6.0 

.code 

_dodawanie_SSE  PROC 
       push      ebp 
       mov       ebp, esp 
       mov       eax, [ebp+8] 
 
       movaps    xmm2, tabl_A 
       movaps    xmm3, tabl_B 
       movups    xmm4, tabl_C 
 
       addps     xmm2, xmm3 
       addps     xmm2, xmm4 
       movups    [eax], xmm2 
 
       pop        ebp 
       ret 
_dodawanie_SSE  ENDP 
END 
 
 _pm_jeden PROC 
			 mov edi, [esp+4]
		     movups   xmm5, [edi]
             movups   xmm6, tablica 
 
             addsubps    xmm5, xmm6
                                    
             movups   [edi], xmm5 

             ret 
_pm_jeden ENDP 

_int2float PROC 
             push  ebp 
             mov   ebp, esp

             push  esi 
             push  edi 
 
             mov   esi, [ebp+8]    ; adres pierwszej tablicy 
             mov   edi, [ebp+12]   ; adres drugiej tablicy 
 
             movups   xmm5, [edi] 
             cvtpi2ps    xmm5, qword PTR [esi] 
             movups   [edi], xmm5 
 
             pop   edi 
             pop   esi 
             pop   ebp 
             ret 
_int2float ENDP 

_dodaj_SSE_char PROC 
             push  ebp 
             mov   ebp, esp
 
             push  ebx 
             push  esi 
             push  edi 
 
             mov   esi, [ebp+8]    ; adres pierwszej tablicy 
             mov   edi, [ebp+12]   ; adres drugiej tablicy 
             mov   ebx, [ebp+16]   ; adres tablicy wynikowej 
 
             movups   xmm5, [esi] 
             movups   xmm6, [edi] 
 
             paddsb    xmm5, xmm6 
                                    
             movups   [ebx], xmm5  
 
             pop   edi 
             pop   esi 
             pop   ebx 
             pop   ebp 
             ret 
_dodaj_SSE_char ENDP 

_nowy_exp PROC
push ebp
mov ebp, esp
mov edx, [ebp + 8]

mov ebx, 0
mov ecx, 20
finit
fldz; jezeli dodam niezaladowany element stosu to wali #IND
fldz
fldz
main_loop:
	mov eax, 1
	mov ebx, 21
	sub ebx, ecx
	fld1
	single_loop:
		; mianownik
		push edx
		mul ebx
		pop edx

		mov aux, edx
		fld aux
		fmulp

		dec ebx
		cmp ebx, 0
	ja single_loop
	mov aux, eax
	fild aux
	fdiv 
	fadd
loop main_loop
mov esp, ebp
pop ebp
ret
_nowy_exp ENDP


_srednia_harm PROC
push ebp
mov ebp, esp

mov ecx, [ebp+12] ; wielkosc
mov ebx, [ebp + 8]
finit
fldz

et:
mov edx, [ebx + ecx * 4 - 4]
mov aux, edx

fld aux
fld1
fdiv
faddp

loop et

finish:
mov ecx, [ebp+12]
mov aux, ecx
fild aux
fdivp
mov esp,ebp
pop ebp
ret
_srednia_harm ENDP
END 