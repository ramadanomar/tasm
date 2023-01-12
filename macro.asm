.model small
.stack 100h
.data
.code 
	totAfisareCaracter proc
		mov ah, 02h
		int 21h
		ret
	endp
	
	
	main:
		mov ax, @data
		mov ds, ax
		
		afisareCaracter macro caracter
				mov dl, caracter
				mov ah, 02h
				int 21h
		endm
		
		afisareCaracter "K"
		afisareCaracter "/"
		afisareCaracter "3"
		
		mov dl, "W"
		call totAfisareCaracter
		mov dl, "*"
		call totAfisareCaracter
		
		mov ah, 4ch  ;intrerupere software
		int 21h
	end main 