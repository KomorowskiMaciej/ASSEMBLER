.686 
.model flat 
public  _odejmij_jeden 
.code 
 
_odejmij_jeden PROC 
  push   ebp    ; zapisanie zawarto�ci EBP na stosie 
  mov    ebp,esp  ; kopiowanie zawarto�ci ESP do EBP 
  push   ebx    ; przechowanie zawarto�ci rejestru EBX 
 
; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej 
; w kodzie w j�zyku C 
  mov     ebx, [ebp+8] ;wstawienie do ebx adresu wskaznika *wsk (adresu adresu k)
 
  mov   eax, [ebx]  ; wstawienie adresu k do eax
  mov	ebx, [eax] ;odczytanie zmiennej k
  sub	ebx, 1   ; odjecie 1
  mov   [eax], ebx  ; odes�anie wyniku do eax
   
; uwaga: trzy powy�sze rozkazy mo�na zast�pi� jednym rozkazem 
; w postaci:  inc   dword PTR [ebx] 
   
  pop    ebx 
  pop    ebp 
  ret 
_odejmij_jeden  ENDP 
END 