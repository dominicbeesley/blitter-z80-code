        .title   BBC BASIC (C) R.T.RUSSELL 1984
;
;RAM MODULE FOR BBC BASIC INTERPRETER
;FOR USE WITH VERSION 2.0 OF BBC BASIC
;*STANDARD CP/M DISTRIBUTION VERSION*
;(C) COPYRIGHT R.T.RUSSELL 31-12-1983
;
        .globl  ACCS
        .globl  BUFFER
        .globl  LINENO
        .globl  TOP
        .globl  .page
        .globl  LOMEM
        .globl  FREE
        .globl  HIMEM
        .globl  RANDOM
        .globl  COUNT
        .globl  WIDTH
        .globl  ERL
        .globl  ERR
        .globl  ERRTRP
        .globl  ERRTXT
        .globl  TRACEN
        .globl  AUTONO
        .globl  INCREM
        .globl  LISTON
        .globl  DATPTR
        .globl  FNPTR
        .globl  PROPTR
        .globl  STAVAR
        .globl  OC
        .globl  PC
        .globl  DYNVAR
        .globl  ERRLIN
        .globl  USER

        .area   CODE(REL,CON)

        .bndry  256

;
;n.b. ACCS, BUFFER & STAVAR must be on page boundaries.
;
ACCS:   .rmb    256             ;STRING ACCUMULATOR
BUFFER: .rmb    256             ;STRING INPUT BUFFER
STAVAR: .rmb    27*4            ;STATIC VARIABLES
OC      =     STAVAR+15*4     ;CODE ORIGIN (O%)
PC      =     STAVAR+16*4     ;PROGRAM COUNTER (P%)
DYNVAR: .rmb    54*2            ;DYN. VARIABLE POINTERS
FNPTR:  .rmb    2               ;DYN. FUNCTION POINTER
PROPTR: .rmb    2               ;DYN. PROCEDURE POINTER
;
.page:   .rmb    2               ;START OF USER PROGRAM
TOP:    .rmb    2               ;FIRST LOCN AFTER PROG.
LOMEM:  .rmb    2               ;START OF DYN. STORAGE
FREE:   .rmb    2               ;FIRST FREE-SPACE BYTE
HIMEM:  .rmb    2               ;FIRST PROTECTED BYTE
;
LINENO: .rmb    2               ;LINE NUMBER
TRACEN: .rmb    2               ;TRACE FLAG
AUTONO: .rmb    2               ;AUTO FLAG
ERRTRP: .rmb    2               ;ERROR TRAP
ERRTXT: .rmb    2               ;ERROR MESSAGE POINTER
DATPTR: .rmb    2               ;DATA POINTER
ERL:    .rmb    2               ;ERROR LINE
ERRLIN: .rmb    2               ;"ON ERROR" LINE
RANDOM: .rmb    5               ;RANDOM NUMBER
COUNT:  .rmb    1               ;PRINT POSITION
WIDTH:  .rmb    1               ;PRINT WIDTH
ERR:    .rmb    1               ;ERROR NUMBER
LISTON: .rmb    1               ;LISTO & OPT FLAG
INCREM: .rmb    1               ;AUTO INCREMENT
;
USER:   .end
