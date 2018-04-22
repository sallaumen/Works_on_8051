ORG 0000h

temporizador EQU 0200h

pisca:
	SETB P3.6
	ACALL temporizador
	ACALL temporizador
	ACALL temporizador
	CLR P3.6
	ACALL temporizador
	JMP pisca
END