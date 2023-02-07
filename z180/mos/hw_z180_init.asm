		.list(me,meb)

		.area	MOS_CODE (CON, REL)

		.hd64
	
		.include	"../../includes/hardware.inc"
		.include	"../includes/hardware-z180.inc"

		.globl	NOICE_INT_ENTRY


;===========================================================================
;
;  Default handlers for RST and NMI.  This code is moved to the beginning
;  of RAM
;
DEFAULT_INTS:
;
;  RST 0
R0:	RETN				; this will get setup properly by NoIce
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP

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


DEFAULT_INTS_SIZE      = .-DEFAULT_INTS

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


;===========================================================================
;
;  Non-maskable interrupt:  bash button
; this will get setup properly by NoIce
DEFAULT_NMI:
	RETN

;
;  Or, if user wants control of NMI:
;;	JP	USER_CODE + 0x66	 ;JUMP THRU VECTOR IN RAM
;;  (and enable NMI handler in DEFAULT_INTS below)
DEFAULT_NMI_SIZE = .-DEFAULT_NMI



reset_hw_table:

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

	; ASCI 0 @ 38400 baud 8n1

	.db	Z180_CNTLA0
	.db	0b01101100
	;	  0		multiprocessor mode off
	;	   1		receiver enable
	;	    1		transmitter enable
	;	     0		nRTS = 0
	;	      1		EFR - reset all errors
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

reset_hw_table_count = (.-reset_hw_table) / 2


z180_reset_hw_init::
;
;  Initialize target hardware
	ld	HL,reset_hw_table		
	ld	D,reset_hw_table_count	

	ld	B,0		;all internal regs in this table
RST10:	ld	C,(HL)		;load address from table
	inc	HL
	ld	A,(HL)		;load data from table
	inc	HL
	out	(C),A		;output a to i/o address (A15-A8 = B = 0)
	dec	D
	jr	NZ,RST10	;loop for d (address, data) pairs
	

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


	ret
