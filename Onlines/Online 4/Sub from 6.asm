; Take an input thats less thn 6 and store it in memory
; Subtract the number from 6 and display it

.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'ENTER DIGIT: $'
MSG2 DB 0AH, 0DH, 'DIFFERENCE FROM 6: '
DIF DB ?, '$'

.CODE
MAIN PROC
    ; DS
    MOV AX, @DATA
    MOV DS, AX
    
    ; INPUT
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    MOV AH, 1
    INT 21H
    MOV BL, AL
    
    ; OUTPUT SUB
    MOV DL, 66H ; MOVE THE ASCII VALUE OF f. NOT 6 ITSELF
                ; THIS IS BECAUSE ASCII VALUE OF 0 IS 30H
                ; AND SO THE ANSWER WILL DIRECTLY GIVE ANSWER
                ; IN THE RANGE OF 0 TO 6
    SUB DL, BL
    MOV DIF, DL
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    
    ; DOS EXIT
    MOV AH, 4CH
    INT 21H
    
    
    
END MAIN    