;  Adapted from MONZ80.asm - Z80 Debug monitor for use with NoICEZ80
;  This file may be assembled with the asz80 assembler
;
;  Copyright (c) 2018 by John Hartman
;  Copyright (c) 2023 by Dominic Beesley
;
;  Modification History:
;       14-Jun-93 JLH release version
;       24-Aug-93 JLH bad constant for COMBUF length compare
;        8-Nov-93 JLH change to use RST 8 for breakpoint, not RST 38 (v1.3)
;       20-Dec-93 JLH bug in NMI dummy vectors: overwrote NMI and reset!
;       17-Oct-95 JLH eliminate two-arg for SUB, AND, OR, XOR, and CP
;       21-Jul-00 JLH change FN_MIN from F7 to F0
;       12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;       11-Jan-05 JLH V3.1: correct bug in Z180 reset/illegal op-code trap
;       12-Nov-18 JLH modify to assemble with Arnold's as
;       31-Jan-23 .db  modify for asz180 and to run on the Blitter+z180 platform
;

                .include        "../../../includes/hardware.inc"
                .include        "../../includes/hardware.inc"
                .hd64                   ; z180 instruction set

NOICE_STACK_SIZE        =       64              ; size of local stack
NOICE_COMBUF_SIZE       =       67              ; DATA SIZE FOR COMM BUFFER

                .area NOICE_DATA(ABS,CON,DSEG)
;
;  Initial user stack
;  (Size and location is user option)
                .ds      NOICE_STACK_SIZE
INITSTACK:
;
;  Monitor stack
;  (Calculated use is at most 6 bytes.  Leave plenty of spare)
                .ds      16
MONSTACK:
;
;  Target registers:  order must match that in TRGZ80.C
TASK_REGS:
REG_STATE:      .ds      1
REG_PAGE:       .ds      1
REG_SP:         .ds      2
REG_IX:         .ds      2
REG_IY:         .ds      2
REG_HL:         .ds      2
REG_BC:         .ds      2
REG_DE:         .ds      2
REG_AF:                         ;LABEL ON FLAGS, A AS A WORD
REG_FLAGS:      .ds      1
REG_A:          .ds      1
REG_PC:         .ds      2
REG_I:          .ds      1
REG_IFF:        .ds      1
 ;
REG_HLX:        .ds      2      ;ALTERNATE REGISTER SET
REG_BCX:        .ds      2
REG_DEX:        .ds      2
REG_AFX:                        ;LABEL ON FLAGS, A AS A WORD
REG_FLAGSX:     .ds      1
REG_AX:         .ds      1
TASK_REGS_SIZE  =     .-TASK_REGS

;
;  Communications buffer
;  (Must be at least as long as TASK_REG_SIZE.  Larger values may improve
;  speed of NoICE memory load and dump commands)
COMBUF:         .ds      2+NOICE_COMBUF_SIZE+1 ;BUFFER ALSO HAS FN, LEN, AND ChECK
;

RAM_END:                        ;ADDRESS OF TOP+1 OF RAM





                .area CODE(ABS, CON)

;===========================================================================
;
;  Default handlers for RST and NMI.  This code is moved to the beginning
;  of RAM
;
DEFAULT_INTS:
;
;  RST 0
R0:     DI
        JP      RESET
        NOP
        NOP
        NOP
        NOP
;
;  (vectored only if not used for breakpoint)
;  RST 8
        PUSH    AF
        LD      A,3                     ;STATE = 3 (INTERRUPT 8)
        JP      INT_ENTRY
        NOP
        NOP
;
;  RST 0x10
        PUSH    AF
        LD      A,4                     ;STATE = 4 (INTERRUPT 10)
        JP      INT_ENTRY
        NOP
        NOP
;
;  RST 0x18
        PUSH    AF
        LD      A,5                     ;STATE = 5 (INTERRUPT 18)
        JP      INT_ENTRY
        NOP
        NOP
;
;  RST 0x20
        PUSH    AF
        LD      A,6                     ;STATE = 6 (INTERRUPT 20)
        JP      INT_ENTRY
        NOP
        NOP
;
;  RST 0x28
        PUSH    AF
        LD      A,7                     ;STATE = 7 (INTERRUPT 28)
        JP      INT_ENTRY
        NOP
        NOP
;
;  RST 0x30
        PUSH    AF
        LD      A,8                     ;STATE = 8 (INTERRUPT 30)
        JP      INT_ENTRY
        NOP
        NOP
;
;  RST 0x38
        PUSH    AF
        LD      A,9                     ;STATE = 9 (INTERRUPT 38)
        JP      INT_ENTRY

DEFAULT_INTS_SIZE      = .-DEFAULT_INTS

;===========================================================================
;
;  Non-maskable interrupt:  bash button
;  PC is stacked, interrupts disabled, and IFF2 has pre-NMI interrupt state
;
;  At the user's option, this may vector thru user RAM at USER_CODE+0x66,
;  or enter the monitor directly.  This will depend on whether or not
;  the user wishes to use NMI in the application, or to use it with
;  a push button to break into running code.
;        ORG     R0+0x66
DEFAULT_NMI:
        PUSH    AF
        LD      A,2
        JP      INT_ENTRY
;
;  Or, if user wants control of NMI:
;;      JP      USER_CODE + 0x66         ;JUMP THRU VECTOR IN RAM
;;  (and enable NMI handler in DEFAULT_INTS below)
DEFAULT_NMI_SIZE = .-NMI_ENTRY


;
;===========================================================================
;  Power on reset or trap
RESET:
;
;----------------------------------------------------------------------------
;  See if this is an illegal op-code trap or a reset
        LD      (REG_SP),SP     ;save user's stack pointer (or zero after reset)
        LD      SP,MONSTACK     ;and get a guaranteed stack
        PUSH    AF              ;SAVE A AND FLAGS
        IN0     a,(ITC)         ;ChECK TRAP STATUS (FLAGS DESTROYED!!)
        BIT     7,A             ;IF THIS BIT IS ONE, THERE WAS TRAP!
        JR      Z,INIT          ;JIF RESET (AF on stack, but SP will be reloaded)
;
;  Illegal instruction trap:
;  Back up the stacked PC by either 1 or 2 bytes, depending on the state
;  of the UFO bit in the itc
        LD      (REG_HL),HL
        POP     HL              ;get AF stacked above
        LD      (REG_AF),HL     ;SAVE AF

        LD      SP,(REG_SP)     ;restore SP after trap
        POP     HL              ;GET STACKED PC
        DEC     HL              ;BACK UP ONE BYTE
        BIT     6,A
        JR      Z,TR20          ;JIF 1 BYTE OP-CODE
        DEC     HL              ;ELSE BACK UP SECOND OP-CODE BYTE
;
;  Reset the trap bit
TR20:   AND     0x7F             ;CLEAR THE TRAP BIT
        out0    (ITC),a
;
;  Get IFF2
;  It is not clear that we can determine the pre-trap state of the
;  interrupt enable:  the databook says nothing about IFF2 vis a vis
;  trap.  We presume that interrupts are disabled by the trap.
;  However, we proceed as if IFF2 contained the pre-trap state
        LD      A,I             ;GET P FLAG = IFF2 (SIDE EFFECT)
        DI                      ;BE SURE INTS ARE DISABLED
        LD      (REG_I),A       ;SAVE INT REG
        LD      A,0
        JP      PO,TR30         ;JIF PARITY ODD (FLAG=0)
        INC     A               ;ELSE SET A = FLAG = 1 (ENABLED)
TR30:   LD      (REG_IFF),A     ;SAVE INTERRUPT FLAG
;
;  save registers in reg block for return to master
        LD      A,10
        LD      (REG_STATE),A   ;SET STATE TO "TRAP"
        JP      ENTER_MON       ;HL = OFFENDING PC

;
;-------------------------------------------------------------------------
;  Initialize monitor
INIT:   LD      SP,MONSTACK
;
;  Initialize target hardware
        LD      HL,INIOUT       ;PUT ADRESS OF INITIALIZATION DATA TABLE INTO HL
        LD      D,OUTCNT        ;PUT NUMBER OF DATA AND ADDR. PAIRS INTO REG. B

        LD      B,0             ;all internal regs in this table
RST10:  LD      C,(HL)          ;load address from table
        INC     HL
        LD      A,(HL)          ;load data from table
        INC     HL
        OUT     (C),A           ;output a to i/o address (A15-A8 = B = 0)
        DEC     D
        JR      NZ,RST10        ;loop for d (address, data) pairs
;
;===========================================================================
;  Perform user hardware initilaization here

;===========================================================================
;  Initialize user interrupt vectors to point to monitor
        LD      HL,DEFAULT_INTS         ;dummy handler code
        LD      DE,0                    ;start of 0 vectors
        LD      BC,DEFAULT_INTS_SIZE    ;number of bytes
        LDIR                            ;copy code

;===========================================================================
;  Same for NMI
        LD      HL,DEFAULT_NMI          ;dummy handler code
        LD      DE,0x66                 ;start of 0 vectors
        LD      BC,DEFAULT_NMI_SIZE     ;number of bytes
        LDIR                            ;copy code


;===========================================================================
;
;  Initialize user registers
        LD      HL,INITSTACK
        LD      (REG_SP),HL             ;INIT USER'S STACK POINTER
        LD      HL,0
        LD      A,L
        LD      (REG_PC),HL             ;INIT ALL REGS TO 0
        LD      (REG_HL),HL
        LD      (REG_BC),HL
        LD      (REG_DE),HL
        LD      (REG_IX),HL
        LD      (REG_IY),HL
        LD      (REG_AF),HL
        LD      (REG_HLX),HL
        LD      (REG_BCX),HL
        LD      (REG_DEX),HL
        LD      (REG_AFX),HL
        LD      (REG_I),A
        LD      (REG_STATE),A           ;set state as "RESET"
        LD      (REG_IFF),A             ;NO INTERRUPTS
;
;  Initialize memory paging variables and hardware (if any)
        LD      (REG_PAGE),A            ;page 0
;;;     LD      (PAGEIMAGE),A
;;;     OUT     (PAGELATCH),A           ;set hardware page
;
;  Set function code for "GO".  Then if we reset after being told to
;  GO, we will come back with registers so user can see the crash
        LD      A,FN_RUN_TARGET
        LD      (COMBUF),A
        JP      RETURN_REGS             ;DUMP REGS, ENTER MONITOR
;
;===========================================================================
;  Get a character to A
;
;  Return A=char, CY=0 if data received
;         CY=1 if timeout (0.5 seconds)
;
;  Uses 6 bytes of stack including return address
;
GETCHAR:
        PUSH    BC
        PUSH    DE

        LD      DE,0x08000               ;long timeout
        LD      BC,SERIAL_STATUS         ;status reg. for loop
GC10:   DEC     DE
        LD      A,D
        OR      E
        JR      Z,GC90                  ;exit if timeout

        IN      A,(C)                   ;read device status
        BIT     RXRDY,A
        JR      Z,GC10                  ;not ready yet.
;
;  Data received:  return CY=0. data in A
        XOR     A                       ;CY=0
        LD      BC,SERIAL_DATA
        IN      A,(C)                   ;read data
        POP     DE
        POP     BC
        RET
;
;  Timeout:  return CY=1
GC90:   SCF                             ;cy=1
        POP     DE
        POP     BC
        RET
;
;===========================================================================
;  Output character in A
;
;  Uses 6 bytes of stack including return address
;
PUTCHAR:
        PUSH    BC                      ;save:  used for I/O address
        PUSH    AF                      ;save byte to output
        LD      BC,SERIAL_STATUS        ;status reg. for loop
PC10:
   if Z84C15
        ;Reset the watchdog timer (if someone enables it)
        LD      A,0x4E                   ;code to clear watch dog timer
        LD      BC,WDTCR
        OUT     (C),A                   ;watch dog timer command reg.
        LD      BC,SERIAL_STATUS
   endif

        IN      A,(C)                   ;read device status
        BIT     TXRDY,A                 ;RX READY ?
        JR      Z,PC10

        POP     AF
        LD      BC,SERIAL_DATA
        OUT     (C),A                   ;transmit char

        POP     BC
        RET
;
;===========================================================================
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:   .db      0                       ;2: PROCESSOR TYPE = Z80
        .db      NOICE_COMBUF_SIZE             ;3: SIZE OF COMMUNICATIONS BUFFER
        .db      0                       ;4: NO OPTIONS
        .dw      0                       ;5,6: BOTTOM OF PAGED MEM (none)
        .dw      0                       ;7,8: TOP OF PAGED MEM (none)
        .db      B1-B0                   ;9 BREAKPOINT INSTRUCTION LENGTH
B0:     RST     0x08                     ;10+ BREAKPOINT INSTRUCTION
B1:
  if Z80
        .db      "NoICE Z80 monitor V3.1",0              ;DESCRIPTION, ZERO
  endif

  if Z180
        .db      "Z180 Evaluation board monitor V3.1",0  ;DESCRIPTION, ZERO
  endif

  if Z84C15
        .db      "Z84C15 Eval board monitor V3.1",0 ;DESCRIPTION, ZERO
  endif
TSTG_SIZE       =     $-TSTG          ;SIZE OF STRING
;
;===========================================================================
;  HARDWARE PLATFORM INDEPENDENT EQUATES AND CODE
;
;  Communications function codes.
FN_GET_STATUS   =     0x0FF    ;reply with device info
FN_READ_MEM     =     0x0FE    ;reply with data
FN_WRITE_MEM    =     0x0FD    ;reply with status (+/-)
FN_READ_REGS    =     0x0FC    ;reply with registers
FN_WRITE_REGS   =     0x0FB    ;reply with status
FN_RUN_TARGET   =     0x0FA    ;reply (delayed) with registers
FN_SET_BYTES    =     0x0F9    ;reply with data (truncate if error)
FN_IN           =     0x0F8    ;input from port
FN_OUT          =     0x0F7    ;output to port
;
FN_MIN          =     0x0F0    ;MINIMUM RECOGNIZED FUNCTION CODE
FN_ERROR        =     0x0F0    ;error reply to unknown op-code
;
;===========================================================================
;  Enter here via RST nn for breakpoint:  AF, PC are stacked.
;  Enter with A=interrupt code = processor state
;  Interrupt status is not changed from user program and IFF2==IFF1
INT_ENTRY:
;
;  Interrupts may be on:  get IFF as quickly as possible, so we can DI
        LD      (REG_STATE),A   ;save entry state
        LD      (REG_HL),HL     ;SAVE HL
        LD      A,I             ;GET P FLAG = IFF2 (SIDE EFFECT)
        DI                      ;NO INTERRUPTS ALLOWED
;
        LD      (REG_I),A       ;SAVE INT REG
        LD      A,0
        JP      PO,BREAK10      ;JIF PARITY ODD (FLAG=0)
        INC     A               ;ELSE SET A = FLAG = 1 (ENABLED)
BREAK10: LD     (REG_IFF),A     ;SAVE INTERRUPT FLAG
;
;  Save registers in reg block for return to master
        POP     HL              ;GET FLAGS IN L, ACCUM IN H
        LD      (REG_AF),HL     ;SAVE A AND FLAGS
;
;  If entry here was by breakpoint (state=1), then back up the program
;  counter to point at the breakpoint/RST instruction.  Else leave PC alone.
;  (If CALL is used for breakpoint, then back up by 3 bytes)
        POP     HL              ;GET PC OF BREAKPOINT/INTERRUPT
        LD      A,(REG_STATE)
        CP      1
        JR      NZ,NOTBP        ;JIF NOT A BREAKPOINT
        DEC     HL              ;BACK UP PC TO POINT AT BREAKPOINT
NOTBP:  JP      ENTER_MON       ;HL POINTS AT BREAKPOINT OPCODE
;
;===========================================================================
;  Main loop:  wait for command frame from master
MAIN:   LD      SP,MONSTACK             ;CLEAN STACK IS HAPPY STACK
        LD      HL,COMBUF               ;BUILD MESSAGE HERE
;
;  First byte is a function code
        CALL    GETCHAR                 ;GET A FUNCTION (uses 6 bytes of stack)
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        CP      FN_MIN
        JR      C,MAIN                  ;JIF BELOW MIN: ILLEGAL FUNCTION
        LD      (HL),A                  ;SAVE FUNCTION CODE
        INC     HL
;
;  Second byte is data byte count (may be zero)
        CALL    GETCHAR                 ;GET A LENGTH BYTE
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        CP      NOICE_COMBUF_SIZE+1
        JR      NC,MAIN                 ;JIF TOO LONG: ILLEGAL LENGTH
        LD      (HL),A                  ;SAVE LENGTH
        INC     HL
        OR      A
        JR      Z,MA80                  ;SKIP DATA LOOP IF LENGTH = 0
;
;  Loop for data
        LD      B,A                     ;SAVE LENGTH FOR LOOP
MA10:   CALL    GETCHAR                 ;GET A DATA BYTE
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        LD      (HL),A                  ;SAVE DATA BYTE
        INC     HL
        DJNZ    MA10
;
;  Get the checksum
MA80:   CALL    GETCHAR                 ;GET THE ChECKSUM
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        LD      C,A                     ;SAVE ChECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
        CALL    ChECKSUM
        ADD     A,C
        JR      NZ,MAIN                 ;JIF BAD ChECKSUM
;
;  Process the message.
        LD      A,(COMBUF+0)            ;GET THE FUNCTION CODE
        CP      FN_GET_STATUS
        JP      Z,TARGET_STATUS
        CP      FN_READ_MEM
        JP      Z,READ_MEM
        CP      FN_WRITE_MEM
        JP      Z,WRITE_MEM
        CP      FN_READ_REGS
        JP      Z,READ_REGS
        CP      FN_WRITE_REGS
        JP      Z,WRITE_REGS
        CP      FN_RUN_TARGET
        JP      Z,RUN_TARGET
        CP      FN_SET_BYTES
        JP      Z,SET_BYTES
        CP      FN_IN
        JP      Z,IN_PORT
        CP      FN_OUT
        JP      Z,OUT_PORT
;
;  Error: unknown function.  Complain
        LD      A,FN_ERROR
        LD      (COMBUF+0),A    ;SET FUNCTION AS "ERROR"
        LD      A,1
        JP      SEND_STATUS     ;VALUE IS "ERROR"

;===========================================================================
;
;  Target Status:  FN, len
;
TARGET_STATUS:
;
        LD      HL,TSTG                 ;DATA FOR REPLY
        LD      DE,COMBUF+1             ;RETURN BUFFER
        LD      BC,TSTG_SIZE            ;LENGTH OF REPLY
        LD      A,C
        LD      (DE),A                  ;SET SIZE IN REPLY BUFFER
        INC     DE
        LDIR                            ;MOVE REPLY DATA TO BUFFER
;
;  Compute checksum on buffer, and send to master, then return
        JP      SEND

;===========================================================================
;
;  Read Memory:  FN, len, page, Alo, Ahi, Nbytes
;
READ_MEM:
;
;  Set page
;;      LD      A,(COMBUF+2)
;;      LD      (PAGEIMAGE),A
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A
;
;  Get address
        LD      HL,(COMBUF+3)
        LD      A,(COMBUF+5)            ;NUMBER OF BYTES TO GET
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        LD      DE,COMBUF+1             ;POINTER TO LEN, DATA
        LD      (DE),A                  ;RETURN LENGTH = REQUESTED DATA
        INC     DE
        OR      A
        JR      Z,GLP90                 ;JIF NO BYTES TO GET
;
;  Read the requested bytes from local memory
        LD      B,A
GLP:    LD      A,(HL)                  ;GET BYTE TO A
        LD      (DE),A                  ;STORE TO RETURN BUFFER
        INC     HL
        INC     DE
        DJNZ    GLP
;
;  Compute checksum on buffer, and send to master, then return
GLP90:  JP      SEND

;===========================================================================
;
;  Write Memory:  FN, len, page, Alo, Ahi, (len-3 bytes of Data)
;
;  Uses 2 bytes of stack
;
WRITE_MEM:
;
;  Set page
;;      LD      A,(COMBUF+2)
;;      LD      (PAGEIMAGE),A
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A
;
        LD      HL,COMBUF+5             ;POINTER TO SOURCE DATA IN MESSAGE
        LD      DE,(COMBUF+3)           ;POINTER TO DESTINATION
        LD      A,(COMBUF+1)            ;NUMBER OF BYTES IN MESSAGE
        SUB     3                       ;LESS PAGE, ADDRLO, ADDRHI
        JR      Z,WLP50                 ;EXIT IF NONE REQUESTED
;
;  Write the specified bytes to local memory
        LD      B,A
        PUSH    BC                      ;SAVE BYTE COUNTER
WLP10:  LD      A,(HL)                  ;BYTE FROM HOST
        LD      (DE),A                  ;WRITE TO TARGET RAM
        INC     HL
        INC     DE
        DJNZ    WLP10
;
;  Compare to see if the write worked
        LD      HL,COMBUF+5             ;POINTER TO SOURCE DATA IN MESSAGE
        LD      DE,(COMBUF+3)           ;POINTER TO DESTINATION
        POP     BC                      ;SIZE AGAIN
;
;  Compare the specified bytes to local memory
WLP20:  LD      A,(DE)                  ;READ BACK WHAT WE WROTE
        CP      (HL)                    ;COMPARE TO HOST DATA
        JR      NZ,WLP80                ;JIF WRITE FAILED
        INC     HL
        INC     DE
        DJNZ    WLP20
;
;  Write succeeded:  return status = 0
WLP50:  XOR     A                       ;RETURN STATUS = 0
        JR      WLP90
;
;  Write failed:  return status = 1
WLP80:  LD      A,1
;
;  Return OK status
WLP90:  JP      SEND_STATUS

;===========================================================================
;
;  Read registers:  FN, len=0
;
READ_REGS:
;
;  Enter here from int after "RUN" and "STEP" to return task registers
RETURN_REGS:
        LD      HL,TASK_REGS            ;REGISTER LIVE HERE
        LD      A,TASK_REGS_SIZE        ;NUMBER OF BYTES
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        LD      DE,COMBUF+1             ;POINTER TO LEN, DATA
        LD      (DE),A                  ;SAVE DATA LENGTH
        INC     DE
;
;  Copy the registers
        LD      B,A
GRLP:   LD      A,(HL)                  ;GET BYTE TO A
        LD      (DE),A                  ;STORE TO RETURN BUFFER
        INC     HL
        INC     DE
        DJNZ    GRLP
;
;  Compute checksum on buffer, and send to master, then return
        JP      SEND

;===========================================================================
;
;  Write registers:  FN, len, (register image)
;
WRITE_REGS:
;
        LD      HL,COMBUF+2             ;POINTER TO DATA
        LD      A,(COMBUF+1)            ;NUMBER OF BYTES
        OR      A
        JR      Z,WRR80                 ;JIF NO REGISTERS
;
;  Copy the registers
        LD      DE,TASK_REGS            ;OUR REGISTERS LIVE HERE
        LD      B,A
WRRLP:  LD      A,(HL)                  ;GET BYTE TO A
        LD      (DE),A                  ;STORE TO REGISTER RAM
        INC     HL
        INC     DE
        DJNZ    WRRLP
;
;  Return OK status
WRR80:  XOR     A
        JP      SEND_STATUS

;===========================================================================
;
;  Run Target:  FN, len
;
;  Uses 4 bytes of stack
;
RUN_TARGET:
;
;  Restore user's page
;;      LD      A,(REG_PAGE)
;;      LD      (PAGEIMAGE),A
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A
;
;  Restore alternate registers
        LD      HL,(REG_AFX)
        PUSH    HL
        POP     AF
        EX      AF,AF'                  ;LOAD ALTERNATE AF
        ;
        LD      HL,(REG_HLX)
        LD      BC,(REG_BCX)
        LD      DE,(REG_DEX)
        EXX                             ;LOAD ALTERNATE REGS
;
;  Restore main registers
        LD      BC,(REG_BC)
        LD      DE,(REG_DE)
        LD      IX,(REG_IX)
        LD      IY,(REG_IY)
        LD      A,(REG_I)
        LD      I,A
;
;  Switch to user stack
        LD      HL,(REG_PC)             ;USER PC
        LD      SP,(REG_SP)             ;BACK TO USER STACK
        PUSH    HL                      ;SAVE USER PC FOR RET
        LD      HL,(REG_AF)
        PUSH    HL                      ;SAVE USER A AND FLAGS FOR POP
        LD      HL,(REG_HL)             ;USER HL
;
;  Restore user's interrupt state
        LD      A,(REG_IFF)
        OR      A
        JR      Z,RUTT10                ;JIF INTS OFF: LEAVE OFF
;
;  Return to user with interrupts enabled
        POP     AF
        EI                              ;ELSE ENABLE THEM NOW
        RET
;
;  Return to user with interrupts disabled
RUTT10: POP     AF
        RET
;
;===========================================================================
;
;  Common continue point for all monitor entrances
;  HL = user PC, SP = user stack
;  REG_STATE has current state, REG_HL, REG_I, REG_IFF, REG_AF set
;
;  Uses 2 bytes of stack
;
ENTER_MON:
        LD      (REG_SP),SP     ;SAVE USER'S STACK POINTER
        LD      SP,MONSTACK     ;AND USE OURS INSTEAD
;
        LD      (REG_PC),HL
        LD      (REG_BC),BC
        LD      (REG_DE),DE
        LD      (REG_IX),IX
        LD      (REG_IY),IY
;
;  Get alternate register set
        EXX
        LD      (REG_HLX),HL
        LD      (REG_BCX),BC
        LD      (REG_DEX),DE
        EX      AF,AF'
        PUSH    AF
        POP     HL
        LD      (REG_AFX),HL
;
;;      LD      A,(PAGEIMAGE)   ;GET CURRENT USER PAGE
        XOR     A               ;...OR NONE IF UNPAGED TARGET
        LD      (REG_PAGE),A    ;SAVE USER PAGE
;
;  Return registers to master
        JP      RETURN_REGS

;===========================================================================
;
;  Set target byte(s):  FN, len { (page, alow, ahigh, data), (...)... }
;
;  Return has FN, len, (data from memory locations)
;
;  If error in insert (memory not writable), abort to return short data
;
;  This function is used primarily to set and clear breakpoints
;
;  Uses 2 bytes of stack
;
SET_BYTES:
;
        LD      HL,COMBUF+1
        LD      B,(HL)                  ;LENGTH = 4*NBYTES
        INC     HL
        INC     B
        DEC     B
        LD      C,0                     ;C GETS COUNT OF INSERTED BYTES
        JR      Z,SB90                  ;JIF NO BYTES (C=0)
        PUSH    HL
        POP     IX                      ;IX POINTS TO RETURN BUFFER
;
;  Loop on inserting bytes
SB10:   LD      A,(HL)                  ;MEMORY PAGE
        INC     HL
;;      LD      (PAGEIMAGE),A
;;      PUSH    BC
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A                  ;SET PAGE
;;      POP     BC
        LD      E,(HL)                  ;ADDRESS TO DE
        INC     HL
        LD      D,(HL)
        INC     HL
;
;  Read current data at byte location
        LD      A,(DE)                  ;READ CURRENT DATA
        LD      (IX),A                  ;SAVE IN RETURN BUFFER
        INC     IX
;
;  Insert new data at byte location
        LD      A,(HL)
        LD      (DE),A                  ;SET BYTE
        LD      A,(DE)                  ;READ IT BACK
        CP      (HL)                    ;COMPARE TO DESIRED VALUE
        JR      NZ,SB90                 ;BR IF INSERT FAILED: ABORT
        INC     HL
        INC     C                       ;ELSE COUNT ONE BYTE TO RETURN
;
        DEC     B
        DEC     B
        DEC     B
        DJNZ    SB10                    ;LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
SB90:   LD      A,C
        LD      (COMBUF+1),A            ;SET COUNT OF RETURN BYTES
;
;  Compute checksum on buffer, and send to master, then return
        JP      SEND

;===========================================================================
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
IN_PORT:
;
;  Get port address
        LD      BC,(COMBUF+2)
;
;  Read port value
        IN      A,(C)           ;IN WITH A15-A8 = B; A7-A0 = C
;
;  Return byte read as "status"
        JP      SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
OUT_PORT:
;
;  Get port address
        LD      BC,(COMBUF+2)
;
;  Get data
        LD      A,(COMBUF+4)
;
;  Write value to port
        OUT     (C),A           ;OUT WITH A15-A8 = B; A7-A0 = C
;
;  Return status of OK
        XOR     A
        JP      SEND_STATUS
;
;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
        LD      (COMBUF+2),A            ;SET STATUS
        LD      A,1
        LD      (COMBUF+1),A            ;SET LENGTH
        JR      SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
;  Uses 6 bytes of stack (not including return address: jumped, not called)
;
SEND:   CALL    ChECKSUM                ;GET A=ChECKSUM, HL->checksum location
        NEG
        LD      (HL),A                  ;STORE NEGATIVE OF ChECKSUM
;
;  Send buffer to master
        LD      HL,COMBUF               ;POINTER TO DATA
        LD      A,(COMBUF+1)            ;LENGTH OF DATA
        ADD     A,3                     ;PLUS FUNCTION, LENGTH, ChECKSUM
        LD      B,A                     ;save count for loop
SND10:  LD      A,(HL)
        CALL    PUTCHAR                 ;SEND A BYTE (uses 6 bytes of stack)
        INC     HL
        DJNZ    SND10
        JP      MAIN                    ;BACK TO MAIN LOOP

;===========================================================================
;  Compute checksum on COMBUF.  COMBUF+1 has length of data,
;  Also include function byte and length byte
;
;  Returns:
;       A = checksum
;       HL = pointer to next byte in buffer (checksum location)
;       B is scratched
;
;  Uses 2 bytes of stack including return address
;
ChECKSUM:
        LD      HL,COMBUF               ;pointer to buffer
        LD      A,(COMBUF+1)            ;length of message
        ADD     A,2                     ;plus function, length
        LD      B,A                     ;save count for loop
        XOR     A                       ;init checksum to 0
ChK10:  ADD     A,(HL)
        INC     HL
        DJNZ    ChK10                   ;loop for all
        RET                             ;return with checksum in A
;
;===========================================================================
;  Hardware initialization table
INIOUT:
;
;-----------------------------------------------------------------------
  if Z80
;  TODO Initialization table for generic Z80 is up to your hardware...
        .db      port_address, init_data
        .db      port_address, init_data
        ...
        .db      port_address, init_data
  endif
;
;-----------------------------------------------------------------------
;  Initialization table for Z84C15
  if Z84C15
        ;
        ; SET UP WAIT STATE CONTOL REGISTER FIRST.  THE FOLLOWING WAIT STATES
        ; WILL BE INSERTED: INTERRUPT =0, INTERRUPT VECTOR=0, OPCODE FETCH=1,
        ; SRAM ACCESS=3 AND I/O=0.  EPROM AND SRAM MUST BE 100Nsec FOR 0 WAIT.
;;      .db      SCRP_REG        ;SYSTEM CONTROL REG. POINTER
;;      .db      00              ;ACCESS TO WAIT STATE CONTROL REG.
;;      .db      SCDP_REG        ;SYSTEM CONTROL DATA PORT
;;      .db      00011100B
        ;       00              ;no wait for interrupt ACK
        ;         0             ;no wait for interrupt vector
        ;          1            ;one extra wait for opcode fetch
        ;           11          ;three waits for memory
        ;             00        ;no wait for I/O

        ;THE WATCH DOG TIMER IS DISABLED AND THE Z84C15 PUT INTO "RUN" MODE.
        ;THIS IS A TWO STEP PROCESS
        .db      WDTMR           ;WATCH DOG TIMER MASTER REGISTER ADDR.
        .db      00000000B       ;RESET WT ENABLE BIT
        .db      WDTCR           ;WATCH DOG TIMER COMMAND REG.
        .db      0x0B1            ;SECOND KEY TO DISABLE THE WDT.
        .db      WDTCR           ;WATCH DOG TIMER COMMAND REG.
        .db      0x4E             ;CLEAR WATCH DOG TIMER
        .db      WDTCR           ;WDT COMMAND REG.
        .db      0x0DB            ;ALLOW ChANGE TO "HALTM" FIELD
        .db      WDTMR           ;WDT MASTER REG.
        .db      00011011B       ;RUN MODE

        ;  SET WAIT STATE GENERATOR TO INSERT WAIT STATES FOR ALL OF MEMORY
        .db      SCRP_REG        ;SYSTEM CONTROL REG. POINTER
        .db      0x01             ;ACCESS THE WAIT BOUNDARY REGISTER
        .db      SCDP_REG        ;SYSTEM CONTROL DATA PORT
        .db      11110000B
        ;       1111            ;high wait boundary (top of mem)
        ;           0000        ;low wait boundary (bottom of mem)

        ; THE ChIP SELECT BOUNDRY REGISTER (CSBR) DETERMINES WHICH ADDRESS
        ; RANGE GETS /CS0 AND WHICH RANGE GETS /CS1. THE EPROM is 32K ON CS0
        ; AND THE SRAM IS 32K ON /CS1.
        .db      SCRP_REG        ;SYSTEM CONTROL REG. POINTER
        .db      0x02             ;ACCESS THE ChIP SELECT BOUNDRY REG.
        .db      SCDP_REG        ;SYSTEM CONTROL DATA PORT
        .db      11110111B
        ;       1111            ;range for CS1: CS0+ to Fxxx
        ;           0111        ;range for CS0: 0xxx to 7xxx

        ; SYSTEM CONTROL REGISTER POINTER #3 IS THE MISC. CONTROL REGISTER
        ; (MCR).  WE WILL SET THE CLOCK TO DIVIDE BY 2 MODE, DISABLE THE
        ; RESET OUTPUT, NORMAL CRC (16 BIT), ENABLE /CS0 & /CS1.
        .db      SCRP_REG        ;SYSTEM CONTROL REG. POINTER
        .db      0x03             ;ACCESS MISC. CONTROL REG.
        .db      SCDP_REG        ;SYSTEM CONTROL DATA PORT
        .db      00001011B
        ;       000             ;should be zeros
        ;          0            ;divide by 2
        ;           1           ;disable reset output
        ;            0          ;16 bit CRC
        ;             1         ;enable CS1
        ;              1        ;enable CS0

        ; SET UP COUNTER/TIMER ONE TO PRODUCE BAUD RATE FOR SERIAL I/O.
        ; THE FIRST SETS UP THE TIMER SO THAT A CLK JUMPED TO THE CLK/TRG1
        ; PIN IS NOT NEEDED.  THE OTHERS USE THE COUNTER AND MUST HAVE THE
        ; JUMP FROM CLKOUT TO CLK/TRG1.  SEVERAL VALUES ARE PROVIDED.
        ; COMMENT OUT THE ONES THAT ARE NOT NEEDED.
        .db      CTC_1           ;ADDR. OF CTC ChANNEL 1
        .db      00000011B
        ;       0               ;no int
        ;        0              ;select timer, not counter
        ;         0             ;prescale by 16
        ;          0            ;clock on falling edge (not used)
        ;           0           ;auto trigger
        ;            0          ;no TC follows
        ;             1         ;software reset
        ;              1        ;control word

        .db      CTC_1           ;ADDR. OF CTC ChANNEL 1
        .db      00010101B
        ;       0               ;no int
        ;        0              ;select timer, not counter
        ;         0             ;prescale by 16
        ;          1            ;clock on rising edge (not used)
        ;           0           ;auto trigger
        ;            1          ;TC follows
        ;             0         ;operate
        ;              1        ;control word

        ; CPU crystal is 19.6608 Mhz, for a CPU speed of 9.8304 Mhz
        ; prescale by 16 = timer input of 614400 Hz
        ; divisor for baud rate N is 614400/(16*N)
        .db      CTC_1           ;ADDR.  OF CTC ChANNEL 1
;;;     .db      1               ;38400 baud: TC = 1
        .db      2               ;19200 baud: TC = 2
;;;     .db      4               ;9600  baud: TC = 4
;;;     .db      16              ;2400  baud: TC = 16

        ; SIO ChANNEL B INITIALIZATION.  SIO_BC IS THE SIO ChANNEL B CONTROL
        ; REGISTER AT 0x1B.  THIS IS THE SAME THING AS WRITE REGISTER 0 IN A
        ; STAND ALONE SIO.
        .db      SIO_BC          ;ADDR. OF SIO_BC
        .db      4               ;SELECT WR4 OF SIO_B
        .db      SIO_BC          ;ADDR. OF SIO_BC
        .db      01000100B
        ;       01              ;16X
        ;         00            ;8 bit sync (ignored)
        ;           01          ;1 stop bit
        ;             0         ;parity odd (ignored)
        ;              0        ;no parity

        ;SIO B RX
        .db      SIO_BC          ;ADDRESS OF SIO_BC CMD
        .db      3               ;SELECT WR3 OF SIO_B
        .db      SIO_BC          ;ADRESS OF SIO_BC CMD
        .db      11000001B
        ;       11              ;8 bit receive
        ;         0             ;no auto enable
        ;          0            ;no hunt
        ;           0           ;no RxCRC
        ;            0          ;no SDLC address search
        ;             0         ;no sync char load inhibit
        ;              1        ;enable receiver

        ;SIO B TX
        .db      SIO_BC          ;ADDR. OF SIO_BC CMD
        .db      5               ;SELECT WR5 OF SIO_B
        .db      SIO_BC          ;ADDR. OF SIO_BC CMD
        .db      01101000B
        ;       0               ;DTR off (high)
        ;        11             ;8 bit transmit
        ;          0            ;no break
        ;           1           ;enable transmitter
        ;            0          ;CRC 16 (ignored)
        ;             0         ;RTS off (high)
        ;              0        ;disable TX CRC

        .db      SIO_BC          ;ADDR. OF SIO B CMD
        .db      1               ;SELECT WR1
        .db      SIO_BC          ;ADDR OF SIO B CMD
        .db      00000100B
        ;       0               ;disable wait/ready
        ;        0              ;wait function (ignored)
        ;         0             ;wait on receive (ignored)
        ;          00           ;disable all RX interrupts
        ;            1          ;status affects vector (if ints enabled)
        ;             0         ;disable transmit interrupt
        ;              0        ;disable external/status int
  endif
;
;-----------------------------------------------------------------------
;  Initialization table for Z180
  if Z180
        .db      dcntl           ;set wait state
        .db      01000000b
        ;       01              mem - 1 wait
        ;         00            i/o - 0 wait
        ;           0000        dreq, i/o mem select = default

        .db      rcr             ;set refresh
        .db      00111100b       ;refresh disabled - no DRAM!

        .db      omcr            ;set operation mode
        .db      01011111b
        ;       0               m1 disabled - z mode of operation
        ;        1              m1 pulse not needed
        ;         0             i/o timing = z80 compatible
        ;          11111        same as default

        .db      itc             ;itc - enable only int0
        .db      00000001b       ;clear trap/ufo bit

        if scc_com
                .db      scc_bc
                .db      0x09             ;select WR9
                .db      scc_bc
                .db      11000000b       ;make sure its in reset

                .db      scc_bc
                .db      0x04             ;select WR4
                .db      scc_bc
                .db      01001100b       ;
                ;       01               X16 clock
                ;         00             X care
                ;           11           2 stop
                ;             00         parity disable

                .db      scc_bc
                .db      0x03             ;select WR3
                .db      scc_bc
                .db      11000000b       ;
                ;       11               8bits/char
                ;         0              auto enable off
                ;          0000          doesn't matter
                ;              0         Rx disable at this moment

                .db      scc_bc
                .db      0x05             ;select WR5
                .db      scc_bc
                .db      11100010b       ;
                ;       1                set DTR=0
                ;        11              8bits/char
                ;          0             Not send break
                ;           0            Tx disable at this moment
                ;            0 0         Doesn't matter
                ;             1          RTS=0

                .db      scc_bc
                .db      0bh             ;select WR11
                .db      scc_bc
                .db      01010110b       ;
                ;       0                No xtal
                ;        1010            TxC,RxC from BRG
                ;            110         TRxC = BRG output

                ; CPU crystal is 19.6608 Mhz, for a CPU speed of 9.8304 Mhz
                ; divisor for baud rate N is 9830400/(32*N)
                ; register value is divisor minus 2
                .db      scc_bc
                .db      0ch             ;select WR12
                .db      scc_bc
;;;;            .db      8-2             ;BR TC Low (38400 baud)
                .db      16-2            ;BR TC Low (19200 baud)
;;;;            .db      32-2            ;BR TC Low (9600 baud)
;;;;            .db      256-2           ;BR TC Low (1200 baud)

                .db      scc_bc
                .db      0dh             ;select WR12
                .db      scc_bc
                .db      0x00             ;BR TC high

                .db      scc_bc
                .db      0eh             ;select WR14
                .db      scc_bc
                .db      00000010b       ;
                ;       000              nothing about DPLL
                ;          00            No local echo/loopback
                ;            0           DTR/REQ is DTR
                ;             1          BRG source = PCLK
                ;              0         Not enabling BRG yet

                .db      scc_bc
                .db      0x03             ;select WR3
                .db      scc_bc
                .db      11000001b       ;
                ;       11               8bits/char
                ;         0              auto enable off
                ;          0000          doesn't matter
                ;              1         Rx enable

                .db      scc_bc
                .db      0x05             ;select WR5
                .db      scc_bc
                .db      11101011b       ;
                ;       1                set DTR=0
                ;        11              8bits/char
                ;          0             Not send break
                ;           1            Tx enable
                ;            0 0         Doesn't matter
                ;             1          RTS=0

                .db      scc_bc
                .db      0eh             ;select WR14
                .db      scc_bc
                .db      00000011b       ;
                ;       000              nothing about DPLL
                ;          00            No local echo/loopback
                ;            0           DTR/REQ is DTR
                ;             1          BRG source = PCLK
                ;              1         Enable BRG

        else
                .db      cntla0          ;asci0
                .db      01100100b       ;no-mp, tx/rx enable, /rts=0
                                        ;ef reset, 8bit np 1stop

                .db      cntlb0          ;asci0
                .db      00100001b       ;
                ;       00              not mp mode
                ;         1             ps=1 (/30 mode)
                ;          0            parity/ doesn't matter!
                ;           0           x16 sampling rate
                ;            001        divide ratio - /2

        endif
;
  endif
;-------------------------------------------------------------------------
OUTCNT  =     ($-INIOUT)/2    ; NUMBER OF INITIALIZING PAIRS

        END     RESET



                .area   CODE_VEC (CON, ABS)

;===========================================================================
; The blitter forces all memory reads to come from F FFxx at boot time which
; will map to the "MOS" ROM i.e. here
; we need to quickly initialise the NMI handler and the disable boot mode
; and jump to the real MOS address i.e. F C000 - F F000
; 
; We can be sure this is a "real" reset i.e. not a RST0 or TRAP 
;

RESET_0_0000:             
                di

                ; setup a catch-all NMI to just do RETN - a real one will be
                ; set up in the main code
                ld      bc,0x45ED
                ld      (0x66),bc

; at this point the CPU thinks it is running at 0 0000 do a jump to get the PC
; correct
                jp      RESET_0_FFxx

RESET_0_FFxx:

;===========================================================================
; we now need to set the MMU to how we want it:
; on the z180 we need to map the MOS ROM into the top bank

; first set banking boundaries, for this test we'll map: 
; ChipRAM                       0..2FFF (Common Area 0)
; SysRAM/screen                 3000..C000 (Banked Area)
; the MOS ROM at                C000 (Common Area 1)

                ld      a,0xC3
                out0    (CBAR),a

; and we'll map CAR0 => 0 0000
;               BAR  => F xxxx
;               CAR1 => F xxxx

                ld      a,0xF0
                out0    (BBR),a

                ld      a,0xF0
                out0    (CBR),a

; now disable Blitter's "boot mode" and start executing from MOS rom as mapped 
; above

; we are now running in ROM and can disable the boot mapping by writing to FCFF

                ld      a,JIM_DEVNO_BLITTER
                ld      bc,fred_JIM_DEVNO
                out     (c),a

                jp      INIT




