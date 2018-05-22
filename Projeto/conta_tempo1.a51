org 00h
ljmp main
;Interrupcoes
ORG 0bh
clr ea
ljmp fim
reti

main:
delay:  SETB ET0
		MOV TMOD, #01h
		MOV TH0, #00h;
		MOV TL0, #00h
		SETB EA
		;setb delay1_var
		SETB TR0
		nop
		nop
	    sjmp $
		;ret
fim:
end