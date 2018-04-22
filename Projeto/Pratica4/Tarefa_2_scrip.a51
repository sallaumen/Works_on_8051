ORG 0000h

temporizador EQU 0200h

inicio_dec:
	SETB P3.6
	JB P3.4, inicio_dec
	JMP inicio_clic
	
inicio_clic: 
    JNB P3.4, inicio_clic
	JMP pisca
	
fim_clic:
	SETB P3.6
	JNB P3.4, fim_clic
	JMP inicio_dec

pisca:
	CLR P3.6
	ACALL temporizador
	JNB P3.4, fim_clic
	SETB P3.6
	ACALL temporizador
	JNB P3.4, fim_clic
    JMP pisca
		
END