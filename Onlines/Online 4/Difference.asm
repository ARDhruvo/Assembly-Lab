; Enter two digits whose difference is less than 10
; Display them and their difference with appropriate messages

.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'ENTER FIRST DIGIT: $'
MSG2 DB 0AH, 0DH, 'ENTER SECOND DIGIT: $'
MSG3 DB 0AH, 0DH, 'YOU ENTERED: $'
MSG4 DB 0AH, 0DH, 'DIFFERENCE: '
DIF DB ?, '$'

.CODE
MAIN PROC
    ; DS
    MOV AX, @DATA
    MOV DS, AX
    
    ; FIRST INPUT
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    ; SECOND INPUT
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BH, AL
    
    ; OUTPUT DIGITS
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    MOV DL, BL
    MOV AH, 2
    INT 21H
    MOV DL, 20H
    INT 21H
    MOV DL, BH
    INT 21H
    
    ; OUTPUT SUB
    MOV DL, BL
    SUB DL, BH
    ADD DL, 30H
    MOV DIF, DL
    MOV AH, 9
    LEA DX, MSG4
    INT 21H
    
    ; DOS EXIT
    MOV AH, 4CH
    INT 21H
    
    
    
END MAIN    