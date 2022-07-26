STACKSG	SEGMENT PARA STACK 'STAK'
		DW	20 DUP(?)
STACKSG	ENDS

DATASG	SEGMENT PARA 'DATA'
GIRIS	DW 10
CIKIS	DW ?
DATASG	ENDS

CODESG	SEGMENT PARA 'CODE'
	ASSUME SS:STACKSG, DS:DATASG, CS:CODESG
	
MAIN 	PROC FAR
		PUSH DS
		XOR AX, AX
		PUSH AX
		MOV AX, DATASG
		MOV DS, AX
	
		PUSH GIRIS
		CALL FAR PTR CONWAY
		POP AX
		MOV CIKIS, AX
		
		CALL PRINTINT					; USES AX AS THE INPUT
		
	
		RETF
MAIN 	ENDP

CONWAY  PROC FAR

		PUSH DI
		PUSH AX
		PUSH BP
		PUSH BX
		
		MOV BP, SP
		MOV DI, WORD PTR[BP+12]			;OUR INPUT VALUE IS IN ADDRESS [BP+12] OF THE STACK
		
		CMP DI, 3						; GO TO RECURSIVE PART IF THE VALUE IS LESS THAN 3
		JAE	RECURS
		
		CMP DI, 0						; IF THE VALUE IS 0 RETURN 0
		JE  BCASE1						; BASE CASE 1 IS IF N = 0
		JMP BCASE2						; BASE CASE 2 IS IF N = 1 OR 2
		
BCASE1: MOV WORD PTR[BP+12], 0
		JMP CONTINUE
		
BCASE2:	MOV WORD PTR[BP+12], 1
		JMP CONTINUE

RECURS:	MOV AX, WORD PTR[BP+12]
		SUB AX, 1
		PUSH AX
		CALL CONWAY            			 ;CALCULATING DIZI[N-1] 
		POP AX   						 ; AX = DIZI[N-1]	
		PUSH AX
		CALL CONWAY            			 ; CALCULATING   DIZI[ DIZI[N-1] ] YANI DIZI[ AX ]
		POP BX							 ;BX = DIZI[ DIZI[N-1] ]
		SUB DI,AX
		MOV AX, DI             			 ; AX = N - DIZI[ N-1 ]
		PUSH AX
		CALL CONWAY            			 ; DIZI[ N - DIZI [N-1] ]
		POP AX							 ; AX = DIZI [ N - DIZI[N-1] ]
		ADD AX, BX             			 ; TOPLAM
		MOV WORD PTR[BP+12], AX			 ; WRITE IT TO THE CORRESPONDING ADDRESS


CONTINUE:		
        POP BX
		POP BP
		POP AX
		POP DI

		
		RETF


CONWAY ENDP

PRINTINT PROC NEAR
		PUSH AX
		PUSH CX
		PUSH BX
		PUSH DX
		
		MOV CX,0				; FOR KEEPING TRACK OF THE NUMBER PUSHED INTO THE STACK
		MOV BX,10				; FOR DIVING AX BY 10 AND GETTING DX AS THE REMAINDER, 
		
L1:		MOV DX,0
		DIV BX
		ADD DL, '0'
		PUSH DX					; PUSHING EVERY DIGITS INTO THE STACK
		INC CX
		CMP AX,0
		JNZ L1
		
		MOV AH, 2

L2:		POP DX
		INT 21H					; PRINTING DIGIT BY DIGIT
		LOOP L2
		
		POP DX
		POP BX
		POP CX
		POP AX
		
		RET

PRINTINT ENDP

CODESG ENDS
	END MAIN