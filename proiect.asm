; Model small = 128kb
.model small
; 80286 instruction set (procesor registru altfel crash pe vm)
; http://www.bitsavers.org/pdf/borland/turbo_assembler/Turbo_Assembler_Version_5_Quick_Reference.pdf
; Pagina 28
; Enables assembly of non-privileged (real mode) 80286 processor instructions
; and 80287 numeric coprocessor instructions .
.286

.data
    a      dw 0
    b      dw 0
    c      dw 0
    mare   dw 0
    flag   dw 0
    mesaj1 db 'a, b, c - laturi triunghi (nedreptunghic) $'
    mesaj2 db 'a, b, c - nu sunt laturi triunghi $'
    mesaj3 db 'a, b, c - laturi triunghi dreptunghic$'
    mesaj0 db 'Introdu 3 numere in ORDINE CRESCATOARE mai mari decat 0 separate prin enter$'
    eroare db 'Restartati programul. Inputul nu este VALID.$'
    ; Marime stiva = 256
.stack 100h
.code

    start:     
    ; INITIALIZARE SEGMENT DE DATE
               mov  ax, @data
               mov  ds, ax

               mov dx , offset mesaj0
               mov ah, 09h
               int 21h 

    ; POPULAM VARIABILELE (CITIRE DE LA TASTATURA)
    
    ;DOS CITIRE DE LA TASTATURA
    mov ah, 01h
    int 21h

    mov cx, 10 ; Constanta formare numar 
    mov bh, 0  ; CURATAM BH
    cmp al, 30h ; TESTAM DACA NR ESTE 0
    je invalid
    ; TODO: ADD INVALID
    sub al, 48 ; From ASCII to NR
    mov bl, al
    mov ax, a ; Mutam ce avem deja in A
    mul cx
    add ax, bx
    mov a, ax
    jmp citirePrimul

    ; ADAUGAM END PROGRAM AICI CA NU NE LASA SA SARIM MAI MULT DE
    ; Relative jump out of range by 004Eh bytes
    ; Directiva .386 ar rezolva o
    ; Dar nu am timp sa testez programul 
    invalid:
               mov dx, offset eroare
    ; DOS AFISARE (PRINT)
               mov  ah,9
               int  21h
    
    ; DOS END PROGRAM
               mov  ax, 4c00h
               int  21h

    CitirePrimul:
        mov ah, 01h
        int 21h
        cmp al, 13; CHECK PENTRU ENTER
        je citireDoi
        ; Convertire ASCII -> NR
        sub al, 48
        ; Valoarea dupa substitutie
        ; Pregatire pentru Algortim formare nr
        mov bl,al
        mov ax, a
        mul cx
        add ax, bx ; Algoritm formare nr. nr = nr*10 + cifra citita
        mov a, ax
        jmp CitirePrimul
    
    CitireDoi:
        mov ah, 01h
        int 21h
        cmp al, 13;
        je citireTrei
        sub al, 48 ; ASCII -> NR
        mov bl, al
        mov ax, b
        mul cx
        add ax, bx ; Constuire nr
        mov b, ax 
        jmp CitireDoi

    CitireTrei:
        mov ah, 01h
        int 21h
        cmp al, 13;
        je inceput
        sub al, 48 ; ASCII -> NR
        mov bl, al
        mov ax, c
        mul cx
        add ax, bx ; Constuire nr
        mov c, ax 
        jmp CitireTrei
    inceput:
    ; AX = operatii aritmetice
    ;Mov the data in memori stored in A into AX Register
               mov  ax, [a]
               add  ax, [b]
               cmp  ax, [c]
    ;  DACA A+B > C SARI CATRE SALT 1 ALTFEL FLAG
               jge  salt1
    ;    flag++
               inc  flag
    salt1:     
               mov  ax,[b]
               add  ax,[c]
               cmp  ax,[a]
    ;  DACA B+C > a SARI CATRE SALT 2
               jge  salt2
    ;    flag++
               inc  flag
    salt2:     
               mov  ax,[c]
               add  ax,[a]
               cmp  ax,[b]
    ;  DACA A+C > B SARI CATRE SALT 3
               jge  salt3
    ;    flag++
               inc  flag
    salt3:     
               cmp  flag,0
    ;  FLAG = 0, nu este triunghi
               jne  netriunghi
    ;    Returns the offset into the relevant segment of expression.
               jmp  drept
    drept:     
    ;    A^2
               mov  ax, [a]
               mul ax
               mov  [a], ax
    ;   B^2
               mov  ax, [b]
               mul ax
               mov  [b], ax
    ;  C^2
               mov  ax, [c]
               mul ax
               mov  [c], ax
            
    ; A^2 + B^2 = C^2
               mov  ax, [a]
               add  ax, [b]
               cmp  ax, [c]
            ;    pitagora adevarat
               je   estedrept
               mov  dx, offset mesaj1
               jmp  final
            ;    VERIFICARE TRIUNGHI DREPTUNGHIC
    estedrept: 
               mov  dx, offset mesaj3
               jmp  final
    netriunghi:
    ; OFFSET pt mesaj fals
               mov  dx, offset mesaj2
               jmp final
    
    final:     
    ; DOS AFISARE (PRINT)
               mov  ah,9
               int  21h
    
    ; DOS END PROGRAM
               mov  ax, 4c00h
               int  21h
end start
