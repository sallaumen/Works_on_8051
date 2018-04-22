en    EQU     	P2.7   ;P3.5 enable display
rs    EQU     	P2.5    ;P3.4 alterna entre comando e dado (0-comando 1-dado) 
rw	  EQU		P2.6
dado  EQU		P0
temp  EQU       0500h

lin1  EQU		P3.0
lin2  EQU		P3.1
lin3  EQU		P3.2
lin4  EQU		P3.3
	
col1  EQU		P3.4
col2  EQU		P3.5
col3  EQU		P3.6
col4  EQU		P3.7

ORG 030h
call inidisp
call escrevemsg
mov P3, #11111111b

lin_func:  
            mov P3, #00001111b
			;acall debounce
			jnb lin1, col_func
			;jnb lin2, col_func
			jmp lin_func
			
col_func:  
			;acall debounce
            mov P3, #11110000b
            jnb col1, inicio
			;jmp col2, função2
			jmp col_func
loop_debounce:
            acall debounce
			jb lin1, inicio
			jmp loop_debounce

inicio: 
		call inidisp
        ;call pisca_c
        ;acall temp
		call escrevemsg2019
		;jmp 030h
		
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
			;mov dado,#3ch
            CALL comdisp
			call delay2
			mov dado,#38h
			;mov dado,#3ch
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

escrevemsg2019:	   mov  dptr, #mensagem2019  
               mov r3, #016d
			   jmp escrevemsg2

escrevemsg:	   mov  dptr, #mensagem  
               mov r3, #016d
			   ;clr r4		
			   
escrevemsg2:	clr a
				movc  a,@a+dptr
				mov dado,a
				call dadodisp
				call delay2
				inc dptr
				
				;Para testar se já chegou no fim da linha 1
				dec r3
				mov a, r3
				jz troca_linha ; se sim, vai pra linha 2
volta_esc2:		
				;Volta para a rotina normal de escrita
				
				clr a
				movc  a,@a+dptr
				
				cjne a, #00h, escrevemsg2
				ret

troca_linha:
			    mov dado, #0c0h
				CALL comdisp
				call delay2
				jmp volta_esc2
			   


org 300h
mensagem:  DB 'UTFPR 2018 Lucas Guilherme', 0 
mensagem2019:  DB 'CEFET 2019 Thiago Bispo', 0 


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

debounce:
MOV R5, #5 ;1us
DELl1:
    MOV R6, #200 ;1us
    DELl2:
        MOV R7, #248 ;1us
            DELl3:
            DJNZ R7, DELl3 ;2us
            NOP                ;1us
            DJNZ R6, DELl2 ;2us 
            DJNZ R5, DELl1 ;2us
			RET


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
			   
