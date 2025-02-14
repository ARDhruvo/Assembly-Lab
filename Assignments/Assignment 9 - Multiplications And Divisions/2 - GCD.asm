.MODEL SMALL
.STACK 100H

.DATA
INV DB 0AH, 0DH, 'INVALID INPUT', 0AH, 0DH, 'PLEASE $'
IN1 DB 'ENTER M IN THE RANGE 0 - 65535: $'
SEC DB 0AH, 0DH, '' 
IN2 DB 'ENTER N IN THE RANGE 0 - 65535: $'
RES DB 0AH, 0DH, 'GCD = $' 
M DW ?
INP DB 0            ; DETERMINES WHICH INPUT IS CURRENTLY BEING PROCESSED
TEN DW 10

.CODE
MAIN PROC
    ; INITIALIZING DS
    MOV AX, @DATA
    MOV DS, AX
             
    JMP START
    
    INVALID:
    LEA DX, INV
    MOV AH, 9
    INT 21H
    
    CMP INP, 0      ; DETERMINES WHICH INPUT HAS ERROR
    JE INV1
    
    LEA DX, IN2
    INT 21H
    JMP ENDINVIF
    
    INV1:
    LEA DX, IN1
    INT 21H
    
    ENDINVIF:
    
    CALL RESET
    
    JMP INPUT
    
    START:
    
    CALL RESET
    
    LEA DX, IN1
    MOV AH, 9
    INT 21H
    
    XOR DX, DX      ; DX NEEDS TO BE CLEARED FOR DIV AND MUL
    
    INPUT:
    MOV AH, 1
    INT 21H
        
    COMP:
    CMP AL, 0DH
    JE RETURN       ; IF INP == RETURN -> CHECK()
    
    ; CHECKING DECIMAL
    CMP AL, '0'
    JL INVALID
    
    CMP AL, '9'
    JG INVALID
    
    CALL STORE      ; STORES FULL INPUT IN BX
    
    CMP DL, 0
    JNE INVALID     ; IF INP > FFFF -> INVALID()
        
    JMP INPUT
    
    ; CHECK()
    RETURN:             
    CMP INP, 1
    JGE OUTPUT      ; IF SECOND INPUT -> OUTPUT
    
    MOV M, BX       ; SAVES FIRST INPUT IN M
    
    INC INP         ; TOGGLES TO SECOND INPUT
    LEA DX, SEC
    MOV AH, 9
    INT 21H 
    
    CALL RESET      ; CLEARS REGISTERS FOR SECOND INPUT
    
    JMP INPUT
    
    OUTPUT:
    LEA DX, RES
    MOV AH, 9
    INT 21H
    
    CALL GCD
    
    CALL EXIT
    
ENDP MAIN

RESET PROC          ; CLEARS ALL REGISTERS
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET
ENDP RESET

STORE PROC
    XOR CX, CX
    MOV CL, AL      ; MOVES THE CURRENT INPUT TO CL
    SUB CL, '0'     ; ASCII TO DECIMAL
    MOV AX, TEN
    MUL BX          ; NUM *= (10 * NUM) 
    ADD AX, CX      ; NUM += INP
    MOV BX, AX      ; BX = NUM   
    RET
ENDP STORE

GCD PROC      
    MOV AX, M       ; AX = M, BX = N, DX = R
    
    ; WHILE R != 0
    FACTOR:
    XOR DX, DX      ; DX NEEDS TO BE CLEARED FOR DIV AND MUL
    
    DIV BX          ; Q = AX, R = DX
    
    CMP DX, 0
    JE PREPRINT     ; IF R == 0 -> PRINT()
                    ; ELSE:
    MOV AX, BX      ; M = N  
    MOV BX, DX      ; N = R
    
    JMP FACTOR
    
    ; PRINT()
    PREPRINT:
    MOV AX, BX      ; N IS OUR GCD
    XOR CX, CX      ; CX NEEDS TO BE CLEARED FOR LOOP
    
    DIGIT:
    XOR DX, DX      ; DX NEEDS TO BE CLEARED FOR DIV AND MUL
    DIV TEN         ; AX = (GCD / 10)
    INC CX          ; NUMBER OF DIGITS
    PUSH DX         ; STORE THE REMAINDER IN STACK FOR PRINTING
    CMP AX, 0
    JNE DIGIT       ; IF AX = 0 -> ALL DIGITS HAVE BEEN STORED
    
    ; WHILE CX > 0
    MOV AH, 2
    PRINT:
    POP DX
    OR DL, 30H      ; DECIMAL TO ASCII
    INT 21H
    LOOP PRINT
    RET
ENDP GCD

EXIT PROC
    MOV AH,4CH
    INT 21H
ENDP EXIT

END MAIN
    