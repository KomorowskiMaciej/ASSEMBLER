.686 
.model flat 
public  _przestaw 
.code 
 
_przestaw PROC 
  push   ebp    ; zapisanie zawarto�ci EBP na stosie 
  mov    ebp,esp  ; kopiowanie zawarto�ci ESP do EBP 
  push   ebx    ; przechowanie zawarto�ci rejestru EBX 
 
  mov    ebx, [ebp+8]  ; adres tablicy tabl 
  mov    ecx, [ebp+12]  ; liczba element�w tablicy 
  dec    ecx 
 
; wpisanie kolejnego elementu tablicy do rejestru EAX            
ptl: mov    eax, [ebx]   
 
; por�wnanie elementu tablicy wpisanego do EAX z nast�pnym 
  cmp    eax, [ebx+4] 
  jle    gotowe ; skok, gdy nie ma przestawiania  
 
; zamiana s�siednich element�w tablicy 
  mov    edx, [ebx+4] 
  mov    [ebx], edx 
  mov    [ebx+4], eax 
 
gotowe: 
  add    ebx, 4  ; wyznaczenie adresu kolejnego elementu 
  loop   ptl    ; organizacja p�tli 
  pop    ebx    ; odtworzenie zawarto�ci rejestr�w 
  pop    ebp 
  ret        ; powr�t do programu g��wnego 
_przestaw   ENDP 
END 