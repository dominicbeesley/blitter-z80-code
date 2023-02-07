	.list(me,meb)

;  Adapted from MONZ80.asm - Z80 Debug monitor for use with NoICEZ80
;  This file may be assembled with the asz80 assembler
;
;  Copyright (c) 2018 by John Hartman
;  Copyright (c) 2023 by Dominic Beesley
;
;  Modification History:
;	14-Jun-93 JLH release version
;	24-Aug-93 JLH bad constant for COMBUF length compare
;	 8-Nov-93 JLH change to use RST 8 for breakpoint, not RST 38 (v1.3)
;	20-Dec-93 JLH bug in NMI dummy vectors: overwrote NMI and NOICE_RESET!
;	17-Oct-95 JLH eliminate two-arg for SUB, AND, OR, XOR, and CP
;	21-Jul-00 JLH change FN_MIN from F7 to F0
;	12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;	11-Jan-05 JLH V3.1: correct bug in Z180 NOICE_RESET/illegal op-code trap
;	12-Nov-18 JLH modify to assemble with Arnold's as
;	31-Jan-23 .db  modify for asz180 and to run on the Blitter+z180 platform
;

; The following symbols must/should be defined before including this file **DEFAULT**
; Z180_INTERNAL_BASE - **0** - the base I/O address for internal peripherals
; NOICE_INITSTACK - the default value for the user's stack pointer
; NOICE_DO_VECTORS - when defined the vectors will be setup in the NOICE_INIT routine
;        Note: the NMI and NOICE_RESET vectors are always set up in NOICE_INIT
; NOICE_DO_HW_SETUP - when defined the hardware setup is performed in NOICE_INIT including
; 	setting the interrupt mode to im2 (exepects int0 at IM2_INT0_VEC) 
; NOICE_DO_COMMS_SETUP - when defined the serial hardware setup is performed in NOICE_INIT setting
;	the serial port up on ASCI0 at 38400 baud
; NOICE_DO_ENTER_MON - when defined you should JP to NOICE_INIT which will set up the
;	vectors (and optionally hardware) then enter the monitor otherwise you must
;	have alread set up a stack and should CALL NOICE_INIT which will set up the 
;	vectors (and optionally hardware) and return


; TODO: keep this harmonized with the version in ../NoIce/lib - the .include relative
; path handling in asxxxx is idiotic and makes it very difficult to share files between
; projects!

		.include	"../../includes/hardware.inc"
		.include	"../includes/hardware-z180.inc"
		.hd64			; z180 instruction set

		.area NOICE_DATA(ABS,CON,DSEG)
;
;  Monitor stack
;  (Calculated use is at most 6 bytes.	Leave plenty of spare)
		.ds	 16
MONSTACK:
;
;  Target registers:  order must match that in TRGZ80.C
TASK_REGS:
REG_STATE:	.ds	 1
REG_PAGE:	.ds	 1
REG_SP:		.ds	 2
REG_IX:		.ds	 2
REG_IY:		.ds	 2
REG_HL:		.ds	 2
REG_BC:		.ds	 2
REG_DE:		.ds	 2
REG_AF:				;LABEL ON FLAGS, A AS A WORD
REG_FLAGS:	.ds	 1
REG_A:		.ds	 1
REG_PC:		.ds	 2
REG_I:		.ds	 1
REG_IFF:	.ds	 1
 ;
REG_HLX:	.ds	 2	;ALTERNATE REGISTER SET
REG_BCX:	.ds	 2
REG_DEX:	.ds	 2
REG_AFX:			;LABEL ON FLAGS, A AS A WORD
REG_FLAGSX:	.ds	 1
REG_AX:		.ds	 1
TASK_REGS_SIZE	=     .-TASK_REGS

;
;  Communications buffer
;  (Must be at least as long as TASK_REG_SIZE.	Larger values may improve
;  speed of NoICE memory load and dump commands)
COMBUF:		.ds	 2+NOICE_COMBUF_SIZE+1 ;BUFFER ALSO HAS FN, LEN, AND ChECK
;

DEBUG_SERIAL:	.ds	1	; toggles when there's a serial error

RAM_END:			;ADDRESS OF TOP+1 OF RAM





		.area NOICE_CODE(REL, CON)


;===========================================================================
;
;  Default handlers for RST and NMI.  This code is moved to the beginning
;  of RAM
;
DEFAULT_INTS:
;
;  RST 0
R0:	DI
	JP	NOICE_RESET
	NOP
	NOP
	NOP
	NOP

	.ifdef NOICE_DO_VECTORS

;
;  RST 8
	PUSH	AF
;;	LD	A,3			;STATE = 3 (INTERRUPT 8);  (vectored only if not used for breakpoint)
	LD	A,1			; Break point instruction!
	JP	NOICE_INT_ENTRY
	NOP
	NOP
;
;  RST 0x10
	PUSH	AF
	LD	A,4			;STATE = 4 (INTERRUPT 10)
	JP	NOICE_INT_ENTRY
	NOP
	NOP
;
;  RST 0x18
	PUSH	AF
	LD	A,5			;STATE = 5 (INTERRUPT 18)
	JP	NOICE_INT_ENTRY
	NOP
	NOP
;
;  RST 0x20
	PUSH	AF
	LD	A,6			;STATE = 6 (INTERRUPT 20)
	JP	NOICE_INT_ENTRY
	NOP
	NOP
;
;  RST 0x28
	PUSH	AF
	LD	A,7			;STATE = 7 (INTERRUPT 28)
	JP	NOICE_INT_ENTRY
	NOP
	NOP
;
;  RST 0x30
	PUSH	AF
	LD	A,8			;STATE = 8 (INTERRUPT 30)
	JP	NOICE_INT_ENTRY
	NOP
	NOP
;
;  RST 0x38
	PUSH	AF
	LD	A,9			;STATE = 9 (INTERRUPT 38)
	JP	NOICE_INT_ENTRY

	.endif

DEFAULT_INTS_SIZE      = .-DEFAULT_INTS

	.ifdef NOICE_DO_VECTORS

DEFAULT_IM2_INTS:
	.dw	INT1_ENTRY
	.dw	INT2_ENTRY
	.dw	INT_PRT0_ENTRY
	.dw	INT_PRT1_ENTRY
	.dw	INT_DMA0_ENTRY
	.dw	INT_DMA1_ENTRY
	.dw	INT_CSIO_ENTRY
	.dw	INT_ASCI0_ENTRY
	.dw	INT_ASCI1_ENTRY

DEFAULT_IM2_INTS_SIZE      = .-DEFAULT_IM2_INTS


INT0_ENTRY:
	PUSH	AF
	LD	A,11			;(INT0)
	JP	NOICE_INT_ENTRY
INT1_ENTRY:
	PUSH	AF
	LD	A,12
	JP	NOICE_INT_ENTRY
INT2_ENTRY:
	PUSH	AF
	LD	A,13
	JP	NOICE_INT_ENTRY
INT_PRT0_ENTRY:
	PUSH	AF
	LD	A,14
	JP	NOICE_INT_ENTRY
INT_PRT1_ENTRY:
	PUSH	AF
	LD	A,15
	JP	NOICE_INT_ENTRY
INT_DMA0_ENTRY:
	PUSH	AF
	LD	A,16
	JP	NOICE_INT_ENTRY
INT_DMA1_ENTRY:
	PUSH	AF
	LD	A,17
	JP	NOICE_INT_ENTRY
INT_CSIO_ENTRY:
	PUSH	AF
	LD	A,18
	JP	NOICE_INT_ENTRY
INT_ASCI0_ENTRY:
	PUSH	AF
	LD	A,19
	JP	NOICE_INT_ENTRY
INT_ASCI1_ENTRY:
	PUSH 	AF
	LD	A,20
	JP	NOICE_INT_ENTRY



	.endif ; NOICE_DO_VECTORS

;===========================================================================
;
;  Non-maskable interrupt:  bash button
;  PC is stacked, interrupts disabled, and IFF2 has pre-NMI interrupt state
;
;  At the user's option, this may vector thru user RAM at USER_CODE+0x66,
;  or enter the monitor directly.  This will depend on whether or not
;  the user wishes to use NMI in the application, or to use it with
;  a push button to break into running code.
;	 ORG	 R0+0x66
DEFAULT_NMI:
	PUSH	AF
	PUSH	HL
	LD	HL,0
	ADD	HL,SP
	LD	A,H
	POP	HL
	CP	A,>MONSTACK	; check to see if we're already in the monitor
	JR	Z, IGNORE_NMI
	LD	A,2	
	JP	NOICE_INT_ENTRY

IGNORE_NMI:
	POP	AF
	RETN

;
;  Or, if user wants control of NMI:
;;	JP	USER_CODE + 0x66	 ;JUMP THRU VECTOR IN RAM
;;  (and enable NMI handler in DEFAULT_INTS below)
DEFAULT_NMI_SIZE = .-DEFAULT_NMI


;
;===========================================================================
;  Power on NOICE_RESET or trap
NOICE_RESET::
;
;----------------------------------------------------------------------------
;  See if this is an illegal op-code trap or a NOICE_RESET
	LD	(REG_SP),SP	;save user's stack pointer (or zero after NOICE_RESET)
	LD	SP,MONSTACK	;and get a guaranteed stack
	PUSH	AF		;SAVE A AND FLAGS
	IN0	a,(Z180_ITC)	;ChECK TRAP STATUS (FLAGS DESTROYED!!)
	BIT	7,A		;IF THIS BIT IS ONE, THERE WAS TRAP!
	JR	Z,NOICE_INIT	;JIF NOICE_RESET (AF on stack, but SP will be reloaded)
;
;  Illegal instruction trap:
;  Back up the stacked PC by either 1 or 2 bytes, depending on the state
;  of the UFO bit in the itc
	LD	(REG_HL),HL
	POP	HL		;get AF stacked above
	LD	(REG_AF),HL	;SAVE AF

	LD	SP,(REG_SP)	;restore SP after trap
	POP	HL		;GET STACKED PC
	DEC	HL		;BACK UP ONE BYTE
	BIT	6,A
	JR	Z,TR20		;JIF 1 BYTE OP-CODE
	DEC	HL		;ELSE BACK UP SECOND OP-CODE BYTE
;
;  NOICE_RESET the trap bit
TR20:	AND	0x7F		 ;CLEAR THE TRAP BIT
	out0	(Z180_ITC),a
;
;  Get IFF2
;  It is not clear that we can determine the pre-trap state of the
;  interrupt enable:  the databook says nothing about IFF2 vis a vis
;  trap.  We presume that interrupts are disabled by the trap.
;  However, we proceed as if IFF2 contained the pre-trap state
	LD	A,I		;GET P FLAG = IFF2 (SIDE EFFECT)
	DI			;BE SURE INTS ARE DISABLED
	LD	(REG_I),A	;SAVE INT REG
	LD	A,0
	JP	PO,TR30		;JIF PARITY ODD (FLAG=0)
	INC	A		;ELSE SET A = FLAG = 1 (ENABLED)
TR30:	LD	(REG_IFF),A	;SAVE INTERRUPT FLAG
;
;  save registers in reg block for return to master
	LD	A,10
	LD	(REG_STATE),A	;SET STATE TO "TRAP"
	JP	ENTER_MON	;HL = OFFENDING PC

;
;-------------------------------------------------------------------------
;  Initialize monitor
NOICE_INIT::

	.ifdef 	NOICE_DO_ENTER_MON
	LD	SP,MONSTACK
	.endif

	.ifdef	NOICE_DO_HW_SETUP | NOICE_DO_COMMS_SETUP
;
;  Initialize target hardware
	LD	HL,INIOUT	;PUT ADRESS OF INITIALIZATION DATA TABLE INTO HL
	LD	D,OUTCNT	;PUT NUMBER OF DATA AND ADDR. PAIRS INTO REG. B

	LD	B,0		;all internal regs in this table
RST10:	LD	C,(HL)		;load address from table
	INC	HL
	LD	A,(HL)		;load data from table
	INC	HL
	OUT	(C),A		;output a to i/o address (A15-A8 = B = 0)
	DEC	D
	JR	NZ,RST10	;loop for d (address, data) pairs


	.endif ; NOICE_DO_HW_SETUP

;===========================================================================
;  Initialize user interrupt vectors to point to monitor
	LD	HL,DEFAULT_INTS		;dummy handler code
	LD	A,I
	LD	D,A
	LD	E,0			;start of 0 vectors
	LD	BC,DEFAULT_INTS_SIZE	;number of bytes
	LDIR				;copy code

;===========================================================================
;  Same for NMI
	LD	HL,DEFAULT_NMI		;dummy handler code
	LD	E,0x66			;start of 0 vectors
	LD	BC,DEFAULT_NMI_SIZE	;number of bytes
	LDIR				;copy code


	.ifdef NOICE_DO_VECTORS

	; im2 vectors

	; rest of hardware vectors
	LD	HL,DEFAULT_IM2_INTS
	IN0	A,(Z180_IL)		; get location of im2 interrupts
	LD	E,A
	LD	BC,DEFAULT_IM2_INTS_SIZE
	LDIR

	; INT0
	LD	BC,INT0_ENTRY
	LD	H,D
	LD	L,IM2_INT0_VEC
	LD	(HL),C
	INC	HL
	LD	(HL),B


	.endif

;===========================================================================
;
;  Initialize user registers
	LD	HL,NOICE_INITSTACK
	LD	(REG_SP),HL		;INIT USER'S STACK POINTER
	LD	HL,0
	LD	A,L
	LD	(REG_PC),HL		;INIT ALL REGS TO 0
	LD	(REG_HL),HL
	LD	(REG_BC),HL
	LD	(REG_DE),HL
	LD	(REG_IX),HL
	LD	(REG_IY),HL
	LD	(REG_AF),HL
	LD	(REG_HLX),HL
	LD	(REG_BCX),HL
	LD	(REG_DEX),HL
	LD	(REG_AFX),HL
	LD	(REG_I),A
	LD	(REG_STATE),A		;set state as "NOICE_RESET"
	LD	(REG_IFF),A		;NO INTERRUPTS
;
;  Initialize memory paging variables and hardware (if any)
	LD	(REG_PAGE),A		;page 0
;;;	LD	(PAGEIMAGE),A
;;;	OUT	(PAGELATCH),A		;set hardware page
;
;  Set function code for "GO".	Then if we NOICE_RESET after being told to
;  GO, we will come back with registers so user can see the crash
	LD	A,FN_RUN_TARGET
	LD	(COMBUF),A

	.ifdef NOICE_DO_ENTER_MON
		JP	RETURN_REGS		;DUMP REGS, ENTER MONITOR
	.else
		RET
	.endif
;
;===========================================================================
;  Get a character to A
;
;  Return A=char, CY=0 if data received
;	  CY=1 if timeout (0.5 seconds)
;
;  Uses 6 bytes of stack including return address
;
GETCHAR:
	PUSH	DE

	LD	DE,0x08000		 ;long timeout
GC10:	DEC	DE
	LD	A,D
	OR	E
	JR	Z,GC90			;exit if timeout

	IN0	A,(Z180_STAT0)		;read device status
	BIT	Z180bit_STATx_RDRF, A
	JR	Z,GC10			;not ready yet.

	AND	1<<Z180bit_STATx_OVRN|1<<Z180bit_STATx_PE|1<<Z180bit_STATx_FE
	CALL	NZ, DBG_TOG

;
;  Data received:  return CY=0. data in A
	XOR	A			;CY=0
	IN0	A,(Z180_RDR0)		;read data
	POP	DE
	RET
;
;  Timeout:  return CY=1
GC90:	SCF				;cy=1
	POP	DE
	RET

DBG_TOG:
	; toggle the caps lock led when there's an error
	ld	a,(DEBUG_SERIAL)
	xor	a,8
	or	a,7
	ld	(DEBUG_SERIAL),a
	push	BC
	ld	BC,sheila_SYSVIA_orb
	out	(C),A
	pop	BC
	ret
;
;===========================================================================
;  Output character in A
;
;  Uses 6 bytes of stack including return address
;
NOICE_PUTCHAR::
PUTCHAR:
	PUSH	AF			;save byte to output
PC10:
	IN0	A,(Z180_STAT0)		;read device status
	BIT	Z180bit_STATx_TDRE,A	;TX READY ?
	JR	Z,PC10

	POP	AF
	OUT0	(Z180_TDR0),A		;transmit char

	RET
;
;===========================================================================
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:	.db	 0			; 2:	PROCESSOR TYPE = Z80
	.db	 NOICE_COMBUF_SIZE	; 3:	SIZE OF COMMUNICATIONS BUFFER
	.db	 0			; 4:	NO OPTIONS
	.dw	 0			; 5,6:	BOTTOM OF PAGED MEM (none)
	.dw	 0			; 7,8:	TOP OF PAGED MEM (none)
	.db	 B1-B0			; 9	BREAKPOINT INSTRUCTION LENGTH
B0:	RST	0x08			; 10+	BREAKPOINT INSTRUCTION
B1:
	.asciz	 "Dossytronics Blitter Mk.3+Z180S"	;DESCRIPTION, ZERO
TSTG_SIZE	=     .-TSTG	      ;SIZE OF STRING
;
;===========================================================================
;  HARDWARE PLATFORM INDEPENDENT EQUATES AND CODE
;
;  Communications function codes.
FN_GET_STATUS	=     0x0FF    ;reply with device info
FN_READ_MEM	=     0x0FE    ;reply with data
FN_WRITE_MEM	=     0x0FD    ;reply with status (+/-)
FN_READ_REGS	=     0x0FC    ;reply with registers
FN_WRITE_REGS	=     0x0FB    ;reply with status
FN_RUN_TARGET	=     0x0FA    ;reply (delayed) with registers
FN_SET_BYTES	=     0x0F9    ;reply with data (truncate if error)
FN_IN		=     0x0F8    ;input from port
FN_OUT		=     0x0F7    ;output to port
;
FN_MIN		=     0x0F0    ;MINIMUM RECOGNIZED FUNCTION CODE
FN_ERROR	=     0x0F0    ;error reply to unknown op-code
;
;===========================================================================
;  Enter here via RST nn for breakpoint:  AF, PC are stacked.
;  Enter with A=interrupt code = processor state
;  Interrupt status is not changed from user program and IFF2==IFF1
NOICE_INT_ENTRY::
;
;  Interrupts may be on:  get IFF as quickly as possible, so we can DI
	LD	(REG_STATE),A	;save entry state
	LD	(REG_HL),HL	;SAVE HL
	LD	A,I		;GET P FLAG = IFF2 (SIDE EFFECT)
	DI			;NO INTERRUPTS ALLOWED
;
	LD	(REG_I),A	;SAVE INT REG
	LD	A,0
	JP	PO,BREAK10	;JIF PARITY ODD (FLAG=0)
	INC	A		;ELSE SET A = FLAG = 1 (ENABLED)
BREAK10: LD	(REG_IFF),A	;SAVE INTERRUPT FLAG
;
;  Save registers in reg block for return to master
	POP	HL		;GET FLAGS IN L, ACCUM IN H
	LD	(REG_AF),HL	;SAVE A AND FLAGS
;
;  If entry here was by breakpoint (state=1), then back up the program
;  counter to point at the breakpoint/RST instruction.	Else leave PC alone.
;  (If CALL is used for breakpoint, then back up by 3 bytes)
	POP	HL		;GET PC OF BREAKPOINT/INTERRUPT
	LD	A,(REG_STATE)
	CP	1
	JR	NZ,NOTBP	;JIF NOT A BREAKPOINT
	DEC	HL		;BACK UP PC TO POINT AT BREAKPOINT
NOTBP:	JP	ENTER_MON	;HL POINTS AT BREAKPOINT OPCODE

;
;===========================================================================
;  Main loop:  wait for command frame from master
MAIN:	LD	SP,MONSTACK		;CLEAN STACK IS HAPPY STACK
	LD	HL,COMBUF		;BUILD MESSAGE HERE
;
;  First byte is a function code
	CALL	GETCHAR			;GET A FUNCTION (uses 6 bytes of stack)
	JR	C,MAIN			;JIF TIMEOUT: RESYNC
	CP	FN_MIN
	JR	C,MAIN_ERR_FN		;JIF BELOW MIN: ILLEGAL FUNCTION
	LD	(HL),A			;SAVE FUNCTION CODE
	INC	HL
;
;  Second byte is data byte count (may be zero)
	CALL	GETCHAR			;GET A LENGTH BYTE
	JR	C,MAIN_ERR_TO1		;JIF TIMEOUT: RESYNC
	CP	NOICE_COMBUF_SIZE+1
	JR	NC,MAIN_ERR_TOOLONG	;JIF TOO LONG: ILLEGAL LENGTH
	LD	(HL),A			;SAVE LENGTH
	INC	HL
	OR	A
	JR	Z,MA80			;SKIP DATA LOOP IF LENGTH = 0
;
;  Loop for data
	LD	B,A			;SAVE LENGTH FOR LOOP
MA10:	CALL	GETCHAR			;GET A DATA BYTE
	JR	C,MAIN_ERR_TO2		;JIF TIMEOUT: RESYNC
	LD	(HL),A			;SAVE DATA BYTE
	INC	HL
	DJNZ	MA10
;
;  Get the checksum
MA80:	CALL	GETCHAR			;GET THE ChECKSUM
	JR	C,MAIN_ERR_TO3		;JIF TIMEOUT: RESYNC
	LD	C,A			;SAVE ChECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
	CALL	ChECKSUM
	ADD	A,C
	JR	NZ,MAIN_ERR_CKSUM	;JIF BAD ChECKSUM
;
;  Process the message.
	LD	A,(COMBUF+0)		;GET THE FUNCTION CODE
	CP	FN_GET_STATUS
	JP	Z,TARGET_STATUS
	CP	FN_READ_MEM
	JP	Z,READ_MEM
	CP	FN_WRITE_MEM
	JP	Z,WRITE_MEM
	CP	FN_READ_REGS
	JP	Z,READ_REGS
	CP	FN_WRITE_REGS
	JP	Z,WRITE_REGS
	CP	FN_RUN_TARGET
	JP	Z,RUN_TARGET
	CP	FN_SET_BYTES
	JP	Z,SET_BYTES
	CP	FN_IN
	JP	Z,IN_PORT
	CP	FN_OUT
	JP	Z,OUT_PORT
;
;  Error: unknown function.  Complain
	LD	A,FN_ERROR
	LD	(COMBUF+0),A	;SET FUNCTION AS "ERROR"
	LD	A,1
	JP	SEND_STATUS	;VALUE IS "ERROR"

;; These left in for debugging/tracing purposes TODO: remove
MAIN_ERR_FN:
	JR	MAIN
MAIN_ERR_TO1:
	JR	MAIN
MAIN_ERR_TO2:
	JR	MAIN
MAIN_ERR_TO3:
	JR	MAIN
MAIN_ERR_TOOLONG:
	JR	MAIN
MAIN_ERR_CKSUM:
	JR	MAIN

;===========================================================================
;
;  Target Status:  FN, len
;
TARGET_STATUS:
;
	LD	HL,TSTG			;DATA FOR REPLY
	LD	DE,COMBUF+1		;RETURN BUFFER
	LD	BC,TSTG_SIZE		;LENGTH OF REPLY
	LD	A,C
	LD	(DE),A			;SET SIZE IN REPLY BUFFER
	INC	DE
	LDIR				;MOVE REPLY DATA TO BUFFER
;
;  Compute checksum on buffer, and send to master, then return
	JP	SEND

;===========================================================================
;
;  Read Memory:	 FN, len, page, Alo, Ahi, Nbytes
;
READ_MEM:
;
;  Set page
;;	LD	A,(COMBUF+2)
;;	LD	(PAGEIMAGE),A
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A
;
;  Get address
	LD	HL,(COMBUF+3)
	LD	A,(COMBUF+5)		;NUMBER OF BYTES TO GET
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LD	DE,COMBUF+1		;POINTER TO LEN, DATA
	LD	(DE),A			;RETURN LENGTH = REQUESTED DATA
	INC	DE
	OR	A
	JR	Z,GLP90			;JIF NO BYTES TO GET
;
;  Read the requested bytes from local memory
	LD	B,A
GLP:	LD	A,(HL)			;GET BYTE TO A
	LD	(DE),A			;STORE TO RETURN BUFFER
	INC	HL
	INC	DE
	DJNZ	GLP
;
;  Compute checksum on buffer, and send to master, then return
GLP90:	JP	SEND

;===========================================================================
;
;  Write Memory:  FN, len, page, Alo, Ahi, (len-3 bytes of Data)
;
;  Uses 2 bytes of stack
;
WRITE_MEM:
;
;  Set page
;;	LD	A,(COMBUF+2)
;;	LD	(PAGEIMAGE),A
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A
;
	LD	HL,COMBUF+5		;POINTER TO SOURCE DATA IN MESSAGE
	LD	DE,(COMBUF+3)		;POINTER TO DESTINATION
	LD	A,(COMBUF+1)		;NUMBER OF BYTES IN MESSAGE
	SUB	3			;LESS PAGE, ADDRLO, ADDRHI
	JR	Z,WLP50			;EXIT IF NONE REQUESTED
;
;  Write the specified bytes to local memory
	LD	B,A
	PUSH	BC			;SAVE BYTE COUNTER
WLP10:	LD	A,(HL)			;BYTE FROM HOST
	LD	(DE),A			;WRITE TO TARGET RAM
	INC	HL
	INC	DE
	DJNZ	WLP10
;
;  Compare to see if the write worked
	LD	HL,COMBUF+5		;POINTER TO SOURCE DATA IN MESSAGE
	LD	DE,(COMBUF+3)		;POINTER TO DESTINATION
	POP	BC			;SIZE AGAIN
;
;  Compare the specified bytes to local memory
WLP20:	LD	A,(DE)			;READ BACK WHAT WE WROTE
	CP	(HL)			;COMPARE TO HOST DATA
	JR	NZ,WLP80		;JIF WRITE FAILED
	INC	HL
	INC	DE
	DJNZ	WLP20
;
;  Write succeeded:  return status = 0
WLP50:	XOR	A			;RETURN STATUS = 0
	JR	WLP90
;
;  Write failed:  return status = 1
WLP80:	LD	A,1
;
;  Return OK status
WLP90:	JP	SEND_STATUS

;===========================================================================
;
;  Read registers:  FN, len=0
;
READ_REGS:
;
;  Enter here from int after "RUN" and "STEP" to return task registers
RETURN_REGS:
	LD	HL,TASK_REGS		;REGISTER LIVE HERE
	LD	A,TASK_REGS_SIZE	;NUMBER OF BYTES
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LD	DE,COMBUF+1		;POINTER TO LEN, DATA
	LD	(DE),A			;SAVE DATA LENGTH
	INC	DE
;
;  Copy the registers
	LD	B,A
GRLP:	LD	A,(HL)			;GET BYTE TO A
	LD	(DE),A			;STORE TO RETURN BUFFER
	INC	HL
	INC	DE
	DJNZ	GRLP
;
;  Compute checksum on buffer, and send to master, then return
	JP	SEND

;===========================================================================
;
;  Write registers:  FN, len, (register image)
;
WRITE_REGS:
;
	LD	HL,COMBUF+2		;POINTER TO DATA
	LD	A,(COMBUF+1)		;NUMBER OF BYTES
	OR	A
	JR	Z,WRR80			;JIF NO REGISTERS
;
;  Copy the registers
	LD	DE,TASK_REGS		;OUR REGISTERS LIVE HERE
	LD	B,A
WRRLP:	LD	A,(HL)			;GET BYTE TO A
	LD	(DE),A			;STORE TO REGISTER RAM
	INC	HL
	INC	DE
	DJNZ	WRRLP
;
;  Return OK status
WRR80:	XOR	A
	JP	SEND_STATUS

;===========================================================================
;
;  Run Target:	FN, len
;
;  Uses 4 bytes of stack
;
RUN_TARGET:
;
;  Restore user's page
;;	LD	A,(REG_PAGE)
;;	LD	(PAGEIMAGE),A
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A
;
;  Restore alternate registers
	LD	HL,(REG_AFX)
	PUSH	HL
	POP	AF
	EX	AF,AF'			;LOAD ALTERNATE AF
	;
	LD	HL,(REG_HLX)
	LD	BC,(REG_BCX)
	LD	DE,(REG_DEX)
	EXX				;LOAD ALTERNATE REGS
;
;  Restore main registers
	LD	BC,(REG_BC)
	LD	DE,(REG_DE)
	LD	IX,(REG_IX)
	LD	IY,(REG_IY)
	LD	A,(REG_I)
	LD	I,A
;
;  Switch to user stack
	LD	HL,(REG_PC)		;USER PC
	LD	SP,(REG_SP)		;BACK TO USER STACK
	PUSH	HL			;SAVE USER PC FOR RET
	LD	HL,(REG_AF)
	PUSH	HL			;SAVE USER A AND FLAGS FOR POP
	LD	HL,(REG_HL)		;USER HL
;
;  Restore user's interrupt state
	LD	A,(REG_IFF)
	OR	A
	JR	Z,RUTT10		;JIF INTS OFF: LEAVE OFF
;
;  Return to user with interrupts enabled
	POP	AF
	EI				;ELSE ENABLE THEM NOW
	RET
;
;  Return to user with interrupts disabled
RUTT10: POP	AF
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
	LD	(REG_SP),SP	;SAVE USER'S STACK POINTER
	LD	SP,MONSTACK	;AND USE OURS INSTEAD
;
	LD	(REG_PC),HL
	LD	(REG_BC),BC
	LD	(REG_DE),DE
	LD	(REG_IX),IX
	LD	(REG_IY),IY
;
;  Get alternate register set
	EXX
	LD	(REG_HLX),HL
	LD	(REG_BCX),BC
	LD	(REG_DEX),DE
	EX	AF,AF'
	PUSH	AF
	POP	HL
	LD	(REG_AFX),HL
;
;;	LD	A,(PAGEIMAGE)	;GET CURRENT USER PAGE
	XOR	A		;...OR NONE IF UNPAGED TARGET
	LD	(REG_PAGE),A	;SAVE USER PAGE
;
;  Return registers to master
	JP	RETURN_REGS

;===========================================================================
;
;  Set target byte(s):	FN, len { (page, alow, ahigh, data), (...)... }
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
	LD	HL,COMBUF+1
	LD	B,(HL)			;LENGTH = 4*NBYTES
	INC	HL
	INC	B
	DEC	B
	LD	C,0			;C GETS COUNT OF INSERTED BYTES
	JR	Z,SB90			;JIF NO BYTES (C=0)
	PUSH	HL
	POP	IX			;IX POINTS TO RETURN BUFFER
;
;  Loop on inserting bytes
SB10:	LD	A,(HL)			;MEMORY PAGE
	INC	HL
;;	LD	(PAGEIMAGE),A
;;	PUSH	BC
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A			;SET PAGE
;;	POP	BC
	LD	E,(HL)			;ADDRESS TO DE
	INC	HL
	LD	D,(HL)
	INC	HL
;
;  Read current data at byte location
	LD	A,(DE)			;READ CURRENT DATA
	LD	(IX),A			;SAVE IN RETURN BUFFER
	INC	IX
;
;  Insert new data at byte location
	LD	A,(HL)
	LD	(DE),A			;SET BYTE
	LD	A,(DE)			;READ IT BACK
	CP	(HL)			;COMPARE TO DESIRED VALUE
	JR	NZ,SB90			;BR IF INSERT FAILED: ABORT
	INC	HL
	INC	C			;ELSE COUNT ONE BYTE TO RETURN
;
	DEC	B
	DEC	B
	DEC	B
	DJNZ	SB10			;LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
SB90:	LD	A,C
	LD	(COMBUF+1),A		;SET COUNT OF RETURN BYTES
;
;  Compute checksum on buffer, and send to master, then return
	JP	SEND

;===========================================================================
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
IN_PORT:
;
;  Get port address
	LD	BC,(COMBUF+2)
;
;  Read port value
	IN	A,(C)		;IN WITH A15-A8 = B; A7-A0 = C
;
;  Return byte read as "status"
	JP	SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
OUT_PORT:
;
;  Get port address
	LD	BC,(COMBUF+2)
;
;  Get data
	LD	A,(COMBUF+4)
;
;  Write value to port
	OUT	(C),A		;OUT WITH A15-A8 = B; A7-A0 = C
;
;  Return status of OK
	XOR	A
	JP	SEND_STATUS
;
;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
	LD	(COMBUF+2),A		;SET STATUS
	LD	A,1
	LD	(COMBUF+1),A		;SET LENGTH
	JR	SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
;  Uses 6 bytes of stack (not including return address: jumped, not called)
;
SEND:	CALL	ChECKSUM		;GET A=ChECKSUM, HL->checksum location
	NEG
	LD	(HL),A			;STORE NEGATIVE OF ChECKSUM
;
;  Send buffer to master
	LD	HL,COMBUF		;POINTER TO DATA
	LD	A,(COMBUF+1)		;LENGTH OF DATA
	ADD	A,3			;PLUS FUNCTION, LENGTH, ChECKSUM
	LD	B,A			;save count for loop
SND10:	LD	A,(HL)
	CALL	PUTCHAR			;SEND A BYTE (uses 6 bytes of stack)
	INC	HL
	DJNZ	SND10
	JP	MAIN			;BACK TO MAIN LOOP

;===========================================================================
;  Compute checksum on COMBUF.	COMBUF+1 has length of data,
;  Also include function byte and length byte
;
;  Returns:
;	A = checksum
;	HL = pointer to next byte in buffer (checksum location)
;	B is scratched
;
;  Uses 2 bytes of stack including return address
;
ChECKSUM:
	LD	HL,COMBUF		;pointer to buffer
	LD	A,(COMBUF+1)		;length of message
	ADD	A,2			;plus function, length
	LD	B,A			;save count for loop
	XOR	A			;init checksum to 0
ChK10:	ADD	A,(HL)
	INC	HL
	DJNZ	ChK10			;loop for all
	RET				;return with checksum in A
;
;===========================================================================
;  Hardware initialization table
INIOUT:
	.ifdef NOICE_DO_HW_SETUP
;-----------------------------------------------------------------------

;-----------------------------------------------------------------------
;  Initialization table for Z180
	.db	Z180_DCNTL	 	;set wait state
	.db	0b00000000
	;	  00		mem - 0 wait
	;	    00		i/o - 0 wait
	;	      0000	dreq, i/o mem select = default

	.db	Z180_RCR	 	;set refresh
	.db	0b00111100	 	;refresh disabled - no DRAM!

	.db	Z180_CCR	 	;set clock control 
	.db	0b10000000		; clock divider = 1

	.db	Z180_OMCR		;set operation mode
	.db	0b01011111
	;	  0		m1 disabled - z mode of operation
	;	   1		m1 pulse not needed
	;	    0		i/o timing = z80 compatible
	;	     11111	same as default

	.db	 Z180_ITC		;itc - enable only int0
	.db	 0b00000001		;clear trap/ufo bit

	.endif

	.ifdef NOICE_DO_COMMS_SETUP

	; ASCI 0 @ 38400 baud 8n1

	.db	Z180_CNTLA0
	.db	0b01101100
	;	  0		multiprocessor mode off
	;	   1		receiver enable
	;	    1		transmitter enable
	;	     0		nRTS = 0
	;	      1		EFR - NOICE_RESET all errors
	;	       100	MOD = 8n1

	.db	Z180_CNTLB0
	.db	0b00000000
	;	  0		multiprocessor bit transmit
	;	   0		multiprocessor mode
	;	    0		PS prescale div 16 for BRG
	;	     0		parity
	;	      0		divide ratio 16 with (ignored)
	;	       000	SSx - PHI prescalar scalar = 1

	.db	Z180_ASEXT0
	.db	0b11101110
	;	  1		RDRF interrupt inhibit
	;	   1		auto DCD disable, ignore handshake
	;	    1		auto CTS disable, ignore handshake
	;	     0		X1 - turn off synchronous mode
	;	      1		BRG - use baud rate generator
	;	       1	Break feature OFF
	;	        1	Break detect OFF
	;	         0	Normal positive transmit

	;; NOTE: some datasheets do not make it clear that if the X1 bit is in force the 
	;  receiver is synchronous and bits must arrive synchronized to CLKA!
	;  We turn of X1 and must use either a 16 or 64 prescaler (PS bit of CNTLB)

;;BAUD_TC = 24;;(16000000/19200/2/16)-2
BAUD_TC = 11;;(16000000/38400/2/16)-2		; 38400 is the highest common speed that doesn't have a big error due to prescale

	.db	Z180_TC0H
	.db	>BAUD_TC
	.db	Z180_TC0L
	.db	<BAUD_TC


	.endif
;-------------------------------------------------------------------------
OUTCNT	=     (.-INIOUT)/2    ; NUMBER OF INITIALIZING PAIRS





