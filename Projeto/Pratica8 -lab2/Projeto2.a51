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

;Tabela Reg:
;r0 = 
;r1 = aux1_print_255
;r2 = aux2_print_255
;r3 = aux3_print_255
;r4 = velocidade do motor de 0 a 255
;r5 = delay
;r6 = delay
;r7 = delay

;Inicio RAM
vel 	       	  EQU		07FH
sent         	  EQU     07EH
aux_disp_ram_2    EQU     07DH	
display_aux   	  EQU     07CH	

PWM_OUT EQU P2.2	; PWM output pin
PWM_FLAG EQU 0	    ; Flag to indicate high/low signal
 
org 00h
ljmp main

ORG 0003h 
	PUSH ACC ;salva acumulador
	PUSH PSW ;salva estado atual do programa
	MOV PSW, #08H ;muda para o banco de reg. 1
;-----Efeito da INT. ex0-----

;----------------------------
	POP PSW ;recupera estado ant. do prog.
	POP ACC ;recupera acumulador
	RETI

ORG 010h;Valor aleatório que quis
TIMER_0_INTERRUPT:
	JB PWM_FLAG, HIGH_DONE	; If PWM_FLAG flag is set then we just finished
							; the high section of the
LOW_DONE:			; cycle so Jump to HIGH_DONE
	SETB PWM_FLAG	; Make PWM_FLAG=1 to indicate start of high section
	SETB PWM_OUT	; Make PWM output pin High
	MOV TH0, R4		; Load high byte of timer with R7
			     	; (pulse width control value)
	CLR TF0			; Clear the Timer 0 interrupt flag
	RETI			; Return from Interrupt to where
		    		; the program came from
HIGH_DONE:
	CLR PWM_FLAG	; Make PWM_FLAG=0 to indicate start of low section
	CLR PWM_OUT		; Make PWM output pin low
	MOV A, #0FFH	; Move FFH (255) to A
	CLR C			; Clear C (the carry bit) so it does
					; not affect the subtraction
	SUBB A, R4		; Subtract R7 from A. A = 255 - R7.
	MOV TH0, A		; so the value loaded into TH0 + R7 = 255
	CLR TF0			; Clear the Timer 0 interrupt flag
	RETI			; Return from Interrupt to where
					; the program came from




;-------------MAIN---------------
org 0200h
main:
;Enable de interrupções
SETB EX0 ; enable interrupção externa 0
SETB IT1 ;define que a interrupção é dada por borda
;setb PX0 ;prioridade máxima
SETB ET0 ; Enable Timer 0 Interrupt
SETB TR0 ; Start Timer
setb EA ; enable all
;Define questões para o funcionamento do motor
acall PWM_SETUP
;Zera registradores
mov r0, #0b
mov r1, #0b
mov r2, #0b
mov r3, #0b
mov r4, #0b
mov r5, #0b
mov r6, #0b
mov r7, #0b
;------------------
acall inidisp ; Inicia display
acall msg_aguardando1 ; Printa mds de aguardando
acall troca_para_L2
acall msg_cont

;-----Checagem do teclado-----
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
;-----------------------------
;-----------Debounce----------
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
;------------------------------
bot_A: ;Acelera em rampa
		acall delay2
		;incrementar de 1 em 1, poderia ser "INC R4"
		mov a, #2d
		add a, r4
		mov r4, a
		acall atualizaPWM;
		ljmp lin_check
bot_D: ;Desacelera em rampa
		acall delay2
		;decrementar de 1 em 1, poderia ser "DEC R4"
		mov a, r4
		clr c
		subb a, #2d
		mov r4, a
		acall atualizaPWM;
		ljmp lin_check
bot_0:;Para motor
		acall inidisp
		acall msg_vel
		acall troca_para_L2
		mov r4 , #00d
		acall imprime_vel_atual;
		;acall atualizaPWM;
		ljmp lin_check
bot_1:;20% de velocidade
		acall inidisp
		acall msg_vel
		acall troca_para_L2
		mov r4 , #051d
		acall imprime_vel_atual;
		;acall atualizaPWM;
		ljmp lin_check
bot_2:;40% de velocidade
		acall inidisp
		acall msg_vel
		acall troca_para_L2
		mov r4 , #0102d
		acall imprime_vel_atual;
		;acall atualizaPWM;
		ljmp lin_check
bot_3:;60% de velocidade
		acall inidisp
		acall msg_vel
		acall troca_para_L2
		mov r4 , #0153d
		acall imprime_vel_atual;
		;acall atualizaPWM;
		ljmp lin_check
bot_4:;80% de velocidade
		acall inidisp
		acall msg_vel
		acall troca_para_L2
		mov r4 , #0204d
		acall imprime_vel_atual;
		;acall atualizaPWM;
		ljmp lin_check
bot_5:;100% de velocidade(99,9)
		acall inidisp
		acall msg_vel
		acall troca_para_L2
		mov r4 , #0255d
		acall imprime_vel_atual;
		;acall atualizaPWM;
		ljmp lin_check
bot_HASH: ;Sentido Anti Horário
		setb motor1
		clr motor2
		ljmp lin_check
bot_AST: ;Sentido Horario
		clr motor1
		setb motor2
		ljmp lin_check
;------Botoes sem utilidade-----
bot_6: ljmp lin_check
bot_7: ljmp lin_check
bot_8: ljmp lin_check
bot_9: ljmp lin_check
bot_C: ljmp lin_check
bot_B: ljmp lin_check
;-------------------------------

;---------Display---------------
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
;---------------------------------------
;-----------Funcoes do PWM--------------
;-------------e motor em geral----------
PWM_SETUP:
	;Define que o motor nao vai girar para nenhum lado
	setb P2.0 
	setb P2.1
	;------
	MOV TMOD, #00H ; Timer0 in Mode 0
	; Set pulse width control
	; The value loaded in R4 is value X as
	MOV R4, #0
	; Velocidade vai ser R4
	RET
	
AtualizaPWM:
	ret
	
imprime_vel_atual:
		mov  dptr, #mensagem_vel_atual
        mov display_aux, #016d
	    acall msg
;----Printa a velocidade----
		mov A,R4
		mov B,#100
		div AB
		mov R4,A
		mov aux_disp_ram_2,B
		mov A,aux_disp_ram_2
		mov B,#10
		div AB
		
		mov R2,A
		mov R1,B
		
		mov A,R3
		add A,#30h
		mov R3,A
		
		mov A,R2
		add A,#30h
		mov R2,A
		
		mov A,R1
		add A,#30h
		mov R1,A
		
		mov dado, R3
		aCALL dadodisp
		acall delay2
		
		mov dado, R2
		aCALL dadodisp
		acall delay2
		
		mov dado, R1
		aCALL dadodisp
		acall delay2

		mov  dptr, #mensagem_barra255
        mov display_aux, #016d
	    acall msg
		ret
;---------------------------------------
;---------Tratadores do LCD-------------
msg_aguardando1:
			mov  dptr, #mensagem_aguardando_L1
            mov display_aux, #016d
			jmp msg
			ret
			
msg_sentido1:
			mov  dptr, #mensagem_sentido1
            mov display_aux, #016d
			jmp msg
			ret
			
msg_sentido2:
			mov  dptr, #mensagem_sentido2
            mov display_aux, #016d
			jmp msg
			ret

msg_vel:
			mov  dptr, #mensagem_velocidade
            mov display_aux, #016d
			jmp msg
			ret
msg_cont:
			mov  dptr, #mensagem_continuar
            mov display_aux, #016d
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
;------------------------------------
;----------Delays--------------------
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
;------------------------------

org 0900h
;Mensagens com amor##########################
mensagem_aguardando_L1: DB "MOTOR PARADO",0
mensagem_continuar: DB "Selec Vel e Sent",0	
mensagem_sentido1: DB "Sentido Hor",0
mensagem_sentido2: DB "Sentido Ant-Hor",0
mensagem_velocidade: DB "Velocidade = ",0 ;IE: 255 para acabar.
mensagem_barra255: DB "/255",0
mensagem_vel_atual: DB "Vel = ",0
END