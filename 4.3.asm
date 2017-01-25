.686 
.model flat 
public  _odejmij_jeden 
.code 
 
_odejmij_jeden PROC 
  push   ebp    ; zapisanie zawartoœci EBP na stosie 
  mov    ebp,esp  ; kopiowanie zawartoœci ESP do EBP 
  push   ebx    ; przechowanie zawartoœci rejestru EBX 
 
; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej 
; w kodzie w jêzyku C 
  mov     ebx, [ebp+8] ;wstawienie do ebx adresu wskaznika *wsk (adresu adresu k)
 
  mov   eax, [ebx]  ; wstawienie adresu k do eax
  mov	ebx, [eax] ;odczytanie zmiennej k
  sub	ebx, 1   ; odjecie 1
  mov   [eax], ebx  ; odes³anie wyniku do eax
   
; uwaga: trzy powy¿sze rozkazy mo¿na zast¹piæ jednym rozkazem 
; w postaci:  inc   dword PTR [ebx] 
   
  pop    ebx 
  pop    ebp 
  ret 
_odejmij_jeden  ENDP 
END 