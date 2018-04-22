ORG 0200h

    MOV R5, #20 ;1us

DELAY1:
    MOV R6, #200 ;1us
    DELAY2:
        MOV R7, #248 ;1us
            DELAY3:
            DJNZ R7, DELAY3 ;2us
            NOP                ;1us
            DJNZ R6, DELAY2 ;2us 
            DJNZ R5, DELAY1 ;2us

RET
END