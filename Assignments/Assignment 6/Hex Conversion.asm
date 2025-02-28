.MODEL SMALL
.STACK 100H

.DATA
INP DB 'PLEASE ENTER A HEX DIGIT CHARACTER (0-F): $'
AGN DB 0AH, 0DH, 'PRESS Y TO DO IT AGAIN. PRESS N TO EXIT', 0AH, 0DH, '$' 
INV DB 0AH, 0DH, 'INVALID INPUT'
NEW DB '', 0AH, 0DH, '$'

.CODE
MAIN PROC
    ; INITIALIZING DS
    MOV AX, @DATA
    MOV DS, AX
    
    INPUT:
    LEA DX, INP ; INPUT STRING
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    ; COMPARISON
    CMP BL, 'F' ; IF INP > F
    JG INVALID
    
    CMP BL, '0' ; IF INP < 0 && INP > F
    JL INVALID
    
    CMP BL, 'A' ; IF A <= INP <= F 
    JGE HEX     ; JUMPS TO CONVERSION
    
    CMP BL, '9' ; IF INP > 9 && INP < 0 && INP > F
    JG INVALID
    
    ; 0 - 9
    LEA DX, NEW ; NEW LINE PRINT
    MOV AH, 9
    INT 21H
    
    MOV DL, BL
    MOV AH, 2
    INT 21H
    
    LEA DX, NEW
    MOV AH, 9
    INT 21H
    
    JMP CHOICE  ; JUMPS TO ASKING IF YOU WANT ANOTHER CONVERSION 
    
    HEX:        ; FOR A TO F
    LEA DX, NEW ; NEW LINE PRINT
    MOV AH, 9
    INT 21H
    
    MOV DL, '1' ; ALL VALUES FROM A ARE >= 10
    MOV AH, 2
    INT 21H
    MOV DL, BL
    SUB DL, 11H
    INT 21H
    
    LEA DX, NEW ; NEW LINE PRINT
    MOV AH, 9
    INT 21H
    
    JMP CHOICE  ; JUMPS TO ASKING IF YOU WANT ANOTHER CONVERSION
    
    INVALID:    ; FOR ANY INVALID HEX INPUTS
    LEA DX, NEW
    MOV AH, 9
    INT 21H
    LEA DX, INV ; PRINTS INVALID STATEMENT
    INT 21H
    
    LEA DX, NEW ; NEW LINE PRINT
    MOV AH, 9
    INT 21H
    
    JMP INPUT   ; RETURNS BACK TO TAKING INPUT
    
    CHOICE:     ; ASKS IF YOU WANT ANOTHER CONVERSION
    LEA DX, AGN
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    CMP BL, 'N' ; FOR N
    JE EXIT
    
    LEA DX, NEW ; NEW LINE PRINT
    MOV AH, 9
    INT 21H
    
    CMP BL, 'Y' ; FOR Y
    JE INPUT
    
    LEA DX, INV
    MOV AH, 9
    INT 21H
    JMP CHOICE  ; RETURNS BACK TO ASKING IF Y/N IS NOT PICKED  
    
    ; DOS EXIT
    EXIT:
    MOV AH,4CH
    INT 21H
    END MAIN