.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'ENTER FIRST DIGIT: $'
MSG2 DB 0AH, 0DH, 'ENTER SECOND DIGIT: $'
MSG3 DB 0AH, 0DH, 'SUM: '
SUM DB ?,'$'

.CODE
MAIN PROC
    ; initialize DS
    MOV AX,@DATA
    MOV DS,AX
    
    ; first input
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    ; second input.
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    
    ; output
    ADD AL, BL
    MOV SUM, AL
    SUB SUM, 30H
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    
    ;DOS exit                         
    MOV AH,4CH
    INT 21H
    END MAIN
    
    
    