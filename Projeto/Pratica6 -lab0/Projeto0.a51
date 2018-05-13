org 00h
jmp 040h

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


ORG 040h

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
			;jnb lin4, L4_C_check
			jmp lin_check
			
L1_C_check:  
            mov P3, #11110000b
			jnb col1, bot_1_Ljmp
			jnb col2, bot_2_Ljmp
			jnb col3, bot_3_Ljmp
			;jnb col4, bot_A
			jmp L1_C_check

L2_C_check:  
            mov P3, #11110000b
			jnb col1, bot_4_Ljmp
			jnb col2, bot_5_Ljmp
			jnb col3, bot_6_Ljmp
			;jnb col4, bot_B
			jmp L2_C_check
			
L3_C_check:  
            mov P3, #11110000b
			jnb col1, bot_7_Ljmp
			jnb col2, bot_8_Ljmp
			jnb col3, bot_9_Ljmp
			;jnb col4, bot_C
			jmp L3_C_check
			
L4_C_check:  
            mov P3, #11110000b
			;jnb col1, bot_ASC
			;jnb col2, bot_0
			;jnb col3, bot_HASH
			;jnb col4, bot_D
			jmp L4_C_check
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

	
bot_1:	
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_1_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_1_L2
	mov r4, #016d
	acall msg
	
	mov B, var1
	mov A, #01d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var1
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var1
 	mov a, var1
	cjne a, #11d, limpaVar1	
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var1,#0
limpaVar1:	
	ljmp lin_check
	
	
bot_2:
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_2_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_2_L2
	mov r4, #016d
	acall msg
	
	mov B, var2
	mov A, #02d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var2
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var2
	mov a, var2
	cjne a, #11d, limpaVar2	
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var2,#0
limpaVar2:	
	ljmp lin_check
bot_3:
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_3_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_3_L2
	mov r4, #016d
	acall msg
	
	mov B, var3
	mov A, #0d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var3
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var3
	mov a, var3
	cjne a, #11d, limpaVar3	
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var3,#0
limpaVar3:	
	ljmp lin_check
;bot_A:
bot_4:
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_4_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_4_L2
	mov r4, #016d
	acall msg
	
	mov B, var4
	mov A, #04d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var4
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var4
	mov a, var4
	cjne a, #11d, limpaVar4	
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var4,#0
limpaVar4:	
	ljmp lin_check

bot_5:	
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_5_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_5_L2
	mov r4, #016d
	acall msg
	
	mov B, var5
	mov A, #05d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var5
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var5
	mov a, var5
	cjne a, #11d, limpaVar5
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var5,#0
limpaVar5:	
	ljmp lin_check
	
bot_6:
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_6_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_6_L2
	mov r4, #016d
	acall msg
	
	mov B, var6
	mov A, #06d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var6
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var6
	mov a, var6
	cjne a, #11d, limpaVar6
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var6,#0
limpaVar6:	
	ljmp lin_check

bot_7:	
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_7_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_7_L2
	mov r4, #016d
	acall msg
	
	mov B, var7
	mov A, #07d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var7
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var7
	mov a, var7
	cjne a, #11d, limpaVar7
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var7,#0
limpaVar7:	
	ljmp lin_check

bot_8:
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_8_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_8_L2
	mov r4, #016d
	acall msg
	
	mov B, var8
	mov A, #08d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var8
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var8
	mov a, var8
	cjne a, #11d, limpaVar8
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var8,#0
limpaVar8:	
	ljmp lin_check

bot_9:	
	acall inidisp
	;Escreve linha 1
	mov  dptr, #msg_9_L1
    mov r4, #016d
	acall msg
	;Troca Linha
	acall troca_para_L2
	;Escreve Comeco da linha 2
	mov  dptr, #msg_9_L2
	mov r4, #016d
	acall msg
	
	mov B, var9
	mov A, #09d
	mul AB
	
	mov B,#10
	div AB
	
	mov R2, A
	mov R3, B
	
	mov A,var9
	mov B,#10
	div AB
	
	mov R0,A
	mov R1,B
	
	mov A,R0
	add A,#30h
	mov R0,A
	
	mov A,R1
	add A,#30h
	mov R1,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov dado, R0
	aCALL dadodisp
	acall delay2
	
	mov dado, R1
	aCALL dadodisp
	acall delay2
	
	mov dado, #3dh
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	inc var9
	mov a, var9
	cjne a, #11d, limpaVar9
	setb P2.1
	acall delay_longo
	clr P2.1
	mov var9,#0
limpaVar9:	
	ljmp lin_check

;bot_B:
;bot_C:
;bot_AST:
;bot_0:
;bot_HASH:
;bot_D:

        
 ;Inicializacao do display
;------------------------------------------------------------------------;
;Rotina que inicializa o display para o uso                              ;
;nao tem dados de entrada e nao devolve nada                             ;
;------------------------------------------------------------------------;
pisca_cursor:
		MOV dado,#0eh
		CALL comdisp
		call temp
		MOV dado,#0ch
		CALL comdisp
		call temp
		jmp pisca_cursor

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
			
			   
msg:			clr a
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
loop:			mov r7, #0FH
				djnz r7,$
			   djnz r6, loop
			   ret
			   
delay2:      mov r6,#0FFH
loop2:		mov r7, #0FFH
				djnz r7,$
			   djnz r6, loop2
			   ret

delay_longo:
	MOV R5, #60 ;1us
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
	
	
org 0900h
mensagem_aguardando_L1: DB "Bom dia",0
mensagem_aguardando_L2: DB "Aperte uma tecla",0	
msg_1_L1: DB "Tabuada do 1",0
msg_2_L1: DB "Tabuada do 2",0
msg_3_L1: DB "Tabuada do 3",0
msg_4_L1: DB "Tabuada do 4",0
msg_5_L1: DB "Tabuada do 5",0
msg_6_L1: DB "Tabuada do 6",0
msg_7_L1: DB "Tabuada do 7",0
msg_8_L1: DB "Tabuada do 8",0
msg_9_L1: DB "Tabuada do 9",0
msg_1_L2: DB "1x",0
msg_2_L2: DB "2x",0
msg_3_L2: DB "3x",0
msg_4_L2: DB "4x",0
msg_5_L2: DB "5x",0
msg_6_L2: DB "6x",0
msg_7_L2: DB "7x",0
msg_8_L2: DB "8x",0
msg_9_L2: DB "9x",0
END
			   
