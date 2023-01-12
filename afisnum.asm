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
		
        mov ax, 491
        mov bx, 10
        mov cx, 0
        
        descompune:
            mov dx, 0
            div bx
            push dx
            inc cx
            cmp ax, 0
            je afiseazaCifre
        jmp descompune
         
        afiseazaCifre:
            pop dx
            add dl, 48
            mov ah, 02h
            int 21h

        loop afiseazaCifre
        
        mov ah, 4ch  ; software interruption
        int 21h
	end main 