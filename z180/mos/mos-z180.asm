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
;	20-Dec-93 JLH bug in NMI dummy vectors: overwrote NMI and reset!
;	17-Oct-95 JLH eliminate two-arg for SUB, AND, OR, XOR, and CP
;	21-Jul-00 JLH change FN_MIN from F7 to F0
;	12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;	11-Jan-05 JLH V3.1: correct bug in Z180 reset/illegal op-code trap
;	12-Nov-18 JLH modify to assemble with Arnold's as
;	31-Jan-23 .db  modify for asz180 and to run on the Blitter+z180 platform
;
; NOTE: this monitor expects interrupt mode 1


		.include	"../../includes/hardware.inc"
		.include	"../includes/hardware-z180.inc"
		.hd64			; z180 instruction set

		.globl	NOICE_INIT
		.globl	z180_reset_hw_init


		.area	MOS_CODE (CON, REL)




mos_handle_res::	
		ld	HL,0x8000
		ld	SP,HL

		; set up the basic hardware for the z180

		call	z180_reset_hw_init

		call	NOICE_INIT			; Call the initialisation routine for
							; NoIce


HERE:		jp	HERE



		.area	NOICE_CODE(CON, REL)
	; placeholder to make sure the linker puts it in the right spot

