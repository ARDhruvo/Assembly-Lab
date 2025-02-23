.MODEL SMALL
.STACK 100H

.DATA         
BAL DB 0AH, 0DH, 'BALANCED$'
UNB DB 0AH, 0DH, 'CANNOT BE BALANCED$'
NEW DB 0AH, 0DH , '$'

.CODE 
MAIN PROC
    ; INITIALIZING DS
    MOV AX, @DATA
    MOV DS, AX
    
    CALL RESET      ; CLEARING REGISTERS
    
    MOV AH, 1
    
    INPUT:
    INT 21H
    
    CMP AL, 0DH     ; CHECKS IF RETURN 
    JE CHECK        ; IF INP == RETURN -> CHECK()
    
    CMP AL, '{'
    JE PUSHBRACK    ; IF { PUSH FUNCTION
    
    CMP AL, '}'
    JE POPBRACK     ; IF } POP FUNCTION
    
    JMP INPUT      ; ELSE NEXT CHAR
    
    PUSHBRACK:
    PUSH AX         ; STACK.PUSH( { )
    JMP INPUT       ; NEXT CHAR
    
    POPBRACK:
    CMP SP, 100H
    JE UNBALANCED   ; IF SP == *STACK.TOP() -> UNBALANCED AS IT IS TRYING TO POP EXTRA
    POP BX          ; ELSE STACK.POP()
    JMP INPUT       ; NEXT CHAR
    
    CHECK: 
    CMP SP, 100H    
    JNE UNBALANCED  ; IF SP == *STACK.TOP() -> TOO MANY LEFT BRACKETS
    
    BALANCED:       ; ELSE EQUAL NUMBER OF BRACKETS
    LEA DX, BAL
    MOV AH, 9
    INT 21H
    JMP EXIT 
    
    UNBALANCED:
    LEA DX, UNB
    MOV AH, 9
    INT 21H 
    
    EXIT:
    MOV AH,4CH
    INT 21H
ENDP MAIN

    
RESET PROC        ; CLEARING REGISTERS
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    RET
ENDP RESET

END MAIN