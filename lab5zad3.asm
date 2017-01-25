.686 
.XMM
.model flat 

public _sumuj
 
.code 

_sumuj PROC
	push ebp
	mov ebp, esp
	push edi
	push esi
	push edx
	mov esi, [ebp+8] ;tab1
	mov edx, [ebp+12] ;tab2
	mov edi, [ebp+16] ;wynik
	mov ecx, [ebp+20] ;obiegi
petla:
			 vmovups   ymm0, [esi] 
             vmovups   ymm1, [edx] 
			 vmovups   ymm2, [edi]
             VADDPS    ymm2, ymm0, ymm1 
			 vmovups   [edi], ymm2
			 add esi, 32
			 add  edx, 32
			 add edi, 32
			 sub ecx, 8
			 cmp ecx, 0
			 jnz petla
pop edx
pop esi
pop edi
pop ebp
             ret 
_sumuj ENDP
 
END