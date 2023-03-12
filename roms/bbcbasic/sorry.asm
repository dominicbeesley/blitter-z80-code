;
        .globl  CLG
        .globl  ENVEL
        .globl  GCOL
        .globl  SOUND
        .globl  ADVAL
        .globl  POINT
        .globl  GETIMS
        .globl  PUTIMS
;
        .globl   EXTERR

        .area   CODE(REL,CON)

;
CLG:
ENVEL:
SOUND:
ADVAL:
POINT:
GETIMS:
PUTIMS:
        XOR     A
        CALL    EXTERR
        .ascii    'Sorry'
        .db    0
;
        .end
