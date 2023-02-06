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


		.include	"../../../includes/hardware.inc"
		.include	"../../includes/hardware-z180.inc"
		.hd64			; z180 instruction set

NOICE_INITSTACK		=	0x8F0		; grow down from NoIce area with a guard of 16 bytes
NOICE_COMBUF_SIZE	=	67		; DATA SIZE FOR COMM BUFFER
NOICE_DO_VECTORS = 1
NOICE_DO_HW_SETUP = 1
NOICE_DO_COMMS_SETUP = 1
NOICE_DO_ENTER_MON = 1

		.include "../lib/noice-z180.asm"

		.area	CODE_VEC (CON, ABS)

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
		ld	bc,0x45ED
		ld	(0x66),bc

; at this point the CPU thinks it is running at 0 0000 do a jump to get the PC
; correct
		jp	RESET_0_FFxx

RESET_0_FFxx:

;===========================================================================
; we now need to set the MMU to how we want it:
; on the z180 we need to map the MOS ROM into the top bank

; first set banking boundaries, for this test we'll map: 
; ChipRAM			0..2FFF (Common Area 0)
; SysRAM/screen			3000..C000 (Banked Area)
; the MOS ROM at		C000 (Common Area 1)

		ld	a,0xC3
		out0	(Z180_CBAR),a

; and we'll map CAR0 => 0 0000
;		BAR  => F xxxx
;		CAR1 => F xxxx

		ld	a,0xF0
		out0	(Z180_BBR),a

		ld	a,0xF0
		out0	(Z180_CBR),a

		im	2
		ld	a,0
		ld	i,a

		ld	a,0x40
		out0	(Z180_IL),a


; now disable Blitter's "boot mode" and start executing from MOS rom as mapped 
; above

; we are now running in ROM and can disable the boot mapping by writing to FCFF

		ld	a,JIM_DEVNO_BLITTER
		ld	bc,fred_JIM_DEVNO
		out	(c),a



		jp	NOICE_INIT


