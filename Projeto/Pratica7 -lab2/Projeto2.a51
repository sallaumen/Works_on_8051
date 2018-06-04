org 00h
ljmp main

ORG 0003h 
	PUSH ACC ;salva acumulador
	PUSH PSW ;salva estado atual do programa
	MOV PSW, #08H ;muda para o banco de reg. 1
	
	MOV var2, #1d
	MOV R0, #0d
	MOV R5, #1d
	CLR P1.4
	
	POP PSW ;recupera estado ant. do prog.
	POP ACC ;recupera acumulador
	RETI
		
;Inicio P0
dado  EQU		P0
;Fim p0

;tratador_inter EQU P1.2

;Inicio P2
lin3  EQU		P2.4
rs    EQU     	P2.5    ;P3.4 alterna entre comando e dado (0-comando 1-dado) 
rw	  EQU		P2.6
en    EQU     	P2.7    ;P3.5 enable display
temp  EQU       0500h
;Fim P2

;Inicio P3
lin1  EQU		P3.0
lin2  EQU		P3.1
sw1	  EQU       P3.2
lin4  EQU		P3.3
col1  EQU		P3.4
col2  EQU		P3.5
col3  EQU		P3.6
col4  EQU		P3.7
;Fim P3

;Mapeamento motor
motor1 EQU P2.0
motor2 EQU P2.1
motor3 EQU P2.2
motor4 EQU P2.3

;Tabela Reg:
;r0 = imprime voltas
;r1 = 
;r2 = imprime voltas 
;r3 = imprime voltas
;r4 = imprime msg
;r5 = delay
;r6 = delay
;r7 = delay

;Inicio RAM
vel 	EQU		07FH
sent    EQU     07EH
var3    EQU     07DH	

;-------------MAIN---------------
org 0200h
main:
SETB EX0 ; enable interrupção externa 0
SETB IT1 ;define que a interrupção é dada por borda
setb PX0 ;prioridade máxima
setb EA
acall inidisp
acall msg_aguardando1
acall troca_para_L2
mov P3, #11111111b
clr P2.0
clr P2.1
clr P2.2
clr P2.3
mov R5,#0h ;registrador que guarda o numero de voltas

lin_check:
    setb lin3
	mov P3, #00001111b
	jnb lin1, L1_C_check
	jnb lin2, L2_C_check
	jnb lin3, L3_C_check
	jnb lin4, L4_C_check
	jmp lin_check

L1_C_check: 
	clr lin3
    mov P3, #11110100b
	jnb col1, bot_1_Ljmp
	jnb col2, bot_2_Ljmp
	jnb col3, bot_3_Ljmp
	jnb col4, bot_A_Ljmp
	jmp L1_C_check

L2_C_check: 
	clr lin3
    mov P3, #11110100b
	jnb col1, bot_4_Ljmp
	jnb col2, bot_5_Ljmp
	jnb col3, bot_6_Ljmp
	jnb col4, bot_B_Ljmp
	jmp L2_C_check

L3_C_check:  
	clr lin3
    mov P3, #11110100b
	jnb col1, bot_7_Ljmp
	jnb col2, bot_8_Ljmp
	jnb col3, bot_9_Ljmp
	jnb col4, bot_C_Ljmp
	jmp L3_C_check

L4_C_check: 
	clr lin3
    mov P3, #11110100b
	jnb col1, bot_AST_Ljmp
	jnb col2, bot_0_Ljmp
	jnb col3, bot_HASH_Ljmp
	jnb col4, bot_D_Ljmp
	jmp L4_C_check

bot_A_Ljmp:
	acall delay2
	jnb col4, bot_A_Ljmp
	ljmp bot_A

bot_B_Ljmp:
	acall delay2
	jnb col4, bot_B_Ljmp
	ljmp bot_B

bot_0_Ljmp:
    acall delay2
	jnb col2, bot_0_Ljmp
	ljmp bot_0

bot_1_Ljmp:
    acall delay2
	jnb col1, bot_1_Ljmp
	ljmp bot_1	

bot_2_Ljmp:
	acall delay2
	jnb col2, bot_2_Ljmp
	ljmp bot_2

bot_3_Ljmp:
    acall delay2
	jnb col3, bot_3_Ljmp
	ljmp bot_3

bot_4_Ljmp:
    acall delay2
	jnb col1, bot_4_Ljmp
	ljmp bot_4

bot_5_Ljmp:
    acall delay2
	jnb col2, bot_5_Ljmp
	ljmp bot_5

bot_6_Ljmp:
    acall delay2
	jnb col3, bot_6_Ljmp
	ljmp bot_6

bot_7_Ljmp:
    acall delay2
	jnb col1, bot_7_Ljmp
	ljmp bot_7

bot_8_Ljmp:
    acall delay2
	jnb col2, bot_8_Ljmp
	ljmp bot_8

bot_9_Ljmp:
    acall delay2
	jnb col3, bot_9_Ljmp
	ljmp bot_9

bot_C_Ljmp:
    acall delay2
	jnb col4, bot_C_Ljmp
	ljmp bot_C

bot_D_Ljmp:
    acall delay2
	jnb col4, bot_D_Ljmp
	ljmp bot_D

bot_AST_Ljmp:
    acall delay2
	jnb col1, bot_AST_Ljmp
	ljmp bot_AST

bot_HASH_Ljmp:
    acall delay2
	jnb col3, bot_HASH_Ljmp
	ljmp bot_HASH

bot_A: 
	
bot_B: 

bot_C: ljmp lin_check
bot_D: ljmp lin_check

bot_0:	

bot_1:

bot_2:

bot_3:

bot_4:

bot_5:

bot_6: ljmp lin_check

bot_7: ljmp lin_check

bot_8: ljmp lin_check

bot_9: ljmp lin_check

bot_HASH:

bot_AST:	

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

msg_aguardando1:
			mov  dptr, #mensagem_aguardando_L1
            mov r4, #016d
			jmp msg
			ret
			
msg_sentido1:
			mov  dptr, #mensagem_sentido1
            mov r4, #016d
			jmp msg
			ret
			
msg_sentido2:
			mov  dptr, #mensagem_sentido2
            mov r4, #016d
			jmp msg
			ret

msg_vel:
			mov  dptr, #mensagem_velocidade
            mov r4, #016d
			jmp msg
			ret

msg:	clr a
		movc  a,@a+dptr
		mov dado,a
		call dadodisp
		call delay2
		inc dptr
		clr a
		movc  a,@a+dptr
		cjne a, #00h, msg
		ret				

troca_para_L2:
	    mov dado, #0c0h
		aCALL comdisp
		acall delay2
	    ret
		
delay:      mov r6,#0FH
loop:		mov r7, #0FH
			djnz r7,$
			djnz r6, loop
			ret
			   
delay2:     mov r6,#0FFH
loop2:		mov r7, #0FFH
			djnz r7,$
			djnz r6, loop2
			ret
			

delay1seg:
	MOV R7, #250d
	MOV R6, #250d
	MOV R5, #8d
	aux_2:
		MOV R6, #250d
	aux_1:
		MOV R7, #250d
	aux_0:
		DJNZ R7, aux_0
		DJNZ R6, aux_1
		DJNZ R5, aux_2
	ret
	
org 0900h
;Mensagens com amor##########################
mensagem_aguardando_L1: DB "MOTOR PARADO",0	
mensagem_sentido1: DB "Sentido Hor",0
mensagem_sentido2: DB "Sentido Ant-Hor",0
mensagem_velocidade: DB "velocidade ",0 ;IE: 255 para acabar.
END