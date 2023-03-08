        .title   BBC BASIC (C) R.T.RUSSELL 1987
;
;BBC BASIC INTERPRETER - Z80 VERSION
;STATEMENT EXECUTION & ASSEMBLER MODULE - "EXEC"
;(C) COPYRIGHT  R.T.RUSSELL  1984
;VERSION 2.1, 22-01-1984
;VERSION 3.0, 02-03-1987
;VERSION 3.1, 11-06-1987
;
        .globl  XEQ
        .globl  RUN0
        .globl  CHAIN0
        .globl  CHECK
        .globl  MUL16
        .globl  X4OR5
        .globl  TERM?
        .globl  STORE4
        .globl  STORE5
        .globl  FILL
        .globl  FN
        .globl  USR
        .globl  ESCAPE
        .globl  SYNTAX
        .globl  CHANEL
;
        .globl   ERROR
        .globl   REPORT
        .globl   WARM
        .globl   CLOOP
        .globl   SAYLN
        .globl   LOAD0
        .globl   CRLF
        .globl   PBCDL
        .globl   TELL
        .globl   FINDL
        .globl   SETLIN
        .globl   CLEAR
        .globl   GETVAR
        .globl   PUTVAR
        .globl   GETDEF
        .globl   CREATE
        .globl   OUTCHR
        .globl   OUT
        .globl   AUTO
        .globl   DELETE
        .globl   LOAD
        .globl   LIST
        .globl   NEW
        .globl   OLD
        .globl   RENUM
        .globl   SAVE
;
        .globl   OSWRCH
        .globl   OSLINE
        .globl   OSSHUT
        .globl   OSBPUT
        .globl   OSBGET
        .globl   CLRSCN
        .globl   PUTCSR
        .globl   PUTIME
        .globl   PUTIMS
        .globl   PUTPTR
        .globl   OSCALL
        .globl   OSCLI
        .globl   TRAP
;
        .globl   SOUND
        .globl   CLG
        .globl   DRAW
        .globl   ENVEL
        .globl   GCOL
        .globl   MODE
        .globl   MOVE
        .globl   PLOT
        .globl   COLOUR
;
        .globl   STR
        .globl   HEXSTR
        .globl   EXPR
        .globl   EXPRN
        .globl   EXPRI
        .globl   EXPRS
        .globl   ITEMI
        .globl   CONS
        .globl   LOADS
        .globl   VAL0
        .globl   SFIX
        .globl   TEST
        .globl   NXT
        .globl   SWAP
        .globl   LOAD4
        .globl   LOADN
        .globl   DLOAD5
        .globl   FPP
        .globl   COMMA
        .globl   BRAKET
        .globl   PUSHS
        .globl   POPS
        .globl   ZERO
;
        .globl   ACCS
        .globl   .page
        .globl   LOMEM
        .globl   HIMEM
        .globl   FREE
        .globl   BUFFER
        .globl   ERRTRP
        .globl   ERRLIN
        .globl   COUNT
        .globl   WIDTH
        .globl   STAVAR
        .globl   DATPTR
        .globl   RANDOM
        .globl   TRACEN
        .globl   LISTON
        .globl   PC
        .globl   OC
;
TAND    =     0x80
TOR     =     0x84
TERROR  =     0x85
LINE    =     0x86
OFF     =     0x87
STEP    =     0x88
SPC     =     0x89
TAB     =     0x8A
ELSE    =     0x8B
THEN    =     0x8C
LINO    =     0x8D
TO      =     0x0B8
TCMD    =     0x0C6
TCALL   =     0x0D6
DATA    =     0x0DC
DEF     =     0x0DD
TGOSUB  =     0x0E4
TGOTO   =     0x0E5
TON     =     0x0EE
TPROC   =     0x0F2
TSTOP   =     0x0FA
;
CMDTAB: .dw    AUTO
        .dw    DELETE
        .dw    LOAD
        .dw    LIST
        .dw    NEW
        .dw    OLD
        .dw    RENUM
        .dw    SAVE
        .dw    PUT
        .dw    PTR
        .dw    PAGEV
        .dw    TIMEV
        .dw    LOMEMV
        .dw    HIMEMV
        .dw    SOUND
        .dw    BPUT
        .dw    CALL
        .dw    CHAIN
        .dw    CLR
        .dw    CLOSE
        .dw    CLG
        .dw    CLS
        .dw    REM             ;DATA
        .dw    REM             ;DEF
        .dw    DIM
        .dw    DRAW
        .dw    END
        .dw    ENDPRO
        .dw    ENVEL
        .dw    FOR
        .dw    GOSUB
        .dw    GOTO
        .dw    GCOL
        .dw    IF
        .dw    INPUT
        .dw    LET
        .dw    LOCAL
        .dw    MODE
        .dw    MOVE
        .dw    NEXT
        .dw    ON
        .dw    VDU
        .dw    PLOT
        .dw    PRINT
        .dw    PROC
        .dw    READ
        .dw    REM
        .dw    REPEAT
        .dw    REPOR
        .dw    RESTOR
        .dw    RETURN
        .dw    RUN
        .dw    STOP
        .dw    COLOUR
        .dw    TRACE
        .dw    UNTIL
        .dw    WIDTHV
        .dw    CLI             ;OSCLI
;
RUN:    CALL    TERM?
        JR      Z,RUN0
CHAIN:  CALL    EXPRS
        LD      A,CR
        LD      (DE),A
CHAIN0: LD      SP,(HIMEM)
        CALL    LOAD0
RUN0:   LD      SP,(HIMEM)      ;PREPARE FOR RUN
        LD      IX,RANDOM
		; dtrg: bugfix here; on emulators, R is always zero, and the original
		; code always waiting until it was non-zero, resulting in a hang.
		; Instead we crudely hack around it.
		ld      a, r
		jr      nz, .1
		inc     a
.1
        RLCA
        RLCA
        LD      (IX+3),A
        SBC     A,A
        LD      (IX+4),A
        CALL    CLEAR
        LD      HL,0
        LD      (ERRTRP),HL
        LD      HL,(.page)
        LD      A,DATA
        CALL    SEARCH          ;LOOK FOR "DATA"
        LD      (DATPTR),HL     ;SET DATA POINTER
        LD      IY,(.page)
XEQ0:   CALL    NEWLIN
XEQ:    LD      (ERRLIN),IY     ;ERROR POINTER
        CALL    TRAP            ;CHECK KEYBOARD
XEQ1:   CALL    NXT
        INC     IY
        CP      ":"             ;SEPARATOR
        JR      Z,XEQ1
        CP      CR
        JR      Z,XEQ0          ;NEW PROGRAM LINE
        SUB     TCMD
        JR      C,LET0          ;IMPLIED "LET"
        ADD     A,A
        LD      C,A
        LD      B,0
        LD      HL,CMDTAB
        ADD     HL,BC
        LD      A,(HL)          ;TABLE ENTRY
        INC     HL
        LD      H,(HL)
        LD      L,A
        CALL    NXT
        JP      (HL)            ;EXECUTE STATEMENT
;
;END
;
END:    CALL    SETLIN          ;FIND CURRENT LINE
        LD      A,H
        OR      L               ;DIRECT?
        JP      Z,CLOOP
        LD      E,0
        CALL    OSSHUT          ;CLOSE ALL FILES
        JP      WARM            ;"Ready"
;
NEWLIN: LD      A,(IY+0)        ;A=LINE LENGTH
        LD      BC,3
        ADD     IY,BC
        OR      A
        JR      Z,END           ;LENGTH=0, EXIT
        LD      HL,(TRACEN)
        LD      A,H
        OR      L
        RET     Z
        LD      D,(IY-1)        ;DE = LINE NUMBER
        LD      E,(IY-2)
        SBC     HL,DE
        RET     C
        EX      DE,HL
        LD      A,'['           ;TRACE
        CALL    OUTCHR
        CALL    PBCDL
        LD      A,']'
        CALL    OUTCHR
        LD      A," "
        JP      OUTCHR
;
;ROUTINES FOR 0xEAC STATEMENT:
;
;OSCLI
;
CLI:    CALL    EXPRS
        LD      A,CR
        LD      (DE),A
        LD      HL,ACCS
        CALL    OSCLI
        JR      XEQ
;
;REM, *
;
EXT:    PUSH    IY
        POP     HL
        CALL    OSCLI
REM:    PUSH    IY
        POP     HL
        LD      A,CR
        LD      B,A
        CPIR                    ;FIND LINE END
        PUSH    HL
        POP     IY
        JP      XEQ0
;
;[LET] var = expr
;
LET0:   CP      ELSE-TCMD
        JR      Z,REM
        CP      ('*'-TCMD) AND 0xFF
        JR      Z,EXT
        CP      ('='-TCMD) AND 0xFF
        JR      Z,FNEND
        CP      ('['-TCMD) AND 0xFF
        JR      Z,ASM
        DEC     IY
LET:    CALL    ASSIGN
        JP      Z,XEQ
        JR      C,SYNTAX        ;"Syntax error"
        PUSH    AF              ;SAVE STRING TYPE
        CALL    EQUALS
        PUSH    HL
        CALL    EXPRS
        POP     IX
        POP     AF
        CALL    STACCS
XEQR:   JP      XEQ
;
ASM0:   CALL    NEWLIN
ASM:    LD      (ERRLIN),IY
        CALL    TRAP
        CALL    ASSEM
        JR      C,SYNTAX
        CP      CR
        JR      Z,ASM0
        LD      HL,LISTON
        LD      A,(HL)
        AND     0x0F
        OR      0x30
        LD      (HL),A
        JR      XEQR
;
VAR:    CALL    GETVAR
        RET     Z
        JP      NC,PUTVAR
SYNTAX: LD      A,16            ;"Syntax error"
        .db    0x21
ESCAPE: LD      A,17            ;"Escape"
ERROR0: JP      ERROR
;
;=
;
FNEND:  CALL    EXPR            ;FUNCTION RESULT
        LD      B,E
        EX      DE,HL
        EXX                     ;SAVE RESULT
        EX      DE,HL           ; IN DEB'C'D'E'
FNEND5: POP     BC
        LD      HL,LOCCHK
        OR      A
        SBC     HL,BC
        JR      Z,FNEND0        ;LOCAL VARIABLE
        LD      HL,FNCHK
        OR      A
        SBC     HL,BC
        LD      A,7
        JR      NZ,ERROR0       ;"No FN"
        POP     IY
        LD      (ERRLIN),IY     ;IN CASE OF ERROR
        EX      DE,HL
        EXX
        EX      DE,HL
        LD      DE,ACCS
        LD      E,B
        EX      AF,AF'
        RET
;
FNEND0: POP     IX
        POP     BC
        LD      A,B
        OR      A
        JP      M,FNEND1        ;STRING
        POP     HL
        EXX
        POP     HL
        EXX
        CALL    STORE
        JR      FNEND5
FNEND1: LD      HL,0
        ADD     HL,SP
        PUSH    DE
        LD      E,C
        CALL    STORES
        POP     DE
        LD      SP,HL
        JR      FNEND5
;
;DIM var(dim1[,dim2[,...]])[,var(...]
;DIM var expr[,var expr...]
;
DIM:    CALL    GETVAR          ;VARIABLE
        JR      C,BADDIM
        JP      Z,DIM4
        CALL    CREATE
        PUSH    HL
        POP     IX
        LD      A,(IY)
        CP      "("
        LD      A,D
        JR      NZ,DIM4
        PUSH    HL
        PUSH    AF              ;SAVE TYPE
        LD      DE,1
        LD      B,D             ;DIMENSION COUNTER
DIM1:   INC     IY
        PUSH    BC
        PUSH    DE
        PUSH    IX
        CALL    EXPRI           ;DIMENSION SIZE
        BIT     7,H
        JR      NZ,BADDIM
        EXX
        INC     HL
        POP     IX
        INC     IX
        LD      (IX),L          ;SAVE SIZE
        INC     IX
        LD      (IX),H
        POP     BC
        CALL    MUL16           ;HL=HL*BC
        JR      C,NOROOM        ;TOO LARGE
        EX      DE,HL           ;DE=PRODUCT
        POP     BC
        INC     B               ;DIMENSION COUNTER
        LD      A,(IY)
        CP      ","             ;ANOTHER
        JR      Z,DIM1
        CALL    BRAKET          ;CLOSING BRACKET
        POP     AF              ;RESTORE TYPE
        INC     IX
        EX      (SP),IX
        LD      (IX),B          ;NO. OF DIMENSIONS
        CALL    X4OR5           ;DE=DE*n
        POP     HL
        JR      C,NOROOM
DIM3:   ADD     HL,DE
        JR      C,NOROOM
        PUSH    HL
        INC     H
        JR      Z,NOROOM
        SBC     HL,SP
        JR      NC,NOROOM       ;OUT OF SPACE
        POP     HL
        LD      (FREE),HL
DIM2:   LD      A,D
        OR      E
        JR      Z,DIM5
        DEC     HL
        LD      (HL),0          ;INITIALISE ARRAY
        DEC     DE
        JR      DIM2
DIM5:   CALL    NXT
        CP      ","             ;ANOTHER VARIABLE?
        JP      NZ,XEQ
        INC     IY
        CALL    NXT
        JR      DIM
;
BADDIM: LD      A,10            ;"Bad DIM"
        .db    0x21
NOROOM: LD      A,11            ;"DIM space"
ERROR1: JP      ERROR
;
DIM4:   OR      A
        JR      Z,BADDIM
        JP      M,BADDIM        
        LD      B,A
        LD      A,(IY-1)
        CP      ")"
        LD      A,B
        JR      Z,BADDIM
        LD      HL,(FREE)
        EXX
        LD      HL,0
        LD      C,H
        CALL    STORE           ;RESERVED AREA
        CALL    EXPRI
        EXX
        INC     HL
        EX      DE,HL
        LD      HL,(FREE)
        JR      DIM3
;
;PRINT list...
;PRINT #channel,list...
;
PRINT:  CP      "#"
        JR      NZ,PRINT0
        CALL    CHNL            ;CHANNEL NO. = E
PRNTN1: CALL    NXT
        CP      ","
        JP      NZ,XEQ
        INC     IY
        PUSH    DE
        CALL    EXPR            ;ITEM TO PRINT
        EX      AF,AF'
        JP      M,PRNTN2        ;STRING
        POP     DE
        PUSH    BC
        EXX
        LD      A,L
        EXX
        CALL    OSBPUT
        EXX
        LD      A,H
        EXX
        CALL    OSBPUT
        LD      A,L
        CALL    OSBPUT
        LD      A,H
        CALL    OSBPUT
        POP     BC
        LD      A,C
        CALL    OSBPUT
        JR      PRNTN1
PRNTN2: LD      C,E
        POP     DE
        LD      HL,ACCS
        INC     C
PRNTN3: DEC     C
        JR      Z,PRNTN4
        LD      A,(HL)
        INC     HL
        PUSH    BC
        CALL    OSBPUT
        POP     BC
        JR      PRNTN3
PRNTN4: LD      A,CR
        CALL    OSBPUT
        JR      PRNTN1
;
PRINT6: LD      B,2
        JR      PRINTC
PRINT8: LD      BC,0x100
        JR      PRINTC
PRINT9: LD      HL,STAVAR
        XOR     A
        CP      (HL)
        JR      Z,PRINT0
        LD      A,(COUNT)
        OR      A
        JR      Z,PRINT0
PRINTA: SUB     (HL)
        JR      Z,PRINT0
        JR      NC,PRINTA
        NEG
        CALL    FILL
PRINT0: LD      A,(STAVAR)
        LD      C,A             ;PRINTS
        LD      B,0             ;PRINTF
PRINTC: CALL    TERM?
        JR      Z,PRINT4
        RES     0,B
        INC     IY
        CP      "~"
        JR      Z,PRINT6
        CP      ";"
        JR      Z,PRINT8
        CP      ","
        JR      Z,PRINT9
        CALL    FORMAT          ;SPC, TAB, '
        JR      Z,PRINTC
        DEC     IY
        PUSH    BC
        CALL    EXPR            ;VARIABLE TYPE
        EX      AF,AF'
        JP      M,PRINT3        ;STRING
        POP     DE
        PUSH    DE
        BIT     1,D
        PUSH    AF
        CALL    Z,STR           ;DECIMAL
        POP     AF
        CALL    NZ,HEXSTR       ;HEX
        POP     BC
        PUSH    BC
        LD      A,C
        SUB     E
        CALL    NC,FILL         ;RIGHT JUSTIFY
PRINT3: POP     BC
        CALL    PTEXT           ;PRINT
        JR      PRINTC
PRINT4: BIT     0,B
        CALL    Z,CRLF
        JP      XEQ
;
;
ONERR:  INC     IY              ;SKIP "ERROR"
        LD      HL,0
        LD      (ERRTRP),HL
        CALL    NXT
        CP      OFF
        INC     IY
        JP      Z,XEQ
        DEC     IY
        LD      (ERRTRP),IY
        JP      REM
;
;ON expr GOTO line[,line...] [ELSE statement]
;ON expr GOTO line[,line...] [ELSE line]
;ON expr GOSUB line[,line...] [ELSE statement]
;ON expr GOSUB line[,line...] [ELSE line]
;ON expr PROCone [,PROCtwo..] [ELSE PROCotherwise]
;ON ERROR statement [:statement...]
;ON ERROR OFF
;
ON:     CP      TERROR
        JR      Z,ONERR         ;"ON ERROR"
        CALL    EXPRI
        LD      A,(IY)
        INC     IY
        LD      E,','           ;SEPARATOR
        CP      TGOTO
        JR      Z,ON1
        CP      TGOSUB
        JR      Z,ON1
        LD      E,TPROC
        CP      E
        LD      A,39
        JR      NZ,ERROR2       ;"ON syntax"
ON1:    LD      D,A
        EXX
        PUSH    HL
        EXX
        POP     BC              ;ON INDEX
        LD      A,B
        OR      H
        OR      L
        JR      NZ,ON4          ;OUT OF RANGE
        OR      C
        JR      Z,ON4
        DEC     C
        JR      Z,ON3           ;INDEX=1
ON2:    CALL    TERM?
        JR      Z,ON4           ;OUT OF RANGE
        INC     IY              ;SKIP DELIMITER
        CP      E
        JR      NZ,ON2
        DEC     C
        JR      NZ,ON2
ON3:    LD      A,E
        CP      TPROC
        JR      Z,ONPROC
        PUSH    DE
        CALL    ITEMI           ;LINE NUMBER
        POP     DE
        LD      A,D
        CP      TGOTO
        JR      Z,GOTO2
        CALL    SPAN            ;SKIP REST OF LIST
        JR      GOSUB1
;
ON4:    LD      A,(IY)
        INC     IY
        CP      ELSE
        JP      Z,IF1           ;ELSE CLAUSE
        CP      CR
        JR      NZ,ON4
        LD      A,40
ERROR2: JP      ERROR           ;"ON range"
;
ONPROC: LD      A,TON
        JP      PROC
;
;GOTO line
;
GOTO:   CALL    ITEMI           ;LINE NUMBER
GOTO1:  CALL    TERM?
        JP      NZ,SYNTAX
GOTO2:  EXX
        CALL    FINDL
        PUSH    HL
        POP     IY
        JP      Z,XEQ0
        LD      A,41
        JR      ERROR2          ;"No such line"
;
;GOSUB line
;
GOSUB:  CALL    ITEMI           ;LINE NUMBER
GOSUB1: PUSH    IY              ;TEXT POINTER
        CALL    CHECK           ;CHECK ROOM
        CALL    GOTO1           ;SAVE MARKER
GOSCHK  =     $
;
;RETURN
;
RETURN: POP     DE              ;MARKER
        LD      HL,GOSCHK
        OR      A
        SBC     HL,DE
        POP     IY
        JP      Z,XEQ
        LD      A,38
        JR      ERROR2          ;"No GOSUB"
;
;REPEAT
;
REPEAT: PUSH    IY
        CALL    CHECK
        CALL    XEQ
REPCHK  =     $
;
;UNTIL expr
;
UNTIL:  POP     BC
        PUSH    BC
        LD      HL,REPCHK
        OR      A
        SBC     HL,BC
        LD      A,43
        JR      NZ,ERROR2       ;"No REPEAT"
        CALL    EXPRI
        CALL    TEST
        POP     BC
        POP     DE
        JR      NZ,XEQ2         ;TRUE
        PUSH    DE
        PUSH    BC
        PUSH    DE
        POP     IY
XEQ2:   JP      XEQ
;
;FOR var = expr TO expr [STEP expr]
;
FORVAR: LD      A,34
        JR      ERROR2          ;"FOR variable"
;
FOR:    CALL    ASSIGN
        JR      NZ,FORVAR       ;"FOR variable"
        PUSH    AF              ;SAVE TYPE
        LD      A,(IY)
        CP      TO
        LD      A,36
        JR      NZ,ERROR2       ;"No TO"
        INC     IY
        PUSH    IX
        CALL    EXPRN           ;LIMIT
        POP     IX
        POP     AF
        LD      B,A             ;TYPE
        PUSH    BC              ;SAVE ON STACK
        PUSH    HL
        LD      HL,0
        LD      C,H
        EXX
        PUSH    HL
        LD      HL,1            ;PRESET STEP
        EXX
        LD      A,(IY)
        CP      STEP
        JR      NZ,FOR1
        INC     IY
        PUSH    IX
        CALL    EXPRN           ;STEP
        POP     IX
FOR1:   PUSH    BC
        PUSH    HL
        EXX
        PUSH    HL
        EXX
        PUSH    IY              ;SAVE TEXT POINTER
        PUSH    IX              ;LOOP VARIABLE
        CALL    CHECK
        CALL    XEQ
FORCHK  =     $
;
;NEXT [var[,var...]]
;
NEXT:   POP     BC              ;MARKER
        LD      HL,FORCHK
        OR      A
        SBC     HL,BC
        LD      A,32
        JR      NZ,ERROR3       ;"No FOR"
        CALL    TERM?
        POP     HL
        PUSH    HL
        PUSH    BC
        PUSH    HL
        CALL    NZ,GETVAR       ;VARIABLE
        POP     DE
        EX      DE,HL
        OR      A
NEXT0:  SBC     HL,DE
        JR      NZ,NEXT1
        PUSH    DE
        LD      IX,6+2
        ADD     IX,SP
        CALL    DLOAD5          ;STEP
        LD      A,(IX+11)       ;TYPE
        POP     IX
        CALL    LOADN           ;LOOP VARIABLE
        BIT     7,D             ;SIGN?
        PUSH    AF
        LD      A,'+' AND 0x0F
        CALL    FPP             ;ADD STEP
        JR      C,ERROR3
        POP     AF              ;RESTORE TYPE
        PUSH    AF
        CALL    STORE           ;UPDATE VARIABLE
        LD      IX,12+2
        ADD     IX,SP
        CALL    DLOAD5          ;LIMIT
        POP     AF
        CALL    Z,SWAP
        LD      A,0+('<'-4) AND 0x0F
        CALL    FPP             ;TEST AGAINST LIMIT
        JR      C,ERROR3
        INC     H
        JR      NZ,LOOP         ;KEEP LOOPING
        LD      HL,18
        ADD     HL,SP
        LD      SP,HL
        CALL    NXT
        CP      ","
        JP      NZ,XEQ
        INC     IY
        JR      NEXT
;
LOOP:   POP     BC
        POP     DE
        POP     IY
        PUSH    IY
        PUSH    DE
        PUSH    BC
        JP      XEQ
;
NEXT1:  LD      HL,18
        ADD     HL,SP
        LD      SP,HL           ;"POP" THE STACK
        POP     BC
        LD      HL,FORCHK
        SBC     HL,BC
        POP     HL              ;VARIABLE POINTER
        PUSH    HL
        PUSH    BC
        JR      Z,NEXT0
        LD      A,33
ERROR3: JP      ERROR           ;"Can't match FOR"
;
;FNname
;N.B. ENTERED WITH A <> TON
;
FN:     PUSH    AF              ;MAKE SPACE ON STACK
        CALL    PROC1
FNCHK   =     $
;
;PROCname
;N.B. ENTERED WITH A = ON PROC FLAG
;
PROC:   PUSH    AF              ;MAKE SPACE ON STACK
        CALL    PROC1
PROCHK  =     $
PROC1:  CALL    CHECK
        DEC     IY
        PUSH    IY
        CALL    GETDEF
        POP     BC
        JR      Z,PROC4
        LD      A,30
        JR      C,ERROR3        ;"Bad call"
        PUSH    BC
        LD      HL,(.page)
PROC2:  LD      A,DEF
        CALL    SEARCH          ;LOOK FOR "DEF"
        JR      C,PROC3
        PUSH    HL
        POP     IY
        INC     IY              ;SKIP DEF
        CALL    NXT
        CALL    GETDEF
        PUSH    IY
        POP     DE
        JR      C,PROC6
        CALL    NZ,CREATE
        PUSH    IY
        POP     DE
        LD      (HL),E
        INC     HL
        LD      (HL),D          ;SAVE ADDRESS
PROC6:  EX      DE,HL
        LD      A,CR
        LD      B,A
        CPIR                    ;SKIP TO END OF LINE
        JR      PROC2
PROC3:  POP     IY              ;RESTORE TEXT POINTER
        CALL    GETDEF
        LD      A,29
        JR      NZ,ERROR3       ;"No such FN/PROC"
PROC4:  LD      E,(HL)
        INC     HL
        LD      D,(HL)          ;GET ADDRESS
        LD      HL,2
        ADD     HL,SP
        CALL    NXT             ;ALLOW SPACE BEFORE (
        PUSH    DE              ;EXCHANGE DE,IY
        EX      (SP),IY
        POP     DE
        CP      "("             ;ARGUMENTS?
        JR      NZ,PROC5
        CALL    NXT             ;ALLOW SPACE BEFORE (
        CP      "("
        JP      NZ,SYNTAX       ;"Syntax error"
        PUSH    IY
        POP     BC              ;SAVE IY IN BC
        EXX
        CALL    SAVLOC          ;SAVE DUMMY VARIABLES
        CALL    BRAKET          ;CLOSING BRACKET
        EXX
        PUSH    BC
        POP     IY              ;RESTORE IY
        PUSH    HL
        CALL    ARGUE           ;TRANSFER ARGUMENTS
        POP     HL
PROC5:  LD      (HL),E          ;SAVE "RETURN ADDRESS"
        INC     HL
        LD      A,(HL)
        LD      (HL),D
        CP      TON             ;WAS IT "ON PROC" ?
        JP      NZ,XEQ
        PUSH    DE
        EX      (SP),IY
        CALL    SPAN            ;SKIP REST OF ON LIST
        EX      (SP),IY
        POP     DE
        LD      (HL),D
        DEC     HL
        LD      (HL),E
        JP      XEQ
;
;LOCAL var[,var...]
;
LOCAL:  POP     BC
        PUSH    BC
        LD      HL,FNCHK
        OR      A
        SBC     HL,BC
        JR      Z,LOCAL1
        LD      HL,PROCHK
        OR      A
        SBC     HL,BC
        JR      Z,LOCAL1
        LD      HL,LOCCHK
        OR      A
        SBC     HL,BC
        LD      A,12
        JP      NZ,ERROR        ;"Not LOCAL"
LOCAL1: PUSH    IY
        POP     BC
        EXX
        DEC     IY
        CALL    SAVLOC
        EXX
        PUSH    BC
        POP     IY
LOCAL2: CALL    GETVAR
        JP      NZ,SYNTAX
        OR      A               ;TYPE
        EX      AF,AF'
        CALL    ZERO
        EX      AF,AF'
        PUSH    AF
        CALL    P,STORE         ;ZERO
        POP     AF
        LD      E,C
        CALL    M,STORES
        CALL    NXT
        CP      ","
        JP      NZ,XEQ
        INC     IY
        CALL    NXT
        JR      LOCAL2
;
;ENDPROC
;
ENDPRO: POP     BC
        LD      HL,LOCCHK
        OR      A
        SBC     HL,BC
        JR      Z,UNSTK         ;LOCAL VARIABLE
        LD      HL,PROCHK       ;PROC MARKER
        OR      A
        SBC     HL,BC
        POP     IY
        JP      Z,XEQ
        LD      A,13
        JP      ERROR           ;"No PROC"
;
UNSTK:  POP     IX
        POP     BC
        LD      A,B
        OR      A
        JP      M,UNSTK1        ;STRING
        POP     HL
        EXX
        POP     HL
        EXX
        CALL    STORE
        JR      ENDPRO
UNSTK1: LD      HL,0
        ADD     HL,SP
        LD      E,C
        CALL    STORES
        LD      SP,HL
        JR      ENDPRO
;
;INPUT #channel,var,var...
;
INPUTN: CALL    CHNL            ;E = CHANNEL NUMBER
INPN1:  CALL    NXT
        CP      ","
        JP      NZ,XEQ
        INC     IY
        CALL    NXT
        PUSH    DE
        CALL    VAR
        POP     DE
        PUSH    AF              ;SAVE TYPE
        PUSH    HL              ;VARPTR
        OR      A
        JP      M,INPN2         ;STRING
        CALL    OSBGET
        EXX
        LD      L,A
        EXX
        CALL    OSBGET
        EXX
        LD      H,A
        EXX
        CALL    OSBGET
        LD      L,A
        CALL    OSBGET
        LD      H,A
        CALL    OSBGET
        LD      C,A
        POP     IX
        POP     AF              ;RESTORE TYPE
        PUSH    DE              ;SAVE CHANNEL
        CALL    STORE
        POP     DE
        JR      INPN1
INPN2:  LD      HL,ACCS
INPN3:  CALL    OSBGET
        CP      CR
        JR      Z,INPN4
        LD      (HL),A
        INC     L
        JR      NZ,INPN3
INPN4:  POP     IX
        POP     AF
        PUSH    DE
        EX      DE,HL
        CALL    STACCS
        POP     DE
        JR      INPN1
;
;INPUT ['][SPC(x)][TAB(x[,y])]["prompt",]var[,var...]
;INPUT LINE [SPC(x)][TAB(x[,y])]["prompt",]var[,var...]
;
INPUT:  CP      "#"
        JR      Z,INPUTN
        LD      C,0             ;FLAG PROMPT
        CP      LINE
        JR      NZ,INPUT0
        INC     IY              ;SKIP "LINE"
        LD      C,0x80
INPUT0: LD      HL,BUFFER
        LD      (HL),CR         ;INITIALISE EMPTY
INPUT1: CALL    TERM?
        JP      Z,XEQ           ;DONE
        INC     IY
        CP      ","
        JR      Z,INPUT3        ;SKIP COMMA
        CP      ";"
        JR      Z,INPUT3
        PUSH    HL              ;SAVE BUFFER POINTER
        CP      """
        JR      NZ,INPUT6
        PUSH    BC
        CALL    CONS
        POP     BC
        CALL    PTEXT           ;PRINT PROMPT
        JR      INPUT9
INPUT6: CALL    FORMAT          ;SPC, TAB, '
        JR      NZ,INPUT2
INPUT9: POP     HL
        SET     0,C             ;FLAG NO PROMPT
        JR      INPUT0
INPUT2: DEC     IY
        PUSH    BC
        CALL    VAR
        POP     BC
        POP     HL
        PUSH    AF              ;SAVE TYPE
        LD      A,(HL)
        INC     HL
        CP      CR              ;BUFFER EMPTY?
        CALL    Z,REFILL
        BIT     7,C
        PUSH    AF
        CALL    NZ,LINES
        POP     AF
        CALL    Z,FETCHS
        POP     AF              ;RESTORE TYPE
        PUSH    BC
        PUSH    HL
        OR      A
        JP      M,INPUT4        ;STRING
        PUSH    AF
        PUSH    IX
        CALL    VAL0
        POP     IX
        POP     AF
        CALL    STORE
        JR      INPUT5
INPUT4: CALL    STACCS
INPUT5: POP     HL
        POP     BC
INPUT3: RES     0,C
        JR      INPUT1
;
REFILL: BIT     0,C
        JR      NZ,REFIL0       ;NO PROMPT
        LD      A,'?'
        CALL    OUTCHR          ;PROMPT
        LD      A," "
        CALL    OUTCHR
REFIL0: LD      HL,BUFFER
        PUSH    BC
        PUSH    HL
        PUSH    IX
        CALL    OSLINE
        POP     IX
        POP     HL
        POP     BC
        LD      B,A             ;POS AT ENTRY
        XOR     A
        LD      (COUNT),A
        CP      B
        RET     Z
REFIL1: LD      A,(HL)
        CP      CR
        RET     Z
        INC     HL
        DJNZ    REFIL1
        RET
;
;READ var[,var...]
;
READ:   CP      "#"
        JP      Z,INPUTN
        LD      HL,(DATPTR)
READ0:  LD      A,(HL)
        INC     HL              ;SKIP COMMA OR "DATA"
        CP      CR              ;END OF DATA STMT?
        CALL    Z,GETDAT
        PUSH    HL
        CALL    VAR
        POP     HL
        OR      A
        JP      M,READ1         ;STRING
        PUSH    HL
        EX      (SP),IY
        PUSH    AF              ;SAVE TYPE
        PUSH    IX
        CALL    EXPRN
        POP     IX
        POP     AF
        CALL    STORE
        EX      (SP),IY
        JR      READ2
READ1:  CALL    FETCHS
        PUSH    HL
        CALL    STACCS
READ2:  POP     HL
        LD      (DATPTR),HL
        CALL    NXT
        CP      ","
        JP      NZ,XEQ
        INC     IY
        CALL    NXT
        JR      READ0
;
GETDAT: LD      A,DATA
        CALL    SEARCH
        INC     HL
        RET     NC
        LD      A,42
ERROR4: JP      ERROR           ;"Out of DATA"
;
;IF expr statement
;IF expr THEN statement [ELSE statement]
;IF expr THEN line [ELSE line]
;
IF:     CALL    EXPRI
        CALL    TEST
        JR      Z,IFNOT         ;FALSE
        LD      A,(IY)
        CP      THEN
        JP      NZ,XEQ
        INC     IY              ;SKIP "THEN"
IF1:    CALL    NXT
        CP      LINO
        JP      NZ,XEQ          ;STATEMENT FOLLOWS
        JP      GOTO            ;LINE NO. FOLLOWS
IFNOT:  LD      A,(IY)
        CP      CR
        INC     IY
        JP      Z,XEQ0          ;END OF LINE
        CP      ELSE
        JR      NZ,IFNOT
        JR      IF1
;
;CLS
;
CLS:    CALL    CLRSCN
        XOR     A
        LD      (COUNT),A
        JP      XEQ
;
;STOP
;
STOP:   CALL    TELL
        .db    CR
        .db    LF
        .db    TSTOP
        .db    0
        CALL    SETLIN          ;FIND CURRENT LINE
        CALL    SAYLN
        CALL    CRLF
        JP      CLOOP
;
;REPORT
;
REPOR:  CALL    REPORT
        JP      XEQ
;
;CLEAR
;
CLR:    CALL    CLEAR
        LD      HL,(.page)
        JR      RESTR1
;
;RESTORE [line]
;
RESTOR: LD      HL,(.page)
        CALL    TERM?
        JR      Z,RESTR1
        CALL    ITEMI
        EXX
        CALL    FINDL           ;SEARCH FOR LINE
        LD      A,41
        JR      NZ,ERROR4       ;"No such line"
RESTR1: LD      A,DATA
        CALL    SEARCH
        LD      (DATPTR),HL
        JP      XEQ
;
;PTR#channel=expr
;.page=expr
;TIME=expr
;LOMEM=expr
;HIMEM=expr
;
PTR:    CALL    CHANEL
        CALL    EQUALS
        LD      A,E
        PUSH    AF
        CALL    EXPRI
        PUSH    HL
        EXX
        POP     DE
        POP     AF
        CALL    PUTPTR
        JP      XEQ
;
PAGEV:  CALL    EQUALS
        CALL    EXPRI
        EXX
        LD      L,0
        LD      (.page),HL
        JP      XEQ
;
TIMEV:  CP      "$"
        JR      Z,TIMEVS
        CALL    EQUALS
        CALL    EXPRI
        PUSH    HL
        EXX
        POP     DE
        CALL    PUTIME
        JP      XEQ
;
TIMEVS: INC     IY              ;SKIP "$"
        CALL    EQUALS
        CALL    EXPRS
        CALL    PUTIMS
        JP      XEQ
;
LOMEMV: CALL    EQUALS
        CALL    EXPRI
        CALL    CLEAR
        EXX
        LD      (LOMEM),HL
        LD      (FREE),HL
        JP      XEQ
;
HIMEMV: CALL    EQUALS
        CALL    EXPRI
        EXX
        LD      DE,(FREE)
        INC     D
        XOR     A
        SBC     HL,DE
        ADD     HL,DE
        JP      C,ERROR         ;"No room"
        LD      DE,(HIMEM)
        LD      (HIMEM),HL
        EX      DE,HL
        SBC     HL,SP
        JP      NZ,XEQ
        EX      DE,HL
        LD      SP,HL           ;LOAD STACK POINTER
        JP      XEQ
;
;WIDTH expr
;
WIDTHV: CALL    EXPRI
        EXX
        LD      A,L
        LD      (WIDTH),A
        JP      XEQ
;
;TRACE ON
;TRACE OFF
;TRACE line
;
TRACE:  INC     IY
        LD      HL,0
        CP      TON
        JR      Z,TRACE0
        CP      OFF
        JR      Z,TRACE1
        DEC     IY
        CALL    EXPRI
        EXX
TRACE0: DEC     HL
TRACE1: LD      (TRACEN),HL
        JP      XEQ
;
;VDU expr,expr;....
;
VDU:    CALL    EXPRI
        EXX
        LD      A,L
        CALL    OSWRCH
        LD      A,(IY)
        CP      ","
        JR      Z,VDU2
        CP      ";"
        JR      NZ,VDU3
        LD      A,H
        CALL    OSWRCH
VDU2:   INC     IY
VDU3:   CALL    TERM?
        JR      NZ,VDU
        JP      XEQ
;
;CLOSE channel number
;
CLOSE:  CALL    CHANEL
        CALL    OSSHUT
        JP      XEQ
;
;BPUT channel,byte
;
BPUT:   CALL    CHANEL          ;CHANNEL NUMBER
        PUSH    DE
        CALL    COMMA
        CALL    EXPRI           ;BYTE
        EXX
        LD      A,L
        POP     DE
        CALL    OSBPUT
        JP      XEQ
;
;CALL address[,var[,var...]]
;
CALL:   CALL    EXPRI           ;ADDRESS
        EXX
        PUSH    HL              ;SAVE IT
        LD      B,0             ;PARAMETER COUNTER
        LD      DE,BUFFER       ;VECTOR
CALL1:  CALL    NXT
        CP      ","
        JR      NZ,CALL2
        INC     IY
        INC     B
        CALL    NXT
        PUSH    BC
        PUSH    DE
        CALL    VAR
        POP     DE
        POP     BC
        INC     DE
        LD      (DE),A          ;PARAMETER TYPE
        INC     DE
        EX      DE,HL
        LD      (HL),E          ;PARAMETER ADDRESS
        INC     HL
        LD      (HL),D
        EX      DE,HL
        JR      CALL1
CALL2:  LD      A,B
        LD      (BUFFER),A      ;PARAMETER COUNT
        POP     HL              ;RESTORE ADDRESS
        CALL    USR1
        JP      XEQ
;
;USR(address)
;
USR:    CALL    ITEMI
        EXX
USR1:   PUSH    HL              ;ADDRESS ON STACK
        EX      (SP),IY
        INC     H               ;.page &FF?
        LD      HL,USR2         ;RETURN ADDRESS
        PUSH    HL
        LD      IX,STAVAR
        CALL    Z,OSCALL        ;INTERCEPT .page &FF
        LD      C,(IX+24)
        PUSH    BC
        POP     AF              ;LOAD FLAGS
        LD      A,(IX+4)        ;LOAD Z80 REGISTERS
        LD      B,(IX+8)
        LD      C,(IX+12)
        LD      D,(IX+16)
        LD      E,(IX+20)
        LD      H,(IX+32)
        LD      L,(IX+48)
        LD      IX,BUFFER
        JP      (IY)            ;OFF TO USER ROUTINE
USR2:   POP     IY
        XOR     A
        LD      C,A
        RET
;
;PUT port,data
;
PUT:    CALL    EXPRI           ;PORT ADDRESS
        EXX
        PUSH    HL
        CALL    COMMA
        CALL    EXPRI           ;DATA
        EXX
        POP     BC
        OUT     (C),L           ;OUTPUT TO PORT BC
        JP      XEQ
        .page
;
;SUBROUTINES:
;
;ASSIGN - Assign a numeric value to a variable.
;Outputs: NC,  Z - OK, numeric.
;         NC, NZ - OK, string.
;          C, NZ - illegal
;
ASSIGN: CALL    GETVAR          ;VARIABLE
        RET     C               ;ILLEGAL VARIABLE
        CALL    NZ,PUTVAR
        OR      A
        RET     M               ;STRING VARIABLE
        PUSH    AF              ;NUMERIC TYPE
        CALL    EQUALS
        PUSH    HL
        CALL    EXPRN
        POP     IX
        POP     AF
STORE:  BIT     0,A
        JR      Z,STOREI
        CP      A               ;SET ZERO
STORE5: LD      (IX+4),C
STORE4: EXX
        LD      (IX+0),L
        LD      (IX+1),H
        EXX
        LD      (IX+2),L
        LD      (IX+3),H
        RET
STOREI: PUSH    AF
        INC     C               ;SPEED - & PRESERVE F'
        DEC     C               ; WHEN CALLED BY FNEND0
        CALL    NZ,SFIX         ;CONVERT TO INTEGER
        POP     AF
        CP      4
        JR      Z,STORE4
        CP      A               ;SET ZERO
STORE1: EXX
        LD      (IX+0),L
        EXX
        RET
;
STACCS: LD      HL,ACCS
STORES: RRA
        JR      NC,STORS3       ;FIXED STRING
        PUSH    HL
        CALL    LOAD4
        LD      A,E             ;LENGTH OF STRING
        EXX
        LD      L,A
        LD      A,H             ;LENGTH ALLOCATED
        EXX
        CP      E
        JR      NC,STORS1       ;ENOUGH ROOM
        EXX
        LD      H,L
        EXX
        PUSH    HL
        LD      B,0
        LD      C,A
        ADD     HL,BC
        LD      BC,(FREE)
        SBC     HL,BC           ;IS STRING LAST?
        POP     HL
        SCF
        JR      Z,STORS1
        LD      H,B
        LD      L,C
STORS1: CALL    STORE4          ;PRESERVES CARRY!
        LD      B,0
        LD      C,E
        EX      DE,HL
        POP     HL
        DEC     C
        INC     C
        RET     Z               ;NULL STRING
        LDIR
        RET     NC              ;STRING REPLACED
        LD      (FREE),DE
CHECK:  PUSH    HL
        LD      HL,(FREE)
        INC     H
        SBC     HL,SP
        POP     HL
        RET     C
        XOR     A
        JP      ERROR           ;"No room"
;
STORS3: LD      C,E
        PUSH    IX
        POP     DE
        XOR     A
        LD      B,A
        CP      C
        JR      Z,STORS5
        LDIR
STORS5: LD      A,CR
        LD      (DE),A
        RET
;
;ARGUE: TRANSFER FN OR PROC ARGUMENTS FROM THE
; CALLING STATEMENT TO THE DUMMY VARIABLES VIA
; THE STACK.  IT MUST BE DONE THIS WAY TO MAKE
; PROCFRED(A,B)    DEF PROCFRED(B,A)     WORK.
;   Inputs: DE addresses parameter list 
;           IY addresses dummy variable list
;  Outputs: DE,IY updated
; Destroys: Everything
;
ARGUE:  LD      A,-1
        PUSH    AF              ;PUT MARKER ON STACK
ARGUE1: INC     IY              ;BUMP PAST ( OR ,
        INC     DE
        PUSH    DE
        CALL    NXT
        CALL    GETVAR
        JR      C,ARGERR
        CALL    NZ,PUTVAR
        POP     DE
        PUSH    HL              ;VARPTR
        OR      A               ;TYPE
        PUSH    AF
        PUSH    DE
        EX      (SP),IY
        JP      M,ARGUE2        ;STRING
        CALL    EXPRN           ;PARAMETER VALUE
        EX      (SP),IY
        POP     DE
        POP     AF
        EXX
        PUSH    HL
        EXX
        PUSH    HL
        LD      B,A
        PUSH    BC
        CALL    CHECK           ;CHECK ROOM
        JR      ARGUE4
ARGUE2: CALL    EXPRS
        EX      (SP),IY
        EXX
        POP     DE
        EXX
        POP     AF
        CALL    PUSHS
        EXX
ARGUE4: CALL    NXT
        CP      ","
        JR      NZ,ARGUE5
        LD      A,(DE)
        CP      ","
        JR      Z,ARGUE1        ;ANOTHER
ARGERR: LD      A,31
        JP      ERROR           ;"Arguments"
ARGUE5: CALL    BRAKET
        LD      A,(DE)
        CP      ")"
        JR      NZ,ARGERR
        INC     DE
        EXX
ARGUE6: POP     BC
        LD      A,B
        INC     A
        EXX
        RET     Z               ;MARKER POPPED
        EXX
        DEC     A
        JP      M,ARGUE7        ;STRING
        POP     HL
        EXX
        POP     HL
        EXX
        POP     IX
        CALL    STORE           ;WRITE TO DUMMY
        JR      ARGUE6
ARGUE7: CALL    POPS
        POP     IX
        CALL    STACCS
        JR      ARGUE6
;
;SAVLOC: SUBROUTINE TO STACK LOCAL PARAMETERS
;  OF A FUNCTION OR PROCEDURE.
;THERE IS A LOT OF STACK MANIPULATION - CARE!!
;   Inputs: IY is parameters pointer
;  Outputs: IY updated
; Destroys: A,B,C,D,E,H,L,IX,IY,F,SP
;
SAVLOC: POP     DE              ;RETURN ADDRESS
SAVLO1: INC     IY              ;BUMP PAST ( OR ,
        CALL    NXT
        PUSH    DE
        EXX
        PUSH    BC
        PUSH    DE
        PUSH    HL
        EXX
        CALL    VAR             ;DUMMY VARIABLE
        EXX
        POP     HL
        POP     DE
        POP     BC
        EXX
        POP     DE
        OR      A               ;TYPE
        JP      M,SAVLO2        ;STRING
        EXX
        PUSH    HL              ;SAVE H'L'
        EXX
        LD      B,A             ;TYPE
        CALL    LOADN
        EXX
        EX      (SP),HL
        EXX
        PUSH    HL
        PUSH    BC
        JR      SAVLO4
SAVLO2: PUSH    AF              ;STRING TYPE
        PUSH    DE
        EXX
        PUSH    HL
        EXX
        CALL    LOADS
        EXX
        POP     HL
        EXX
        LD      C,E
        POP     DE
        CALL    CHECK
        POP     AF              ;LEVEL STACK
        LD      HL,0
        LD      B,L
        SBC     HL,BC
        ADD     HL,SP
        LD      SP,HL
        LD      B,A             ;TYPE
        PUSH    BC
        JR      Z,SAVLO4
        PUSH    DE
        LD      DE,ACCS
        EX      DE,HL
        LD      B,L
        LDIR                    ;SAVE STRING ON STACK
        POP     DE
SAVLO4: PUSH    IX              ;VARPTR
        CALL    SAVLO5
LOCCHK  =     $
SAVLO5: CALL    CHECK
        CALL    NXT
        CP      ","             ;MORE?
        JR      Z,SAVLO1
        EX      DE,HL
        JP      (HL)            ;"RETURN"
;
DELIM:  LD      A,(IY)          ;ASSEMBLER DELIMITER
        CP      " "
        RET     Z
        CP      ","
        RET     Z
        CP      ")"
        RET     Z
TERM:   CP      ";"             ;ASSEMBLER TERMINATOR
        RET     Z
        CP      "\"
        RET     Z
        JR      TERM0
;
TERM?:  CALL    NXT
        CP      ELSE
        RET     NC
TERM0:  CP      ":"             ;ASSEMBLER SEPARATOR
        RET     NC
        CP      CR
        RET
;
SPAN:   CALL    TERM?
        RET     Z
        INC     IY
        JR      SPAN
;
EQUALS: CALL    NXT
        INC     IY
        CP      "="
        RET     Z
        LD      A,4
        JP      ERROR           ;"Mistake"
;
FORMAT: CP      TAB
        JR      Z,DOTAB
        CP      SPC
        JR      Z,DOSPC
        CP      ''''
        RET     NZ
        CALL    CRLF
        XOR     A
        RET
;
DOTAB:  PUSH    BC
        CALL    EXPRI
        EXX
        POP     BC
        LD      A,(IY)
        CP      ","
        JR      Z,DOTAB1
        CALL    BRAKET
        LD      A,L
TABIT:  LD      HL,COUNT
        CP      (HL)
        RET     Z
        PUSH    AF
        CALL    C,CRLF
        POP     AF
        SUB     (HL)
        JR      FILL
DOTAB1: INC     IY
        PUSH    BC
        PUSH    HL
        CALL    EXPRI
        EXX
        POP     DE
        POP     BC
        CALL    BRAKET
        CALL    PUTCSR
        XOR     A
        RET
;
DOSPC:  PUSH    BC
        CALL    ITEMI
        EXX
        LD      A,L
        POP     BC
FILL:   OR      A
        RET     Z
        PUSH    BC
        LD      B,A
FILL1:  LD      A," "
        CALL    OUTCHR
        DJNZ    FILL1
        POP     BC
        XOR     A
        RET
;
PTEXT:  LD      HL,ACCS
        INC     E
PTEXT1: DEC     E
        RET     Z
        LD      A,(HL)
        INC     HL
        CALL    OUTCHR
        JR      PTEXT1
;
FETCHS: PUSH    AF
        PUSH    BC
        PUSH    HL
        EX      (SP),IY
        CALL    XTRACT
        CALL    NXT
        EX      (SP),IY
        POP     HL
        POP     BC
        POP     AF
        RET
;
LINES:  LD      DE,ACCS
LINE1S: LD      A,(HL)
        LD      (DE),A
        CP      CR
        RET     Z
        INC     HL
        INC     E
        JR      LINE1S
;
XTRACT: CALL    NXT
        CP      """
        INC     IY
        JP      Z,CONS
        DEC     IY
        LD      DE,ACCS
XTRAC1: LD      A,(IY)
        LD      (DE),A
        CP      ","
        RET     Z
        CP      CR
        RET     Z
        INC     IY
        INC     E
        JR      XTRAC1
;
SEARCH: LD      B,0
SRCH1:  LD      C,(HL)
        INC     C
        DEC     C
        JR      Z,SRCH2         ;FAIL
        INC     HL
        INC     HL
        INC     HL
        CP      (HL)
        RET     Z
        DEC     C
        DEC     C
        DEC     C
        ADD     HL,BC
        JP      SRCH1
SRCH2:  DEC     HL              ;POINT TO CR
        SCF
        RET
;
X4OR5:  CP      5
        LD      H,D
        LD      L,E
        ADD     HL,HL
        RET     C
        ADD     HL,HL
        RET     C
        EX      DE,HL
        RET     NZ
        ADD     HL,DE
        EX      DE,HL
        RET
;
MUL16:  EX      DE,HL
        LD      HL,0
        LD      A,16
MUL161: ADD     HL,HL
        RET     C               ;OVERFLOW
        SLA     E
        RL      D
        JR      NC,MUL162
        ADD     HL,BC
        RET     C
MUL162: DEC     A
        JR      NZ,MUL161
        RET
;
CHANEL: CALL    NXT
        CP      "#"
        LD      A,45
        JP      NZ,ERROR        ;"Missing #"
CHNL:   INC     IY              ;SKIP "#"
        CALL    ITEMI
        EXX
        EX      DE,HL
        RET
;
;ASSEMBLER:
;LANGUAGE-INDEPENDENT CONTROL SECTION:
; Outputs: A=delimiter, carry set if syntax error.
;
ASSEM:  CALL    SKIP
        INC     IY
        CP      ":"
        JR      Z,ASSEM
        CP      "]"
        RET     Z
        CP      CR
        RET     Z
        DEC     IY
        LD      IX,(PC)         ;PROGRAM COUNTER
        LD      HL,LISTON
        BIT     6,(HL)
        JR      Z,ASSEM0
        LD      IX,(OC)         ;ORIGIN of CODE
ASSEM0: PUSH    IX
        PUSH    IY
        CALL    ASMB
        POP     BC
        POP     DE
        RET     C
        CALL    SKIP
        SCF
        RET     NZ
        DEC     IY
ASSEM3: INC     IY
        LD      A,(IY)
        CALL    TERM0
        JR      NZ,ASSEM3
        LD      A,(LISTON)
        PUSH    IX
        POP     HL
        OR      A
        SBC     HL,DE
        EX      DE,HL           ;DE= NO. OF BYTES
        PUSH    HL
        LD      HL,(PC)
        PUSH    HL
        ADD     HL,DE
        LD      (PC),HL         ;UPDATE PC
        BIT     6,A
        JR      Z,ASSEM5
        LD      HL,(OC)
        ADD     HL,DE
        LD      (OC),HL         ;UPDATE OC
ASSEM5: POP     HL              ;OLD PC
        POP     IX              ;CODE HERE
        BIT     4,A
        JR      Z,ASSEM
        LD      A,H
        CALL    HEX
        LD      A,L
        CALL    HEXSP
        XOR     A
        CP      E
        JR      Z,ASSEM2
ASSEM1: LD      A,(COUNT)
        CP      17
        LD      A,5
        CALL    NC,TABIT        ;NEXT LINE
        LD      A,(IX)
        CALL    HEXSP
        INC     IX
        DEC     E
        JR      NZ,ASSEM1
ASSEM2: LD      A,18
        CALL    TABIT
        PUSH    IY
        POP     HL
        SBC     HL,BC
ASSEM4: LD      A,(BC)
        CALL    OUT
        INC     BC
        DEC     L
        JR      NZ,ASSEM4
        CALL    CRLF
        JP      ASSEM
;
HEXSP:  CALL    HEX
        LD      A," "
        JR      OUTCH1
HEX:    PUSH    AF
        RRCA
        RRCA
        RRCA
        RRCA
        CALL    HEXOUT
        POP     AF
HEXOUT: AND     0x0F
        ADD     A,0x90
        DAA
        ADC     A,0x40
        DAA
OUTCH1: JP      OUT
;
;PROCESSOR-SPECIFIC TRANSLATION SECTION:
;
;REGISTER USAGE: B - TYPE OF MOST RECENT OPERAND
;                C - OPCODE BEING BUILT
;                D - (IX) OR (IY) FLAG
;                E - OFFSET FROM IX OR IY
;               HL - NUMERIC OPERAND VALUE
;               IX - CODE DESTINATION
;               IY - SOURCE TEXT POINTER
;   Inputs: A = initial character
;  Outputs: Carry set if syntax error.
;
ASMB:   CP      "."
        JR      NZ,ASMB1
        INC     IY
        PUSH    IX
        CALL    VAR
        PUSH    AF
        CALL    ZERO
        EXX
        LD      HL,(PC)
        EXX
        POP     AF
        CALL    STORE
        POP     IX
ASMB1:  CALL    SKIP
        RET     Z
        CP      TCALL
        LD      C,0x0C4
        INC     IY
        JP      Z,GRPC
        DEC     IY
        LD      HL,OPCODS
        CALL    FIND
        RET     C
        LD      C,B     ;ROOT OPCODE
        LD      D,0     ;CLEAR IX/IY FLAG
;
;GROUP 0 - TRIVIAL CASES REQUIRING NO COMPUTATION
;GROUP 1 - AS GROUP 0 BUT WITH "ED" PREFIX
;
        SUB     39
        JR      NC,GROUP2
        CP      15-39
        CALL    NC,ED
        JR      BYTE0
;
;GROUP 2 - BIT, RES, SET
;GROUP 3 - RLC, RRC, RL, RR, SLA, SRA, SRL
;
GROUP2: SUB     10
        JR      NC,GROUP4
        CP      3-10
        CALL    C,BIT
        RET     C
        CALL    REGLO
        RET     C
        CALL    CB
        JR      BYTE0
;
;GROUP 4 - PUSH, POP, EX (SP)
;
GROUP4: SUB     3
        JR      NC,GROUP5
G4:     CALL    PAIR
        RET     C
        JR      BYTE0
;
;GROUP 5 - SUB, AND, XOR, OR, CP
;GROUP 6 - ADD, ADC, SBC
;
GROUP5: SUB     8+2
        JR      NC,GROUP7
        CP      5-8
        LD      B,7
        CALL    NC,OPND
        LD      A,B
        CP      7
        JR      NZ,G6HL
G6:     CALL    REGLO
        LD      A,C
        JR      NC,BIND1
        XOR     0x46
        CALL    BIND
DB:     CALL    NUMBER
        JR      VAL8
;
G6HL:   AND     0x3F
        CP      12
        SCF
        RET     NZ
        LD      A,C
        CP      0x80
        LD      C,9
        JR      Z,G4
        XOR     0x1C
        RRCA
        LD      C,A
        CALL    ED
        JR      G4
;
;GROUP 7 - INC, DEC
;
GROUP7: SUB     2
        JR      NC,GROUP8
        CALL    REGHI
        LD      A,C
BIND1:  JP      NC,BIND
        XOR     0x64
        RLCA
        RLCA
        RLCA
        LD      C,A
        CALL    PAIR1
        RET     C
BYTE0:  LD      A,C
        JR      BYTE2
;
;GROUP 8 - IN
;GROUP 9 - OUT
;
GROUP8: SUB     2
        JR      NC,GROUPA
        CP      1-2
        CALL    Z,CORN
        EX      AF,AF'
        CALL    REGHI
        RET     C
        EX      AF,AF'
        CALL    C,CORN
        INC     H
        JR      Z,BYTE0
        LD      A,B
        CP      7
        SCF
        RET     NZ
        LD      A,C
        XOR     3
        RLCA
        RLCA
        RLCA
        CALL    BYTE
        JR      VAL8
;
;GROUP 10 - JR, DJNZ
;
GROUPA: SUB     2
        JR      NC,GROUPB
        CP      1-2
        CALL    NZ,COND
        LD      A,C
        JR      NC,GRPA
        LD      A,0x18
GRPA:   CALL    BYTE
        CALL    NUMBER
        LD      DE,(PC)
        INC     DE
        SCF
        SBC     HL,DE
        LD      A,L
        RLA
        SBC     A,A
        CP      H
TOOFAR: LD      A,1
        JP      NZ,ERROR        ;"Out of range"
VAL8:   LD      A,L
        JR      BYTE2
;
;GROUP 11 - JP
;
GROUPB: LD      B,A
        JR      NZ,GROUPC
        CALL    COND
        LD      A,C
        JR      NC,GRPB
        LD      A,B
        AND     0x3F
        CP      6
        LD      A,0x0E9
        JR      Z,BYTE2
        LD      A,0x0C3
GRPB:   CALL    BYTE
        JR      ADDR
;
;GROUP 12 - CALL
;
GROUPC: DJNZ    GROUPD
GRPC:   CALL    GRPE
ADDR:   CALL    NUMBER
VAL16:  CALL    VAL8
        LD      A,H
        JR      BYTE2
;
;GROUP 13 - RST
;
GROUPD: DJNZ    GROUPE
        CALL    NUMBER
        AND     C
        OR      H
        JR      NZ,TOOFAR
        LD      A,L
        OR      C
BYTE2:  JR      BYTE1
;
;GROUP 14 - RET
;
GROUPE: DJNZ    GROUPF
GRPE:   CALL    COND
        LD      A,C
        JR      NC,BYTE1
        OR      9
        JR      BYTE1
;
;GROUP 15 - LD
;
GROUPF: DJNZ    MISC
        CALL    LDOP
        JR      NC,LDA
        CALL    REGHI
        EX      AF,AF'
        CALL    SKIP
        CP      "("
        JR      Z,LDIN
        EX      AF,AF'
        JP      NC,G6
        LD      C,1
        CALL    PAIR1
        RET     C
        LD      A,14
        CP      B
        LD      B,A
        CALL    Z,PAIR
        LD      A,B
        AND     0x3F
        CP      12
        LD      A,C
        JR      NZ,GRPB
        LD      A,0x0F9
        JR      BYTE1
;
LDIN:   EX      AF,AF'
        PUSH    BC
        CALL    NC,REGLO
        LD      A,C
        POP     BC
        JR      NC,BIND
        LD      C,0x0A
        CALL    PAIR1
        CALL    LD16
        JR      NC,GRPB
        CALL    NUMBER
        LD      C,2
        CALL    PAIR
        CALL    LD16
        RET     C
        CALL    BYTE
        JR      VAL16
;
;OPT - SET OPTION
;
OPT:    DEC     B
        JP      Z,DB
        DJNZ    ADDR
        CALL    NUMBER
        LD      HL,LISTON
        LD      C,A
        RLD
        LD      A,C
        RRD
        RET
;
LDA:    CP      4
        CALL    C,ED
        LD      A,B
BYTE1:  JR      BYTE
;
;MISC - .db, .dw, .ascii
;
MISC:   DJNZ    OPT
        PUSH    IX
        CALL    EXPRS
        POP     IX
        LD      HL,ACCS
DEFM1:  XOR     A
        CP      E
        RET     Z
        LD      A,(HL)
        INC     HL
        CALL    BYTE
        DEC     E
        JR      DEFM1
;
;SUBROUTINES:
;
LD16:   LD      A,B
        JR      C,LD8
        LD      A,B
        AND     0x3F
        CP      12
        LD      A,C
        RET     Z
        CALL    ED
        LD      A,C
        OR      0x43
        RET
;
LD8:    CP      7
        SCF
        RET     NZ
        LD      A,C
        OR      0x30
        RET
;
CORN:   PUSH    BC
        CALL    OPND
        BIT     5,B
        POP     BC
        JR      Z,NUMBER
        LD      H,-1
ED:     LD      A,0x0ED
        JR      BYTE
;
CB:     LD      A,0x0CB
BIND:   CP      0x76
        SCF
        RET     Z               ;REJECT LD (HL),(HL)
        CALL    BYTE
        INC     D
        RET     P
        LD      A,E
        JR      BYTE
;
OPND:   PUSH    HL
        LD      HL,OPRNDS
        CALL    FIND
        POP     HL
        RET     C
        BIT     7,B
        RET     Z
        BIT     3,B
        PUSH    HL
        CALL    Z,OFFSET
        LD      E,L
        POP     HL
        LD      A,0x0DD
        BIT     6,B
        JR      Z,OP1
        LD      A,0x0FD
OP1:    OR      A
        INC     D
        LD      D,A
        RET     M
BYTE:   LD      (IX),A
        INC     IX
        OR      A
        RET
;
OFFSET: LD      A,(IY)
        CP      ")"
        LD      HL,0
        RET     Z
NUMBER: CALL    SKIP
        PUSH    BC
        PUSH    DE
        PUSH    IX
        CALL    EXPRI
        POP     IX
        EXX
        POP     DE
        POP     BC
        LD      A,L
        OR      A
        RET
;
REG:    CALL    OPND
        RET     C
        LD      A,B
        AND     0x3F
        CP      8
        CCF
        RET
;
REGLO:  CALL    REG
        RET     C
        JR      ORC
;
REGHI:  CALL    REG
        RET     C
        JR      SHL3
;
COND:   CALL    OPND
        RET     C
        LD      A,B
        AND     0x1F
        SUB     16
        JR      NC,SHL3
        CP      -15
        SCF
        RET     NZ
        LD      A,3
        JR      SHL3
;
PAIR:   CALL    OPND
        RET     C
PAIR1:  LD      A,B
        AND     0x0F
        SUB     8
        RET     C
        JR      SHL3
;
BIT:    CALL    NUMBER
        CP      8
        CCF
        RET     C
SHL3:   RLCA
        RLCA
        RLCA
ORC:    OR      C
        LD      C,A
        RET
;
LDOP:   LD      HL,LDOPS
FIND:   CALL    SKIP
EXIT:   LD      B,0
        SCF
        RET     Z
        CP      DEF
        JR      Z,FIND0
        CP      TOR+1
        CCF
        RET     C
FIND0:  LD      A,(HL)
        OR      A
        JR      Z,EXIT
        XOR     (IY)
        AND     01011111B
        JR      Z,FIND2
FIND1:  BIT     7,(HL)
        INC     HL
        JR      Z,FIND1
        INC     HL
        INC     B
        JR      FIND0
;
FIND2:  PUSH    IY
FIND3:  BIT     7,(HL)
        INC     IY
        INC     HL
        JR      NZ,FIND5
        CP      (HL)
        CALL    Z,SKIP0
        LD      A,(HL)
        XOR     (IY)
        AND     01011111B
        JR      Z,FIND3
FIND4:  POP     IY
        JR      FIND1
;
FIND5:  CALL    DELIM
        CALL    NZ,SIGN
        JR      NZ,FIND4
FIND6:  LD      A,B
        LD      B,(HL)
        POP     HL
        RET
;
SKIP0:  INC     HL
SKIP:   CALL    DELIM
        RET     NZ
        CALL    TERM
        RET     Z
        INC     IY
        JR      SKIP
;
SIGN:   CP      "+"
        RET     Z
        CP      "-"
        RET
;
        ;.XLIST
OPCODS: .ascii    'NO'
        .db    'P'+0x80
        .db    0
        .ascii    'RLC'
        .db    'A'+0x80
        .db    7
        .ascii    'EX'
        .db    0
        .ascii    'AF'
        .db    0
        .ascii    'AF'
        .db    ''''+0x80
        .db    8
        .ascii    'RRC'
        .db    'A'+0x80
        .db    0x0F
        .ascii    'RL'
        .db    'A'+0x80
        .db    0x17
        .ascii    'RR'
        .db    'A'+0x80
        .db    0x1F
        .ascii    'DA'
        .db    'A'+0x80
        .db    0x27
        .ascii    'CP'
        .db    'L'+0x80
        .db    0x2F
        .ascii    'SC'
        .db    'F'+0x80
        .db    0x37
        .ascii    'CC'
        .db    'F'+0x80
        .db    0x3F
        .ascii    'HAL'
        .db    'T'+0x80
        .db    0x76
        .ascii    'EX'
        .db    'X'+0x80
        .db    0x0D9
        .ascii    'EX'
        .db    0
        .ascii    'DE'
        .db    0
        .ascii    "H"
        .db    'L'+0x80
        .db    0x0EB
        .ascii    "D"
        .db    'I'+0x80
        .db    0x0F3
        .ascii    "E"
        .db    'I'+0x80
        .db    0x0FB
;
        .ascii    'NE'
        .db    'G'+0x80
        .db    0x44
        .ascii    'IM'
        .db    0
        .db    '0'+0x80
        .db    0x46
        .ascii    'RET'
        .db    'N'+0x80
        .db    0x45
        .ascii    'RET'
        .db    'I'+0x80
        .db    0x4D
        .ascii    'IM'
        .db    0
        .db    '1'+0x80
        .db    0x56
        .ascii    'IM'
        .db    0
        .db    '2'+0x80
        .db    0x5E
        .ascii    'RR'
        .db    'D'+0x80
        .db    0x67
        .ascii    'RL'
        .db    'D'+0x80
        .db    0x6F
        .ascii    'LD'
        .db    'I'+0x80
        .db    0x0A0
        .ascii    'CP'
        .db    'I'+0x80
        .db    0x0A1
        .ascii    'IN'
        .db    'I'+0x80
        .db    0x0A2
        .ascii    'OUT'
        .db    'I'+0x80
        .db    0x0A3
        .ascii    'LD'
        .db    'D'+0x80
        .db    0x0A8
        .ascii    'CP'
        .db    'D'+0x80
        .db    0x0A9
        .ascii    'IN'
        .db    'D'+0x80
        .db    0x0AA
        .ascii    'OUT'
        .db    'D'+0x80
        .db    0x0AB
        .ascii    'LDI'
        .db    'R'+0x80
        .db    0x0B0
        .ascii    'CPI'
        .db    'R'+0x80
        .db    0x0B1
        .ascii    'INI'
        .db    'R'+0x80
        .db    0x0B2
        .ascii    'OTI'
        .db    'R'+0x80
        .db    0x0B3
        .ascii    'LDD'
        .db    'R'+0x80
        .db    0x0B8
        .ascii    'CPD'
        .db    'R'+0x80
        .db    0x0B9
        .ascii    'IND'
        .db    'R'+0x80
        .db    0x0BA
        .ascii    'OTD'
        .db    'R'+0x80
        .db    0x0BB
;
        .ascii    'BI'
        .db    'T'+0x80
        .db    0x40
        .ascii    'RE'
        .db    'S'+0x80
        .db    0x80
        .ascii    'SE'
        .db    'T'+0x80
        .db    0x0C0
;
        .ascii    'RL'
        .db    'C'+0x80
        .db    0
        .ascii    'RR'
        .db    'C'+0x80
        .db    8
        .ascii    "R"
        .db    'L'+0x80
        .db    0x10
        .ascii    "R"
        .db    'R'+0x80
        .db    0x18
        .ascii    'SL'
        .db    'A'+0x80
        .db    0x20
        .ascii    'SR'
        .db    'A'+0x80
        .db    0x28
        .ascii    'SR'
        .db    'L'+0x80
        .db    0x38
;
        .ascii    'PO'
        .db    'P'+0x80
        .db    0x0C1
        .ascii    'PUS'
        .db    'H'+0x80
        .db    0x0C5
        .ascii    'EX'
        .db    0
        .ascii    '(S'
        .db    'P'+0x80
        .db    0x0E3
;
        .ascii    'SU'
        .db    'B'+0x80
        .db    0x90
        .ascii    'AN'
        .db    'D'+0x80
        .db    0x0A0
        .ascii    'XO'
        .db    'R'+0x80
        .db    0x0A8
        .ascii    "O"
        .db    'R'+0x80
        .db    0x0B0
        .ascii    "C"
        .db    'P'+0x80
        .db    0x0B8
        .db    TAND
        .db    0x0A0
        .db    TOR
        .db    0x0B0
;
        .ascii    'AD'
        .db    'D'+0x80
        .db    0x80
        .ascii    'AD'
        .db    'C'+0x80
        .db    0x88
        .ascii    'SB'
        .db    'C'+0x80
        .db    0x98
;
        .ascii    'IN'
        .db    'C'+0x80
        .db    4
        .ascii    'DE'
        .db    'C'+0x80
        .db    5
;
        .ascii    "I"
        .db    'N'+0x80
        .db    0x40
        .ascii    'OU'
        .db    'T'+0x80
        .db    0x41
;
        .ascii    "J"
        .db    'R'+0x80
        .db    0x20
        .ascii    'DJN'
        .db    'Z'+0x80
        .db    0x10
;
        .ascii    "J"
        .db    'P'+0x80
        .db    0x0C2
;
        .ascii    'CAL'
        .db    'L'+0x80
        .db    0x0C4
;
        .ascii    'RS'
        .db    'T'+0x80
        .db    0x0C7
;
        .ascii    'RE'
        .db    'T'+0x80
        .db    0x0C0
;
        .ascii    "L"
        .db    'D'+0x80
        .db    0x40
;
        .db    DEF AND 0x7F
        .db    'M'+0x80
        .db    0
;
        .db    DEF AND 0x7F
        .db    'B'+0x80
        .db    0
;
        .ascii    'OP'
        .db    'T'+0x80
        .db    0
;
        .db    DEF AND 0x7F
        .db    'W'+0x80
        .db    0
;
        .db    0
;
OPRNDS: .db    'B'+0x80
        .db    0
        .db    'C'+0x80
        .db    1
        .db    'D'+0x80
        .db    2
        .db    'E'+0x80
        .db    3
        .db    'H'+0x80
        .db    4
        .db    'L'+0x80
        .db    5
        .ascii    '(H'
        .db    'L'+0x80
        .db    6
        .db    'A'+0x80
        .db    7
        .ascii    '(I'
        .db    'X'+0x80
        .db    0x86
        .ascii    '(I'
        .db    'Y'+0x80
        .db    0x0C6
;
        .ascii    "B"
        .db    'C'+0x80
        .db    8
        .ascii    "D"
        .db    'E'+0x80
        .db    10
        .ascii    "H"
        .db    'L'+0x80
        .db    12
        .ascii    "I"
        .db    'X'+0x80
        .db    0x8C
        .ascii    "I"
        .db    'Y'+0x80
        .db    0x0CC
        .ascii    "A"
        .db    'F'+0x80
        .db    14
        .ascii    "S"
        .db    'P'+0x80
        .db    14
;
        .ascii    "N"
        .db    'Z'+0x80
        .db    16
        .db    'Z'+0x80
        .db    17
        .ascii    "N"
        .db    'C'+0x80
        .db    18
        .ascii    "P"
        .db    'O'+0x80
        .db    20
        .ascii    "P"
        .db    'E'+0x80
        .db    21
        .db    'P'+0x80
        .db    22
        .db    'M'+0x80
        .db    23
;
        .ascii    "("
        .db    'C'+0x80
        .db    0x20
;
        .db    0
;
LDOPS:  .ascii    "I"
        .db    0
        .db    'A'+0x80
        .db    0x47
        .ascii    "R"
        .db    0
        .db    'A'+0x80
        .db    0x4F
        .ascii    "A"
        .db    0
        .db    'I'+0x80
        .db    0x57
        .ascii    "A"
        .db    0
        .db    'R'+0x80
        .db    0x5F
        .ascii    '(BC'
        .db    0
        .db    'A'+0x80
        .db    2
        .ascii    '(DE'
        .db    0
        .db    'A'+0x80
        .db    0x12
        .ascii    "A"
        .db    0
        .ascii    '(B'
        .db    'C'+0x80
        .db    0x0A
        .ascii    "A"
        .db    0
        .ascii    '(D'
        .db    'E'+0x80
        .db    0x1A
;
        .db    0
;
        .LIST
;
LF      =     0x0A
CR      =     0x0D
;
FIN:    END
