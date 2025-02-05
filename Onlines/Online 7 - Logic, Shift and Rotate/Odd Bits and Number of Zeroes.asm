.MODEL SMALL
.STACK 100H

.DATA
FLP DB '128 BINARY WITH FLIPPED ODD BITS: $'
NUM DB 0AH, 0DH, 'NUMBER OF 0S: $'
INV DB 0AH, 0DH, 'INVALID INPUT', 0AH, 0DH, '$'
TES DB 128
ZER DB 0H

.CODE
MAIN PROC
    ; INITIALIZING DS
    MOV AX, @DATA
    MOV DS, AX
    
    RESET:      ; CLEARING REGISTERS
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
          
    LEA DX, FLP
    MOV AH, 9
    INT 21H
          
    MOV CX, 8
    
    NEXT:
    MOV BH, 128D; CHANGE FOR OTHER VALUES   
    XOR BH, 0AAH
    
    
    MOV AH, 2
    
    RESULT:
    SHL BH, 1
    JC ONE
    JNC ZERO
    
    ZERO:
    MOV DL, '0'
    INC ZER
    JMP PRINT
    
    ONE:
    MOV DL, '1'
    
    PRINT:
    INT 21H
    
    LOOP RESULT
    
    LEA DX, NUM
    MOV AH, 9
    INT 21H
    MOV AH, 2
    MOV DL, ZER
    ADD DL, 30H
    INT 21H
    
    JMP EXIT
    
    INVALID:
    LEA DX, INV
    MOV AH, 9
    INT 21H
    JMP RESET
    
    ; DOS EXIT
    EXIT:
    MOV AH,4CH
    INT 21H
    END MAIN