.686 
.XMM  ; zezwolenie na asemblacj rozkazów grupy SSE 
.model flat 

.data
tablica dd 1.0, 1.0, 1.0, 1.0
 
public _pm_jeden
 
.code 
 
_pm_jeden PROC 
			 mov edi, [esp+4]
		     movups   xmm5, [edi]
             movups   xmm6, tablica 
 
             addsubps    xmm5, xmm6
                                    
             movups   [edi], xmm5 

             ret 
_pm_jeden ENDP 
 
END