org 00h
;SETB EX0
;SETB IE0
ljmp main

;Interrupcoes
ORG 03h
check_sw1: jb sw1, check_sw1
clr EX0
reti

;ORG 0bh
;ljmp trata_timer
		
;Inicio P0
dado  EQU		P0
;Fim p0

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
;r1 = delay
;r2 = imprime voltas 
;r3 = imprime voltas
;r4 = imprime voltas
;r5 = guarda numero de voltas
;r6 = delay
;r7 = delay

;Inicio RAM
var1	EQU		07FH
;-------------MAIN---------------
org 0200h
main:
acall inidisp
acall msg_aguardando1
acall troca_para_L2
;acall msg_aguardando2
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
check_ast:
	setb lin3
	mov P3, #00001111b
	jnb lin4, L4_AST_check
	jmp check_ast
L4_AST_check:
	clr lin3
	mov P3, #11110100b
	jnb col1, bot_AST_Ljmp
	jmp L4_AST_check
bot_AST:
	ljmp main	
bot_A: ljmp lin_check
bot_B: ljmp lin_check
bot_C: ljmp lin_check
bot_D: ljmp lin_check
bot_0:	
	mov A, R5
	mov B, #10d
	mul AB
	add A, #0d
	mov R5,A
	mov dado, #30h
	acall dadodisp
	ljmp lin_check
bot_1:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #1d	
	mov R5,A
	mov dado, #31h
	acall dadodisp
	ljmp lin_check
bot_2:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #2d
	mov R5,A
	mov dado, #32h
	acall dadodisp
	ljmp lin_check
bot_3:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #3d
	mov R5,A
	mov dado, #33h
	acall dadodisp
	ljmp lin_check
bot_4:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #4d
	mov R5,A
	mov dado, #34h
	acall dadodisp
	ljmp lin_check
bot_5:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #5d
	mov R5,A
	mov dado, #35h
	acall dadodisp
	ljmp lin_check
bot_6:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #6d
	mov R5,A
	mov dado,#36h
	acall dadodisp
	ljmp lin_check
bot_7:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #7d
	mov R5,A
	mov dado, #37h
	acall dadodisp
	ljmp lin_check
bot_8:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #8d
	mov R5,A
	mov dado, #38h
	acall dadodisp
	ljmp lin_check
bot_9:
	mov A, R5
	mov B, #10d
	mul AB
	add A, #9d
	mov R5,A
	mov dado, #39h
	acall dadodisp
	ljmp lin_check
bot_HASH:
	cjne R5,#0d,calcula_volta
	acall msg_inv
	acall delay1seg
	ljmp main
calcula_volta:	
	mov A,R5
	jz main_ljmp ; checa se nao e zero
	mov B,#255d
	div AB
	jz printa_sent
	mov A,B
	jz printa_sent
main_ljmp:
	acall msg_inv
	acall delay1seg
	ljmp main
printa_sent:
	acall inidisp
	acall msg_sentido1
	acall troca_para_L2
	acall msg_sentido2
check_sent:
	setb lin3
	mov P3, #00001111b
	jnb lin1, L1_A_check
	jnb lin2, L2_B_check
	jmp check_sent
L1_A_check:
	clr lin3
	mov P3, #11110100b
	jnb col4, bot_A_jmp
	jmp L1_A_check
L2_B_check:
	clr lin3
	mov P3, #11110100b
	jnb col4, bot_B_jmp
	jmp L2_B_check
bot_A_jmp:
    acall delay2
	jnb col4, bot_A_jmp
	ljmp bot_A2
bot_B_jmp:
    acall delay2
	jnb col4, bot_B_jmp
	ljmp bot_B2
bot_A2:
	ljmp sentido_horario
bot_B2: 
	ljmp sentido_anti_horario
sentido_horario:
	acall inidisp    
	acall imprime_voltas
	acall msg_decrem
	mov R0,#95d
	acall passo_completo_horario
	djnz R5, sentido_horario
	jmp imprime_fim
sentido_anti_horario:
	acall inidisp
	acall imprime_voltas
	acall msg_decrem
	mov R0,#95d
	acall passo_completo_anti_horario
	djnz R5, sentido_anti_horario
	jmp imprime_fim
imprime_voltas:
mov A,R5
	mov B,#100
	div AB
	
	mov R4,A
	mov var1,B
	
	mov A,var1
	mov B,#10
	div AB
	
	mov R3,A
	mov R2,B
	
	mov A,R4
	add A,#30h
	mov R4,A
	
	mov A,R3
	add A,#30h
	mov R3,A
	
	mov A,R2
	add A,#30h
	mov R2,A
	
	mov dado, R4
	aCALL dadodisp
	acall delay2
	
	mov dado, R3
	aCALL dadodisp
	acall delay2
	
	mov dado, R2
	aCALL dadodisp
	acall delay2
	
	ret
	
imprime_fim:
	acall inidisp
	acall msg_end
	acall delay1seg
	ljmp check_ast
	
;##########################################
passo_completo_horario:
    acall delay_step_motor
    clr P2.0
    clr P2.1
    clr P2.2
    clr P2.3
    ;0001
    acall delay_step_motor
    clr P2.0
    setb P2.3
    ;0010
    acall delay_step_motor
    clr P2.3
    setb P2.2
    ;0100
    acall delay_step_motor
    clr P2.2
    setb P2.1
    ;1000
    acall delay_step_motor
    clr P2.1
    setb P2.0
	djnz R0, passo_completo_horario
    ret
passo_completo_anti_horario:
    acall delay_step_motor
    clr P2.0
    clr P2.1
    clr P2.2
    clr P2.3
    ;1000
    acall delay_step_motor
    clr P2.3
    setb P2.0
    ;0100
    acall delay_step_motor
    clr P2.0
    setb P2.1
    ;0010
    acall delay_step_motor
    clr P2.1
    setb P2.2
    ;0001
    acall delay_step_motor
    clr P2.2
    setb P2.3
    djnz R0, passo_completo_anti_horario
	ret
meio_passo_horario:
    acall delay_step_motor
    clr P2.0
    clr P2.1
    clr P2.2
    clr P2.3
    ;0001
    acall delay_step_motor
    setb P2.3
    ;0011
    acall delay_step_motor
    setb P2.2
    ;0010
    acall delay_step_motor
    CLR P2.3
    ;0110
    acall delay_step_motor
    SETB P2.1
    ;0100
    acall delay_step_motor
    CLR P2.2
    ;1100
    acall delay_step_motor
    SETB P2.0
    ;1000
    acall delay_step_motor
    CLR P2.1
    ;1001
    acall delay_step_motor
    SETB P2.3
	ret
meio_passo_anti_horario:
    acall delay_step_motor
    clr P2.0
    clr P2.1
    clr P2.2
    clr P2.3
    ;1000
    acall delay_step_motor
    SETB P2.0
    ;1100
    acall delay_step_motor
    SETB P2.1
    ;0100
    acall delay_step_motor
    CLR P2.0
    ;0110
    acall delay_step_motor
    SETB P2.2
    ;0010
    acall delay_step_motor
    CLR P2.1
    ;0011
    acall delay_step_motor
    SETB P2.3
    ;0001
    acall delay_step_motor
    CLR P2.2
    ;1001
    acall delay_step_motor
    SETB P2.0
	ret
;##########################################

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
msg_numero:
			mov  dptr, #mensagem_aguardando_L1
            mov r4, #016d
			jmp msg
			ret
msg_aguardando1:
			mov  dptr, #mensagem_aguardando_L1
            mov r4, #016d
			jmp msg
			ret
			
;msg_aguardando2:;
;			mov  dptr, #mensagem_aguardando_L2
 ;           mov r4, #016d
	;		jmp msg
	;		ret
			
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

msg_decrem:
			mov  dptr, #mensagem_decrementando
            mov r4, #016d
			jmp msg
			ret
			
msg_inv:
			mov  dptr, #mensagem_invalido
            mov r4, #016d
			jmp msg
			ret

msg_end:
			mov  dptr, #mensagem_fim
            mov r4, #016d
			jmp msg
			ret

msg_int:
			mov  dptr, #mensagem_interrupcao
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

;delay_exemplo: SETB ET0
;		MOV TMOD, #01h
;		MOV TH0, #0FFh
;		MOV TL0, #007h
;		SETB EA
;		setb delay1_var
;		SETB TR0
;wait1_exemplo:  jnb delay1_var, wait1
;		ret
		
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
			
delay_step_motor:      
	MOV R7, #255d
	MOV R6, #25d
	MOV R1, #1d
	aux_3:
		MOV R6, #25d
	aux_4:
		MOV R7, #250d
	aux_5:
		DJNZ R7, aux_5
		DJNZ R6, aux_4
		DJNZ R1, aux_3
			ret
			
delay1seg:
	MOV R7, #250d
	MOV R6, #250d
	MOV R1, #8d
	aux_2:
		MOV R6, #250d
	aux_1:
		MOV R7, #250d
	aux_0:
		DJNZ R7, aux_0
		DJNZ R6, aux_1
		DJNZ R1, aux_2
	ret
	
;org 0500h
;trata_timer:
;	jnb delay1_var, delay2_inter
;	delay1_inter:   clr ea
;					clr delay1_var
;					reti
;	delay2_inter:
;					jnb delay2_var, end_timer
;					clr ea
;					clr delay2_var
;					reti			
;	end_timer:
;			reti

org 0900h
;Mensagens com amor##########################
mensagem_aguardando_L1: DB "Digite o numero:",0
;mensagem_aguardando_L2: DB "",0	
mensagem_sentido1: DB "Sentido: A=Hor",0
mensagem_sentido2: DB "B=Ant-Hor",0
mensagem_invalido: DB "Valor invalido  ",0
mensagem_decrementando: DB " para acabar.",0 ;IE: 255 para acabar.
mensagem_FIM: DB "      FIM",0
mensagem_interrupcao: DB "INTERROMPIDO."
END