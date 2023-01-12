dosseg
.model small
.data
a db 123
.stack 256h
.code
pstart:
mov ax, @data
mov ds, ax
mov ah, 4ch
int 21h
end pstart

