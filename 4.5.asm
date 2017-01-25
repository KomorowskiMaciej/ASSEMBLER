public suma_siedmiu_liczb
 
.code 
 
suma_siedmiu_liczb  PROC 
	mov rax, rcx
	add rax, rdx
	add rax, r8
	add rax, r9
	add rax, [rsp+40]
	add rax, [rsp+48]
	add rax, [rsp+56]
	ret 
suma_siedmiu_liczb  ENDP 
 
END