.model small
; 80286 instruction set (procesor registru altfel crash pe vm)
; http://www.bitsavers.org/pdf/borland/turbo_assembler/Turbo_Assembler_Version_5_Quick_Reference.pdf
; Pagina 28
; Enables assembly of non-privileged (real mode) 80286 processor instructions
; and 80287 numeric coprocessor instructions .
.286

.data
    a      dw 3
    b      dw 10
    c      dw 5
    flag   dw 0
    mesaj1 db 'a, b, c - laturi triunghi $'
    mesaj2 db 'a, b, c - nu sunt laturi triunghi $'

.stack 100h
.code

    start:     
    ; INITIALIZARE SEGMENT DE DATE
               mov ax, @data
               mov ds, ax
    
               mov ax, a
               add ax, b
               cmp ax, c
    ;  DACA A+B > C SARI CATRE SALT 1 ALTFEL FLAG
               jge salt1
               inc flag
    salt1:     
               mov ax,b
               add ax,c
               cmp ax,a
    ;  DACA B+C > a SARI CATRE SALT 2
               jge salt2
               inc flag
    salt2:     
               mov ax,c
               add ax,a
               cmp ax,b
    ;  DACA A+C > B SARI CATRE SALT 3
               jge salt3
               inc flag
    salt3:     
               cmp flag,0
    ;  FLAG = 0, nu este triunghi
               jne netriunghi
    ;    Returns the offset into the relevant segment of expression.
               mov dx, offset mesaj1
               jmp final
    netriunghi:
    ; OFFSET pt mesaj fals
               mov dx, offset mesaj2
    final:     
    ; DOS AFISARE (PRINT)
               mov ah,9
               int 21h
            
    ; DOS END PROGRAM
               mov ax, 4c00h
               int 21h
end start