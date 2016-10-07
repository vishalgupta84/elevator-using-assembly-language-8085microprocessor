CPU "8085.TBL"
HOF "INT8"

ORG 8000H

GTHEX: EQU 030EH
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
RDKBD: EQU 03BAH
CLEAR: EQU 02BEH

MVI A,8BH
OUT 43H

MVI A, 01H
STA 9000H
MVI A, 0FEH
STA 9100H

GROUND:            ;--------label for ground level ---programme starts from here
	IN 41H
	ANI 01H        ;--------check if ground level is high
	JZ END 			;if not high hlt programme by going to end
	MVI A, 01H     ;if high continue programme
	OUT 40H        ;display 
	CALL DELAY     ;call for delay 
	IN 41H         ;get the input from  node
	ANI 0FEH       ;check if ancestor is high 
	JZ GROUND      ;if not got to ground
	
ASCEND:           ;if any anmcestor is high ascend
	LDA 9000H
	ADI 0H
	RAL           ;lright shift to find which node  is high
	STA 9000H
	
	OUT 40H
	CALL DELAY
	
	LDA 9000H
	MOV B,A       ;get value from memory
	LDA 9100H
	SUB B        ;subtract with right shifted value
	STA 9100H
	
	MOV B,A
	IN 41H
	ANA B      ;check if any above one is high
	JNZ ASCEND     ;if higher index is high ascend 
LOOP1:            ;wait until node is low
	CALL DELAY
	IN 41H
	MOV B,A
	LDA 9000H
	ANA B
	JNZ LOOP1
	IN 41H
	MOV B,A
	LDA 9100H
	ANA B        ;check if higher node is high
	JNZ ASCEND   ;if yes ascend
 
DESCEND:        ;check when descending
	LDA 9000H
	MOV B,A
	LDA 9100H
	SUB B
	STA 9100H

	MOV A,B
	ADI 0H
	RAR 
	STA 9000H
	
	OUT 40H
	CALL DELAY

	LDA 9000H
	CPI 01H
	JZ GROUND

	IN 41H
	MOV B,A
	LDA 9000H
	ANA B
	JZ DESCEND
LOOP2:       ;check while index is set to low
	CALL DELAY
	IN 41H
	MOV B,A
	LDA 9000H
	ANA B
	JZ DESCEND
	JMP LOOP2
	

DELAY:
	MVI C,03H
OUTLOOP:
	LXI D,9FFFH
INLOOP:
	DCX D
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET
END: 
	MVI A,00H
	OUT 40H
	RST 5