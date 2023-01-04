
;LCD Write/Read DEFINE
;******************************************
LCDWIR	EQU	0FFE0H
LCDWDR	EQU	0FFE1H
LCDRIR	EQU	0FFE2H
LCDRDR	EQU	0FFE3H

;Variable Define
;******************************************
;(LCD VARIABLE)
INST	EQU	20H
DATA	EQU	21H
LROW	EQU	22H
LCOL	EQU	23H
NUMFONT	EQU	24H
FDPL	EQU	25H
FDPH	EQU	26H

;(KEY INTERFACE VARIABLE)
;*****************************************
VSEC	EQU	30H
VMIN	EQU	31H
VHOUR	EQU	32H
VBUF	EQU	33H

;R/W LCD INSTRUCTION DEFINE 
;******************************************
CLEAR	 EQU	01H
CUR_HOME EQU	02H
ENTRY2	 EQU	06H
DCB6	 EQU	0EH
FUN5	 EQU	38H
LINE_1	 EQU	80H
LINE_2	 EQU	0C0H

;KEY INTERFACE INSTRUCTION DEFINE
;*****************************************
DATAOUT	EQU	0FFF0H
DATAIN	EQU	0FFF1H

;KEY INTERFACE DEFINE KEY& CONSTANT
;*****************************************
REP_COUNT EQU	5
RWKEY	EQU	10H
COMMA	EQU	11H
PERIOD	EQU	12H
GO	EQU	13H
REG	EQU	14H
CD	EQU	15H
INCR	EQU	16H
ST	EQU	17H
RST	EQU	18H

;7-SEGMENT ARRAY DEFINE
;*******************************************
SEG1	EQU	0FFC1H	;SEC
SEG2	EQU	0FFC2H	;MIN
SEG3	EQU	0FFC3H  ;HOUR


;DOT MATRIX COLOR CHANGE
;******************************************
COLGREEN	EQU	0FFC5H
COLRED	EQU	0FFC6H
ROW	EQU	0FFC7H

;TIMER DEFINE
;******************************************
COUNTER	EQU	0040H
NUM1	EQU	0041H
NUM2	EQU	0042H

	ORG 	8000H


;GAME MAIN                             : CORRESPOND TO MAIN
;****************************************************************************
;****************************************************************************
INTRO:	CALL	RANDOM
INTRO1:	CALL	LCD_INIT
	CALL	LED_INIT
	CALL	DOTMATRIX_INIT
	JMP	GAME_INTRO

MAIN: 	
	CALL 	SCORE
	CALL	DOTSNAKE
MOTIONCHECK:
	MOV	A,#11100000B
	CALL	SUBKEY
	CJNE	A,#0FFH,PRESSBTN
	JMP	MAIN

;****************************************************************************

;COMMON SUBROUTIONE 
;*****************************************
DELAY: 	MOV	A,R7		;DELAY SUBROUTINE
	PUSH	A
	MOV	A,R6
	PUSH	A
	MOV	A,R5
	PUSH	A

	MOV R7, #02H
DELAY1: MOV R6, #00FH
DELAY2: MOV R5, #0A0H
DELAY3: DJNZ R5, DELAY3
	DJNZ R6, DELAY2
	DJNZ R7, DELAY1

	POP	A
	MOV	R5,A
	POP	A
	MOV	R6,A
	POP	A
	MOV	R7,A
	RET

BUTTON_DELAY: 	        	;DELAY FOR BUTTON BOUNCE
	MOV	A,R7
	PUSH	A
	MOV	A,R6
	PUSH	A
	MOV 	R7,#020H
REPEAT: 
	MOV 	R6,#0FFH 
	MOV	A,R6
	DJNZ 	R6,$
	DJNZ 	R7,REPEAT
	
	POP	A
	MOV	R6,A
	POP	A
	MOV	R7,A
	RET


;GAME SUBROUTINE
;******************************************
GAME_INTRO:			;INT MESSAGE SUBROUTINE BEFORE GAME START
	MOV	LROW,#01H
	MOV	LCOL,#02H
	CALL	CUR_MOV

	MOV	DPTR,#MESSAGE1
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	MOV	NUMFONT,#0EH
	CALL	DISFONT

	MOV	LROW,#02H
	MOV	LCOL,#02H
	CALL	CUR_MOV	

	MOV	DPTR,#MESSAGE2
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	MOV	NUMFONT,#0EH
	CALL	DISFONT
	
	CALL	FINDCODE
	CALL	BOUNCE
	CALL	TIMER_START
	MOV	R1,#00010000B
	MOV	R2,#00010000B

	CALL	FEED
	CALL	DOTSNAKE
	JMP	MAIN


PRESSBTN:			;ANALYZE BUTTON
	CALL	FINDCODE	;CHECK KEY INPUT
	MOV	R5,A		;BACK UP KEY VALUE INTO R5
	CJNE	A,#0AH,NOT_TIMERPAUSE
	CLR	TCON.TR0
NOT_TIMERPAUSE:		
	CALL	BOUNCE		;REMOVE BOUNCE
	CALL	SMOVE

	PUSH	A
	MOV	A,R1
	PUSH	A
	MOV	A,R2
	PUSH	A

	POP	A
	MOV	R2,A
	POP	A
	MOV	R1,A
	POP	A

	CLR	C
	MOV	A,R5

	JMP	GAMERESET

GAMERESET:			;IF A, RESTART GAME
	MOV	A,R5
	CLR	C
	CJNE	A,#0AH,NOTGAMERESET
	JMP	INTRO1
NOTGAMERESET:
	JMP	MAIN

SMOVE:			;SNAKE'S MOTION CORRESPOND TO KEY INPUT
	CLR	C
	MOV	A,R5
	SUBB	A,#01H
	JZ	DOWN		;DOWN FOR "1"
	MOV	A,R5
	SUBB	A,#04H
	JZ	LEFT		;LEFT FOR "4"
	MOV	A,R5	
	SUBB	A,#06H
	JZ	RIGHT		;RIGHT FOR "6"
	MOV	A,R5
	SUBB	A,#09H
	JZ	UP		;UP FOR "9"
	RET

				;SUBROUTINE FOR SNAKE'S MOTION
UP:	MOV	A,R1		
	RRC	A
	JC	SCHECK
	MOV	R1,A
	CALL	DOTSNAKE
	RET
DOWN:	MOV	A,R1
	RLC	A
	JC	SCHECK
	MOV	R1,A
	CALL	DOTSNAKE
	RET
LEFT:	MOV	A,R2
	RRC	A
	JC	SCHECK
	MOV	R2,A
	CALL	DOTSNAKE
	RET
RIGHT:	MOV	A,R2
	RLC	A
	JC	SCHECK
	MOV	R2,A
	CALL	DOTSNAKE
	RET


SCHECK: 			;CHECK WHETHER SNAKE TOUCH THE WALL OR NOT
	CALL	DOTMATRIX_INIT
	MOV	R3,#11111111B
	MOV	R4,#11111111B

	CLR	TCON.TR0
	
	MOV	LROW,#01H
	MOV	LCOL,#05H
	CALL	CUR_MOV

	MOV	DPTR,#MESSAGE4
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	MOV	NUMFONT,#09H
	CALL	DISFONT

STOP:	CALL 	DOTCOLR		
	CALL	DELAY
	CALL	DELAY
	CALL	DELAY
	CALL	DOTMATRIX_INIT
	CALL	DELAY
	CALL	DELAY
	CALL	DELAY

	MOV	A,#11100000B
	CALL	SUBKEY
	CJNE	A,#0FFH,RESTART
	JMP	STOP
RESTART:
	CALL	FINDCODE	;CHECK KEY INPUT
	MOV	R5,A
	CALL	BOUNCE		;REMOVE BOUNCE
	MOV	A,R5
	CJNE	A,#0AH,NOTGAMERESET1
	JMP	INTRO1
NOTGAMERESET1:
	JMP	STOP

FEED:				;CREATE FOOD
	MOV	A,R0
	PUSH	A
	MOV	A,R1
	PUSH	A
	MOV	A,R2
	PUSH	A

	MOV	A,TL1
	MOV	B,#3
	MUL	AB
	MOV	R0,A
	ANL	A,#00001111B
	MOV	R1,A
	MOV	A,R0
	ANL	A,#11110000B
	SWAP	A
	MOV	R2,A
	MOV	R3,#00000001B
	MOV	R4,#00000001B

SETROW:	MOV	A,R3		
	RR	A
	MOV	R3,A
	DJNZ	R1,SETROW

SETCOL:	MOV	A,R4
	RR	A
	MOV	R4,A
	DJNZ	R2,SETCOL

	POP	A
	MOV	R2,A
	POP	A
	MOV	R1,A
	POP	A
	MOV	R0,A
	RET

SCORE:	MOV	A,R1		;GET SCORE WHEN SNAKE EATS FOOD
	SUBB	A,R3
	JZ	CHECKCOL
	RET
CHECKCOL:
	MOV	A,R2
	SUBB	A,R4
	JZ	GETSCORE
	RET
GETSCORE:
	CALL	FEED
	CALL	UPSCORE
	RET

LED_INIT:     ; LED CLEAR	;INITIALIZE DUMMY LED
	MOV	A,#00H
	MOV	R0,#00H

	MOV	DPTR,#SEG1
	MOVX	@DPTR,A

	MOV	DPTR,#SEG2
	MOVX	@DPTR,A

	MOV	DPTR,#SEG3
	MOVX	@DPTR,A
	RET

UPSCORE:			;UPSCORE : INCREMENT SOCRE AT 7-SEGEMENT ARRAY
				;R0 : SAVE SCORE
	MOV	A,R0
	INC	A
	DA	A
	MOV	R0,A
	
	MOV	DPTR,#SEG1	
	MOVX	@DPTR,A
	RET

;DOTMATRIX SUBROUTINE
;**********************************************************
				;R1 : VALUE OF ROW GREEN
				;R2 : VALUE OF COLUMN GREEN
				;R3 : VALUE OF ROW RED
				;R4 : VALUE OF COLUMN RED
DOTMATRIX_INIT: 		;DOT MATRIX INTIALIZE
	PUSH	A
	MOV	A,R1
	PUSH	A
	MOV	A,R2
	PUSH	A
	MOV	A,R3
	PUSH	A
	MOV	A,R4
	PUSH	A

	MOV	R1,#00H
	MOV	R2,#00H
	MOV	R3,#00H
	MOV	R4,#00H
				
	CALL	DOTCOLG		;WRITE CURRENT VALUE INTO DOT MATRIX
	CALL	DOTCOLR
	
	POP	A
	MOV	R4,A
	POP	A
	MOV	R3,A
	POP	A
	MOV	R2,A
	POP	A
	MOV	R1,A
	POP	A
	RET

DOTSNAKE:			;PRINT SNAKE AND FOOD
	CALL	DOTMATRIX_INIT
	CALL	DOTCOLG
	CALL	DELAY
	CALL	DOTMATRIX_INIT
	CALL	DOTCOLR
	CALL	DELAY
	RET

DOTCOLG:			;DOTCOLG : WRITE VALUE OF DOT MATRIX GREEN LED
MOV	DPTR,#COLGREEN
	MOV	A,R2
	MOVX	@DPTR,A

	MOV	DPTR,#ROW
	MOV	A,R1
	MOVX	@DPTR,A
	RET

DOTCOLR:			;DOTCOLR : WRITE VALUE OF DOT MATRIX RED LED
	MOV	DPTR,#COLRED
	MOV	A,R4
	MOVX	@DPTR,A

	MOV	DPTR,#ROW
	MOV	A,R3
	MOVX	@DPTR,A
	RET

;LCD SUBROUTINES
;******************************************
LCD_INIT:			; INITIALIZE VALUE OF LCD
	MOV	INST,#FUN5
	CALL	INSTWR
	MOV	INST,#DCB6
	CALL	INSTWR
		
	MOV  	INST,#CLEAR
	CALL 	INSTWR

	MOV	INST,#ENTRY2
	CALL	INSTWR

	RET

DISFONT:			; PRINT AT LCD
	MOV	A,R5
	PUSH	A
	MOV	R5,#00H
FLOOP:	MOV	DPL,FDPL
	MOV	DPH,FDPH
	MOV	A,R5
	MOVC	A,@A+DPTR
	MOV	DATA,A

	CALL	DATAWR
	INC	R5
	MOV	A,R5
	CJNE	A,NUMFONT,FLOOP
	POP	A
	MOV	R5,A
	RET

DISFONT1:			; PRINT SEC
	MOV	A,R1
	PUSH	A
	MOV	DPL,FDPL
	MOV	DPH,FDPH
	MOV	A,R1
	MOVC	A,@A+DPTR
	MOV	DATA,A
	CALL	DATAWR
	POP	A
	MOV	R1,A
	RET

DISFONT2:			; PRINT MIN
	MOV	A,R2
	PUSH	A
	MOV	DPL,FDPL
	MOV	DPH,FDPH
	MOV	A,R2
	MOVC	A,@A+DPTR
	MOV	DATA,A
	CALL	DATAWR
	POP	A
	MOV	R2,A
	RET

CUR_MOV:			; MOVE LCD CURSOR
	MOV	A,LROW
	CJNE	A,#01H,NEXT
	MOV	A,#LINE_1
	ADD	A,LCOL
	MOV	INST,A
	CALL	INSTWR
	JMP	RET_POINT

NEXT:	CJNE	A,#02H,RET_POINT	
	MOV	A,#LINE_2
	ADD	A,LCOL
	MOV	INST,A
	CALL	INSTWR
RET_POINT: RET

INSTWR:	CALL	INSTRD
	MOV	DPTR,#LCDWIR
	MOV	A,INST
	MOVX	@DPTR,A
	RET
DATAWR:	CALL	INSTRD
	MOV	DPTR,#LCDWDR
	MOV	A,DATA
	MOVX	@DPTR,A
	RET
INSTRD:	
	MOV	DPTR,#LCDRIR
	MOVX	A,@DPTR
	JB	ACC.7,INSTRD
	RET

CLEAR_DIS:			; INITIALIZE LCD 
	MOV  	INST,#CLEAR
	CALL 	INSTWR	
	RET

;kEY_DISPLAY:			
	;MOV	DPTR,#DLED
	;MOVX	@DPTR,A
	;RET

; PRINTED MESSAGE AT LCD
MESSAGE1:	DB	'P','r','e','s','s'
		DB	' ','A','n','y',' '
		DB	'K','e','y',' ',' '

MESSAGE2:	DB	' ',' ',' ',' ','T'
		DB	'o',' ','S','t','a'
		DB	'r','t',' ',' ',' '

MESSAGE3:	DB	'0','1','2','3','4'
		DB	'5','6','7','8','9'

MESSAGE4:	DB	'G','A','M','E',' '
		DB	'O','V','E','R'

MESSAGE5:	DB	' ',' ',' ',' ',' '
		DB	' ',' ','P','A','U'
		DB	'S','E',' ',' ',' '
		DB	' ',' ',' ',' ',' '

;KEY INTERFACE SUBROUTINE
;********************************************
FINDCODE:				
	MOV	A,R0
	PUSH	A
	MOV	A,R1
	PUSH	A
	MOV	A,R2
	PUSH	A

INITIAL:
	MOV	R1,#00H			;INITIALIZE R1 THAT CONTAINS COLUMN VALUE
	MOV	A,#11101111B		;INITIALIZE DATA OUT
	SETB	C

COLSCAN:
	MOV	R0,A			;CONTAIN DATA OUT VALUE IN R0
	INC	R1			;CONTAIN COLUMN VALUE
	CALL	SUBKEY			;CHECK KEY PAD INPUT

;IF A!=OFFH, THERE IS KEY INPUT
	CJNE	A,#0FFH,RSCAN
	MOV	A,R0
	SETB	C
	RRC	A			;MOVE NEXT COLUMN
	JNC	INITIAL			;RESTART IF SCANNING ALL COLUMN FINISHED
	JMP	COLSCAN			;SCAN NEXT COLUMN

RSCAN:	MOV	R2,#00H			;INITIALIZE R2 THAT CONTAINS COLUMN VALUE
ROWSCAN:
	RRC	A			;CHECK WHICH ROW CHANGES TO 1
	JNC	MATRIX			;IF A CARRIAGE OCCURS, MOVE TO THE MATRIX LOOP
	INC	R2			;CONTAIN VALUE OF NEXT ROW
	JMP	ROWSCAN			;SCAN NEXT ROW

MATRIX:	MOV	A,R2			;CONTAIN COLUMN VALUE INTO A
	MOV	B,#05H			;KEY PAD IS MADE OF 5 COLUMN
	MUL	AB			;CONVERT 2-DIM ARRAY TO A 1-DIM ARRAY
	ADD	A,R1			;CONTAIN ACCURATE KEYSTROKE COORDINATES BY ADDING COLUMN VALUES TO A
	CALL	INDEX			;STORE VALUE OF KEY-CODE INTO A
	MOV	B,A
	POP	A
	MOV	R2,A
	POP	A
	MOV	R1,A
	POP	A
	MOV	R0,A
	MOV	A,B
	RET

SUBKEY:	MOV	DPTR,#DATAOUT		;SUBKEY : EXPORT DATA TO DATA OUT
	MOVX	@DPTR,A			;LOAD VALUE OF DATA IN
	MOV	DPTR,#DATAIN
	MOVX	A,@DPTR
	RET

INDEX:	MOVC	A,@A+PC
	RET

KEYBASE:			
	DB	ST
	DB	INCR
	DB	CD
	DB	REG
	DB	GO
	DB	0CH
	DB	0DH
	DB	0EH
	DB	0FH
	DB	COMMA
	DB	08H
	DB	09H
	DB	0AH
	DB	0BH
	DB	PERIOD
	DB	04H
	DB	05H
	DB	06H
	DB	07H
	DB	RWKEY
	DB	00H
	DB	01H
	DB	02H
	DB	03H
	DB	RST

BOUNCE:					;BOUNCE : REMOVE BOUNCE 
	CALL 	BUTTON_DELAY		;DELAY TIME
	MOV	A,#0	
	CALL	SUBKEY
	CPL	A			;A STORES 0, IF THERE IS NO PRESSED KEY
	JNZ	BOUNCE			;CHECK AGAIN IF THERE IS A PRESSED KEY

	CALL	BUTTON_DELAY		;DELAY TIME
	RET

;TIMER SUBROUTINE
;******************************************
SERVICE:  				; SUBROUTINE FOR TIMER START, PERFORMING BY INTERRUPT
  	CLR     TCON.TR0  		; TIMER STOP
  	MOV     TH0,#0E3H  
  	MOV     TL0,#014H   
  	SETB    TCON.TR0  		; TIMER START
  	DJNZ    COUNTER, RETURN 
 	MOV     COUNTER, #100 
  	CLR     C
  	JMP     TIMER

TIMER:          			; TIMER CONTROL SUBROUTINE
	PUSH	A
	MOV	A,R1
	PUSH	A
	MOV	A,R2
	PUSH	A

	MOV	R1,NUM1
	MOV	R2,NUM2
	INC	R1
	CJNE	R1,#10,SETDEC
	INC	R2
	MOV	R1,#00H
SETDEC:	CJNE	R2,#6,CALLLCD
	MOV	R2,#00H
CALLLCD:
	MOV	LROW,#02H
	MOV	LCOL,#08H
	CALL	CUR_MOV

	MOV	DPTR,#MESSAGE3
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	CALL	DISFONT2

	MOV	LROW,#02H
	MOV	LCOL,#09H
	CALL	CUR_MOV

	MOV	DPTR,#MESSAGE3
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	CALL	DISFONT1

	MOV	NUM1,R1
	MOV	NUM2,R2
	
	POP	A
	MOV	R2,A
	POP	A
	MOV	R1,A
	POP	A
RETURN: 
  	RETI

SERVICE1 :
	
	SETB	EX0
	SETB	IT0
	ORL	IE, #10000001B
	JMP     PAUSE

PAUSE:				
	PUSH	A
	MOV	A,R1
	PUSH	A
	MOV	A,R2
	PUSH	A

	CLR	C
	;MOV	A,R5

	CLR	TCON.TR0
	
	MOV	LROW,#01H
	MOV	LCOL,#00H
	CALL	CUR_MOV

	MOV	DPTR,#MESSAGE5
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	MOV	NUMFONT,#14H
	CALL	DISFONT
	
	SETB	TCON.TR0
	
	MOV	R1,NUM1
	MOV	R2,NUM2
	CALL	LCDTIMER
	CALL    DELAY

	POP	A
	MOV	R2,A
	POP	A
	MOV	R1,A
	POP	A
	JMP	MAIN

	RETI

TIMER_START: 				; TIMER START SUBROUTINE
	MOV	A,R1
	PUSH	A
	MOV	A,R2
	PUSH	A

  	MOV 	COUNTER, #100 		; 10ms X 100 = 1secS
  	MOV 	TH0,#0D8H  		; FFFF - 2710(10000) = D8EF
  	MOV     TL0,#0EFH
  	SETB    TCON.TR0  		; Timer Start
	MOV	NUM1,00H
	MOV	R1,NUM1
	MOV	NUM2,00H
	MOV	R2,NUM2
	CALL	LCDTIMER

	POP	A
	MOV	R2,A
	POP	A
	MOV	R1,A	
  	RET

LCDTIMER: 				; PRINT TIMER VALUE AT LCD
	CALL	CLEAR_DIS
	MOV	LROW,#02H
	MOV	LCOL,#08H
	CALL	CUR_MOV

	MOV	DPTR,#MESSAGE3
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	CALL	DISFONT2

	MOV	LROW,#02H
	MOV	LCOL,#09H
	CALL	CUR_MOV

	MOV	DPTR,#MESSAGE3
	MOV	FDPL,DPL
	MOV	FDPH,DPH
	CALL	DISFONT1
	RET
	

RANDOM:					;RANDOM : GENERATE RANDOM NUMBER
	MOV 	TMOD,#00000001B		;GATE =0,TIMER MODE,RUN MODE 01
	MOV	IE,#10000010B		;EA 1, ET0 1
	MOV	TH1,#00H
	MOV	TL1,#00H
	CLR	C
	SETB	TCON.TR1
	RET

	ORG	9F0BH
   	JMP  	SERVICE

	ORG 	9F03H
	JMP	SERVICE1
;**********************************************
END