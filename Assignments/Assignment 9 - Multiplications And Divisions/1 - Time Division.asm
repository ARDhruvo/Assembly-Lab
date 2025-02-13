.MODEL SMALL
.STACK 100H

.DATA
INV DB 0AH, 0DH, 'INVALID INPUT. PLEASE ENTER DECIMAL DIGITS', 0AH, 0DH, '$'
INP DB 'ENTER SECONDS: $'
NEW DB 0AH, 0DH, '$'
HRS DB ' HOURS $'
MNS DB ' MINUTES $'
SCS DB ' SECONDS $'
DIG DW 0 
TEN DW 10
CNV DB 60
COM DB 60
MIN DW 0   
SEC DW 0

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
    
    
    START:
    
    CALL RESET
    
    LEA DX, INP
    MOV AH, 9
    INT 21H
    
    XOR DX, DX
    
    INPUT:
    MOV AH, 1
    INT 21H
    
    
    COMP:
    
    CMP AL, 0DH
    JE EVAL
    
    CMP AL, '0'
    JL INVALID
    
    CMP AL, '9'
    JG INVALID
    
    CALC:
    XOR CX, CX
    MOV CL, AL
    SUB CL, '0'
    MOV AX, TEN
    MUL BX
    ADD AX, CX
    MOV BX, AX   
    
    CMP DL, 0
    JNE INVALID
        
    JMP INPUT
    
    EVAL:
    LEA DX, NEW
    MOV AH, 9
    INT 21H
    
    HOURS:
    
    XOR DX, DX
    
    MOV AX, BX
    MOV CX, 3600
    DIV CX
    MOV MIN, DX
    XOR DX, DX
    
    DIV TEN
    MOV CX, DX
    MOV DX, AX
    ;XCHG DL, DH
    OR DL, 30H
    MOV AH, 2
    INT 21H
    MOV DX, CX
    OR DL, 30H
    INT 21H
    
    LEA DX, HRS
    MOV AH, 9
    INT 21H
    
    MINS:
    
    XOR DX, DX
    
    MOV AX, MIN
    MOV CX, 60
    DIV CX
    MOV SEC, DX
    XOR DX, DX
    
    ;MOV AX, MIN
    DIV TEN
    MOV CX, DX
    MOV DX, AX
    ;XCHG DL, DH
    OR DL, 30H
    MOV AH, 2
    INT 21H
    MOV DX, CX
    OR DL, 30H
    INT 21H
    
    LEA DX, MNS
    MOV AH, 9
    INT 21H 
    
    SECS:
    
    XOR DX, DX
    
    MOV AX, SEC
    DIV TEN
    MOV CX, DX
    MOV DX, AX
    ;XCHG DL, DH
    OR DL, 30H
    MOV AH, 2
    INT 21H
    MOV DX, CX
    OR DL, 30H
    INT 21H
    
    LEA DX, SCS
    MOV AH, 9
    INT 21H
    
    CALL EXIT
     

    
ENDP MAIN

RESET PROC
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET
ENDP RESET

EXIT PROC
    MOV AH,4CH
    INT 21H
ENDP EXIT

END MAIN
    