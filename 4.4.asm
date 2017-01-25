.686 
.model flat 
public  _przestaw 
.code 
 
_przestaw PROC 
  push   ebp    ; zapisanie zawartoœci EBP na stosie 
  mov    ebp,esp  ; kopiowanie zawartoœci ESP do EBP 
  push   ebx    ; przechowanie zawartoœci rejestru EBX 
 
  mov    ebx, [ebp+8]  ; adres tablicy tabl 
  mov    ecx, [ebp+12]  ; liczba elementów tablicy 
  dec    ecx 
 
; wpisanie kolejnego elementu tablicy do rejestru EAX            
ptl: mov    eax, [ebx]   
 
; porównanie elementu tablicy wpisanego do EAX z nastêpnym 
  cmp    eax, [ebx+4] 
  jle    gotowe ; skok, gdy nie ma przestawiania  
 
; zamiana s¹siednich elementów tablicy 
  mov    edx, [ebx+4] 
  mov    [ebx], edx 
  mov    [ebx+4], eax 
 
gotowe: 
  add    ebx, 4  ; wyznaczenie adresu kolejnego elementu 
  loop   ptl    ; organizacja pêtli 
  pop    ebx    ; odtworzenie zawartoœci rejestrów 
  pop    ebp 
  ret        ; powrót do programu g³ównego 
_przestaw   ENDP 
END 