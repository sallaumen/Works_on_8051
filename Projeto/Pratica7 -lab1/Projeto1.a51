org 00h
ljmp main

;Interrupcoes



;Inicio P0
dado  EQU		P0
;Fim p0

;Inicio P2
rs    EQU     	P2.5    ;P3.4 alterna entre comando e dado (0-comando 1-dado) 
rw	  EQU		P2.6
en    EQU     	P2.7    ;P3.5 enable display
temp  EQU       0500h
;Fim P2

;Inicio P3
lin1  EQU		P3.0
lin2  EQU		P3.1
lin3  EQU		P3.2
lin4  EQU		P3.3
col1  EQU		P3.4
col2  EQU		P3.5
col3  EQU		P3.6
col4  EQU		P3.7
;Fim P3

;Ram interrupções define
;Enderecavel
EA     	EQU     IEN0.7
EC     	EQU     IEN0.6
ET2  	EQU     IEN0.5
ES   	EQU     IEN0.4
ET1  	EQU     IEN0.3
EX1		EQU     IEN0.2
ET0  	EQU     IEN0.1
EX0    	EQU     IEN0.0

TF1		EQU		TCON.7
TR1		EQU		TCON.6
TF0		EQU		TCON.5
TR0		EQU		TCON.4
IE1		EQU		TCON.3
IT1		EQU		TCON.2
IE0		EQU		TCON.1
IT0		EQU		TCON.0

PT2		EQU		IPL0.5
PS		EQU		IPL0.4
PT1		EQU		IPL0.3
PX1		EQU		IPL0.2
PT0		EQU		IPL0.1
PX0		EQU		IPL0.0

;NÃO Enderecavel
;IEN1_EUSB       EQU     0B7H
;IEN1_ESPI       EQU     0B3H
;IEN1_ETWI   	EQU     0B2H
;IEN1_EKB        EQU     0B1H

;TMOD_M00		EQU		089H

;Inicio RAM
var1	EQU		07FH
var2	EQU		07eH
var3	EQU		07DH
var4	EQU		07CH
var5	EQU		07BH
var6	EQU		07AH
var7	EQU		079H
var8	EQU		078H
var9	EQU		077H


;-------------MAIN---------------
main:
SETB INE0_EA ;Enable All interuptions


MOV var1, #0d
MOV var2, #0d
MOV var3, #0d
MOV var4, #0d
MOV var5, #0d
MOV var6, #0d
MOV var7, #0d
MOV var8, #0d
MOV var9, #0d

acall inidisp
;acall pede_numero_pro_usuario
acall msg_aguardando1
acall troca_para_L2
acall msg_aguardando2

mov P3, #11111111b
clr P2.1
lin_check:  
            mov P3, #00001111b
			jnb lin1, L1_C_check
			jnb lin2, L2_C_check
			jnb lin3, L3_C_check
			jnb lin4, L4_C_check
			jmp lin_check
			
L1_C_check:  
            mov P3, #11110000b
			jnb col1, bot_1_Ljmp
			jnb col2, bot_2_Ljmp
			jnb col3, bot_3_Ljmp
			jnb col4, bot_A_Ljmp
			jmp L1_C_check

L2_C_check:  
            mov P3, #11110000b
			jnb col1, bot_4_Ljmp
			jnb col2, bot_5_Ljmp
			jnb col3, bot_6_Ljmp
			jnb col4, bot_B_Ljmp
			jmp L2_C_check
			
L3_C_check:  
            mov P3, #11110000b
			jnb col1, bot_7_Ljmp
			jnb col2, bot_8_Ljmp
			jnb col3, bot_9_Ljmp
			;jnb col4, bot_C_Ljmp
			jmp L3_C_check
			
L4_C_check:  
            mov P3, #11110000b
			jnb col1, bot_AST_Ljmp
			jnb col2, bot_0_Ljmp
			jnb col3, bot_HASH_Ljmp
			;jnb col4, bot_D_Ljmp
			jmp L4_C_check

bot_0_Ljmp:
    acall delay2
	jnb col1, bot_1_Ljmp
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
bot_AST_Ljmp:
    acall delay2
	jnb col1, bot_1_Ljmp
	ljmp bot_AST
bot_HASH_Ljmp:
    acall delay2
	jnb col1, bot_1_Ljmp
	ljmp bot_HASH
bot_A_Ljmp:
    acall delay2
	jnb col1, bot_1_Ljmp
	ljmp bot_B
bot_B_Ljmp:
    acall delay2
	jnb col1, bot_1_Ljmp
	ljmp bot_A
bot_0:
bot_1:
bot_2:
bot_3:
bot_4:
bot_5:
bot_6:
bot_7:
bot_8:
bot_9:
bot_AST:
bot_HASH:
bot_A:
bot_B:

        
 ;Inicializacao do display
;------------------------------------------------------------------------;
;Rotina que inicializa o display para o uso                              ;
;nao tem dados de entrada e nao devolve nada                             ;
;------------------------------------------------------------------------;
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
			
msg_aguardando2:
			mov  dptr, #mensagem_aguardando_L2
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


delay:  ;CURTINHO
			   
delay2: ;CURTINHO_MAS_NEM_TANTO
	
org 0900h
;Mensagens cm amor
mensagem_aguardando_L1: DB "Bom Dia, Digite ",0
mensagem_aguardando_L2: DB "qtas voltas:    ",0	
mensagem_decrementando: DB " para acabar.",0 ;IE: 255 para acabar.
mensagem_FIM: DB "      FIM",0
mensagem_interrupcao: DB "INTERROMPIDO."
END
			   
