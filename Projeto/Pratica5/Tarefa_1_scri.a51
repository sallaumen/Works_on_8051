en    EQU     	P2.7   ;P3.5 enable display
rs    EQU     	P2.5    ;P3.4 alterna entre comando e dado (0-comando 1-dado) 
rw	  EQU		P2.6
dado  EQU		P0
temp  EQU       0500h

ORG 00h
	    jmp inicio

       ; ORG 2003h ;int0/
		 ; reti

       ; ORG 0Bh ;timer0
       ; reti

       ; ORG 13h ;int1/
       ; reti

       ; ORG 1Bh ;timer1
       ; reti

       ; ORG 23h ;serial
       ; reti
        
ORG 33h

inicio: 
		call inidisp
        call pisca_c
        ;acall temp
		;jmp inicio
		;call escrevemsg
 		jmp $



        
 ;Inicializacao do display
;------------------------------------------------------------------------;
;Rotina que inicializa o display para o uso                              ;
;nao tem dados de entrada e nao devolve nada                             ;
;------------------------------------------------------------------------;
pisca_c:
		MOV dado,#0eh
		CALL comdisp
		call temp
		MOV dado,#0ch
		CALL comdisp
		call temp
		jmp pisca_c

inidisp:    mov dado,#38h
            CALL comdisp
			call delay2
			mov dado,#38h
            CALL comdisp
			call delay2
				MOV dado,#06h
            CALL comdisp
			   call delay2
				MOV dado,#0eh
            CALL comdisp
				call delay2
			MOV dado,#01H
			CALL comdisp
			call delay2
            RET

dadodisp:   clr  en
			clr rw
            setb rs
            setb en
            call delay
            clr  en
            ret

comdisp:    clr  en
           	clr rw
		    clr  rs
            setb en
            call delay
            clr  en
            ret



escrevemsg:	   mov  dptr, #mensagem  
escrevemsg2:	clr a
				movc  a,@a+dptr
				mov dado,a
				call dadodisp
				call delay2
				inc dptr
				clr a
				movc  a,@a+dptr
				cjne a, #00h, escrevemsg2
				
				ret

org 300h
mensagem:  DB '_', 0 


delay:      mov r0,#0FH
loop:			mov r1, #0FH
				djnz r1,$
			   djnz r0, loop
			   ret
			   
delay2:      mov r0,#0FFH
loop2:		mov r1, #0FFH
				djnz r1,$
			   djnz r0, loop2
			   ret
			   
			   
ORG 0500h

MOV R5, #8 ;1us
DEL1:
    MOV R6, #200 ;1us
    DEL2:
        MOV R7, #248 ;1us
            DEL3:
            DJNZ R7, DEL3 ;2us
            NOP                ;1us
            DJNZ R6, DEL2 ;2us 
            DJNZ R5, DEL1 ;2us
RET

END
			   
