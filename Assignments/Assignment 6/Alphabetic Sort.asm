.MODEL SMALL
.STACK 100H

.DATA
CAP DB 'ENTER CAPITAL ALPHABET NO. '
CNT DB '1'
COL DB ': $'
RES DB 'ALPHABETICALLY SORTED: $'
INV DB 0AH, 0DH, 'INVALID INPUT'
NEW DB '', 0AH, 0DH, '$'

.CODE
MAIN PROC
    ; INITIALIZING DS
    MOV AX, @DATA
    MOV DS, AX
    
    ; INITIALIZING LOOP
    MOV CX, 2   ; 2 LOOPS FOR 2 INPUTS   
                ; LOOP ALSO DECIDES WHICH BYTE THE INPUT WILL MOVE TO
    
    INPUT:
    LEA DX, CAP
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    ; CHECKS FOR ALPHABET
    CMP AL, 'A'
    JL INVALID
    CMP AL, 'Z'
    JG INVALID    
    
    IF:
    CMP CX, 2   ; CONDITION TO CHECK WHICH BYTE THE CURRENT INPUT WILL BE ASSIGNED TO
    JE THEN
    MOV BH, AL  ; 2ND INPUT IS STORED IN BH
    JMP ENDIF
    THEN:
    MOV BL, AL  ; 1ST INPUT IS STORED IN BL
    
    ENDIF:
    LEA DX, NEW
    MOV AH, 9
    INT 21H
    
    INC CNT     ; FOR PRINTING PURPOSES
    
    LOOP INPUT
    
    ; RESULT
    RESULT:
    LEA DX, RES
    INT 21H
    CMP BH, BL
    JG NORM
    
    ; INP1 > INP2
    REV:
    XCHG BL, BH 
    
    ; INP1 < INP2
    NORM:
    MOV AH, 2
    MOV DL, BL
    INT 21H
    MOV DL, 20H ; SPACE
    INT 21H
    MOV DL, BH
    INT 21H
    JMP EXIT
        
    INVALID:    ; FOR NON CAPITAL INPUTS
    LEA DX, INV
    MOV AH, 9
    INT 21H
    JMP INPUT
    
    ; DOS EXIT
    EXIT:
    MOV AH,4CH
    INT 21H
    END MAIN