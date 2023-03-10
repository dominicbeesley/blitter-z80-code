        .title   BBC BASIC (C) R.T.RUSSELL 1984
;
;BBC BASIC (Z80) - CP/M VERSION.
;(C) COPYRIGHT R.T.RUSSELL, 1984.
;ALL RIGHTS RESERVED.
;
;THIS PROGRAM ALLOWS THE USER TO ADAPT BBC BASIC TO THE
;PARTICULAR CHARACTERISTICS OF HIS SYSTEM HARDWARE ETC.
;
;THE PROGRAM RESIDES AT 0x100 FOR EASE OF LOADING.
;*** IT MUST NOT EXCEED 256 BYTES IN TOTAL LENGTH ***
;
;PLEASE NOTE THAT A Z80 PROCESSOR AND CP/M VERSION 2.2
;OR LATER ARE REQUIRED.
;
;R.T.RUSSELL, 04-02-1984
;
;;BDOS    =     5
;
        .globl  CLRSCN
        .globl  PUTCSR
        .globl  GETCSR
        .globl  PUTIME
        .globl  GETIME
        .globl  GETKEY
        .globl  BYE


        .globl  START
;
;        ASEG
 ;       ORG     0x100
;
;JUMP TABLE - BASIC makes calls to hardware-dependent
;features via this table:
;

        .area   CODE(REL,CON)

        JP      INIT
CLRSCN: JP      CLS             ;CLEAR SCREEN
PUTCSR: JP      PCSR            ;SET CURSOR POSN.
GETCSR: JP      GCSR            ;READ CURSOR POSN.
PUTIME: JP      PTIME           ;SET ELAPSED TIME
GETIME: JP      GTIME           ;READ ELAPSED TIME
GETKEY: JP      INKEY           ;READ KEY (TIME LIMIT)
BYE:    JP      REBOOT          ;RETURN TO CP/M
;
;THE CODE WHICH FOLLOWS IS SUITABLE FOR THE CRF/RTR
;BOARD. IT SHOULD BE MODIFIED TO SUIT YOUR SYSTEM.
;
; dtrg: I've disabled all of this due to problems with the NC200 and
; emulator.

;
;VECTOR TABLE FOR Z80-CTC:
;
;;        ORG     $+7 AND 0x0FFF8
;
;VECTOR: .dw    TIMER
;        .dw    TIMER
;        .dw    TIMER
;        .dw    TIMER
;
;INIT - Perform hardware initialisation.
;
INIT:   ;CALL    INTIME          ;INITIALISE TIMER
        JP      START
;
;REBOOT - Stop interrupts and return to CP/M. 
;
REBOOT: LD      A,3
;        OUT     (CTC0+3),A
        RST     0

;
;INTIME - Initialise CTC to interrupt every 10 ms.
;Also set time to zero.
;
;INTIME: DI
;        IM      2
;        LD      A,VECTOR/256
;        LD      I,A
;        LD      A,VECTOR AND 0x0FF
;        OUT     (CTC0),A
;        LD      A,10100111B
;        OUT     (CTC0+3),A
;        LD      A,96
;        OUT     (CTC0+3),A
;        LD      HL,0
;        LD      (TIME),HL
;        LD      (TIME+2),HL
;        EI
;        RETI
;;
;;TIMER - Interrupt service routine.
;;Increments elapsed-time clock 100 times per second.
;;
;TIMER:  PUSH    AF
;        PUSH    BC
;        PUSH    HL
;        LD      HL,TIME
;        LD      B,4
;UPT1:   INC     (HL)
;        JR      NZ,EXIT
;        INC     HL
;        DJNZ    UPT1
;EXIT:   POP     HL
;        POP     BC
;        POP     AF
;        EI
;        RETI
;
;GTIME - Read elapsed-time clock.
;  Outputs: DEHL = elapsed time (centiseconds)
; Destroys: A,D,E,H,L,F
;
GTIME:  DI
        LD      HL,(TIME)
        LD      DE,(TIME+2)
        EI
        RET
;
;PTIME - Load elapsed-time clock.
;   Inputs: DEHL = time to load (centiseconds)
; Destroys: A,D,E,H,L,F
;
PTIME:  DI
        LD      (TIME),HL
        LD      (TIME+2),DE
        EI
        RET
;
;CLS - Clear screen.
; Destroys: A,D,E,H,L,F
;
CLS:    ;;PUSH    BC
        ;;LD      C,2
        ;;LD      E,12
        ;;CALL    BDOS
        ;;LD      C,2
        ;;LD      E,24
        ;;CALL    BDOS
        ;;POP     BC
        ;;RET
        LD      A,12
        JP      OSWRCH
;
;INKEY - Sample keyboard with specified wait.
;   Inputs: HL = Time to wait (centiseconds)
;  Outputs: Carry reset indicates time-out.
;           If carry set, A = character typed.
; Destroys: A,D,E,H,L,F
;
INKEY:  PUSH    BC
        PUSH    HL
        LD      C,6
        LD      E,0x0FF
        CALL    BDOS            ;CONSOLE INPUT
        POP     HL
        POP     BC
        OR      A
        SCF
        RET     NZ              ;KEY PRESSED
        OR      H
        OR      L
        RET     Z               ;TIME-OUT
        PUSH    HL
        LD      HL,TIME
        LD      A,(HL)
WAIT1:  CP      (HL)
        JR      Z,WAIT1         ;WAIT FOR 10 ms.
        POP     HL
        DEC     HL
        JR      INKEY
;
;PCSR - Move cursor to specified position.
;   Inputs: DE = horizontal position (LHS=0)
;           HL = vertical position (TOP=0)
; Destroys: A,D,E,H,L,F
;
;
PCSR:   RET
;		LD      A,E
;        ADD     HL,HL
;        ADD     HL,HL
;        ADD     HL,HL
;        ADD     HL,HL           ;*16
;        LD      D,H
;        LD      E,L
;        ADD     HL,HL
;        ADD     HL,HL
;        ADD     HL,DE           ;*80
;        LD      D,0
;        LD      E,A
;        ADD     HL,DE           ;OFFSET FROM HOME
;        LD      DE,(HOME)
;        ADD     HL,DE
;        LD      A,14
;        OUT     (CRTCS),A
;        LD      A,H
;        AND     0x0F
;        OUT     (CRTCD),A
;        LD      A,15
;        OUT     (CRTCS),A
;        LD      A,L
;        OUT     (CRTCD),A
;        RET
;
;GCSR - Return cursor coordinates.
;   Outputs:  DE = X coordinate (POS)
;             HL = Y coordinate (VPOS)
;  Destroys: A,D,E,H,L,F
;
GCSR:	ld		de, 0
		ld 		hl, 0
		ret
;		LD      A,14
;        OUT     (CRTCS),A
;        IN      A,(CRTCD)
;        LD      H,A
;        LD      A,15
;        OUT     (CRTCS),A
;        IN      A,(CRTCD)
;        LD      L,A
;        LD      DE,(HOME)
;        SBC     HL,DE
;        LD      A,H
;        AND     7
;        LD      H,A
;        LD      DE,-80
;        LD      A,D
;ROWS:   ADD     HL,DE
;        INC     A
;        JR      C,ROWS
;        SBC     HL,DE
;        LD      D,0
;        LD      E,A
;        EX      DE,HL
;        RET
;
TIME:   .rmb    4
;
HOME    =     0x0FF21
;
CTC0    =     0x80
CRTCS   =     0x84
CRTCD   =     0x85
;
;;        IF      . > 0x1F4
;;        ERROR   'INSUFFICIENT SPACE'
;;        ENDIF
;
;;        ORG     0x1F4
;
        .db    80              ;WIDTH
        .db    "K" AND 0x1F     ;CURSOR UP
        .db    "J" AND 0x1F     ;CURSOR DOWN
        .db    "L" AND 0x1F     ;START OF LINE
        .db    "B" AND 0x1F     ;END OF LINE
        .db    "C" AND 0x1F     ;DELETE TO END OF LINE
        .db    0x7F             ;BACKSPACE & DELETE
        .db    "X" AND 0x1F     ;CANCEL LINE
        .db    "H" AND 0x1F     ;CURSOR LEFT
        .db    "I" AND 0x1F     ;CURSOR RIGHT
        .db    "E" AND 0x1F     ;DELETE CHARACTER
        .db    "A" AND 0x1F     ;INSERT CHARACTER
;
PATCH_END::
FIN:    .end

