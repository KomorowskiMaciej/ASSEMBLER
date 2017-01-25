;ZAD 2.2

; Przyk³ad wywo³ywania funkcji MessageBoxA i MessageBoxW 
.686 
.model flat 
extern     _ExitProcess@4  : PROC 
extern     _MessageBoxA@16 : PROC 
extern     _MessageBoxW@16 : PROC 
public     _main 
 
.data 
tytul_Unicode	db  'T',0,'e',0,'k',0,'s',0,'t',0,' ',0 
				db  'w',0,' ',0 
				db  's',0,'t',0,'a',0,'n',0,'d',0,'a',0,'r',0 
				db  'd',0,'z',0,'i',0,'e',0,' ',0 
				db  'U',0,'n',0,'i',0,'c',0,'o',0,'d',0,'e',0 
				db  0,0 
 
tekst_Unicode	db  'K',0,'a',0,7CH,01H,'d',0,'y',0 
				db  ' ',0,'z',0,'n',0,'a',0,'k',0,' ',0 
				db  'z',0,'a',0,'j',0,'m',0,'u',0,'j',0,'e',0 
				db  ' ',0 
				db  '1',0,'6',0,' ',0,'b',0,'i',0,'t',0,0F3H,0 
				db  'w',0,0,0 
 
tytul_Win1250   db  'Tekst w standardzie Windows 1250', 0			 ; polskie znaki dla funkcji _MessageBoxA@16 trzeba kodowac w standardzie Windows 1250
tekst_Win1250   db  'Ka',0BFH,'dy znak zajmuje 8 bit',0F3H,'w', 0 
 
.code 
_main: 
           push    0       ; sta³a MB_OK 
 
; adres obszaru zawieraj¹cego tytu³ 
           push    OFFSET tytul_Win1250  
 
; adres obszaru zawieraj¹cego tekst  
           push    OFFSET tekst_Win1250 
 
           push    0       ; NULL 
           call    _MessageBoxA@16 
 
 
           push    0       ; stala MB_OK 
 
; adres obszaru zawieraj¹cego tytu³ 
           push    OFFSET tytul_Unicode 
 
; adres obszaru zawieraj¹cego tekst 
           push    OFFSET tekst_Unicode 
 
           push    0       ; NULL 
           call    _MessageBoxW@16 
 
           push    0       ; kod powrotu programu 
           call    _ExitProcess@4 
END