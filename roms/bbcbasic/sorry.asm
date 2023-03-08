;
        .globl  CLG
        .globl  COLOUR
        .globl  DRAW
        .globl  ENVEL
        .globl  GCOL
        .globl  MODE
        .globl  MOVE
        .globl  PLOT
        .globl  SOUND
        .globl  ADVAL
        .globl  POINT
        .globl  GETIMS
        .globl  PUTIMS
;
        .globl   EXTERR
;
CLG:
COLOUR:
DRAW:
ENVEL:
GCOL:
MODE:
MOVE:
PLOT:
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
        END
