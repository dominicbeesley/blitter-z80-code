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
;	20-Dec-93 JLH bug in NMI dummy vectors: overwrote NMI and reset!
;	17-Oct-95 JLH eliminate two-arg for SUB, AND, OR, XOR, and CP
;	21-Jul-00 JLH change FN_MIN from F7 to F0
;	12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;	11-Jan-05 JLH V3.1: correct bug in Z180 reset/illegal op-code trap
;	12-Nov-18 JLH modify to assemble with Arnold's as
;	31-Jan-23 .db  modify for asz180 and to run on the Blitter+z180 platform
;
; NOTE: this monitor expects interrupt mode 1

		.include "config.inc"

		.hd64			; z180 instruction set

		.globl	NOICE_INIT
		.globl	z180_reset_hw_init


		.area	MOS_CODE (CON, REL)


		.globl	mos_VDU_init
		.globl   mos_VDU_WRCH


mos_handle_res::	
		ld	HL,STACKTOP
		ld	SP,HL

		; set up the basic hardware for the z180

		call	z180_reset_hw_init

		call	NOICE_INIT			; Call the initialisation routine for
							; NoIce

		; bodge a few values

		ld	A,0
		ld	(oswksp_VDU_VERTADJ),A
		ld	(oswksp_VDU_INTERLACE),A
		ld	(sysvar_VDU_Q_LEN),A


		rst 8

;;		; bodge to set crtc regs
;;
;;		ld	BC,sheila_CRTC_reg
;;		ld	A,0xC
;;		out	(C),A
;;		inc	BC
;;		ld	A,0x6
;;		out	(C),A
;;		ld	BC,sheila_CRTC_reg
;;		ld	A,0xD
;;		out	(C),A
;;		inc	BC
;;		ld	A,0x0
;;		out	(C),A


		ld	a,2
		call	mos_VDU_init

		ld	B,7
		ld	C,1

2$:
		ld	A,17
		call	OSWRCH
		ld	A,B
		and	A,0xF
		call	OSWRCH

		ld	A,17
		call	OSWRCH
		ld	A,C
		and	A,0xF
		or	A,0x80
		call	OSWRCH


		ld	HL,str_hellow
1$:		ld	A,(HL)	
		inc	HL	
		call	OSWRCH
		or	A,A
		jr	NZ,1$
		
		inc	B
		jr	NZ,2$
		inc	C
		jp	2$

		


HERE:		jp	HERE


str_hellow:	.asciz	"Ishbel "

;;DUMMY ROUTINES....


mos_poke_SYSVIA_orb::
;		pshs	CC
;		SEI
;		sta	sheila_SYSVIA_orb
;
;		puls	CC,PC
; TODO: what is the purpose of turning off/on interrupts here!?!
		push	BC
		ld	BC,sheila_SYSVIA_orb
		out	(C),A
		pop	BC
		ret


LE1A2::		; should do a NETV then UPTV

		ret

	; This is needed for the Zx80 as there is no simple way to push/pop
	; the interrupt enable status

	; this routine messes with the stack so that when it exits
	; the stack will contain a pushed AF containing the P flag from 
	; and LD A,I

pushIFF_DI::	
	push	HL	; make some space
	push	AF
	push	IX
	ld	IX,0
	add	IX,SP

	; move return into the "space"
	ld	A,(IX+6)
	ld	(IX+4),A
	ld	A,(IX+7)
	ld	(IX+5),A

	; store flag
	ld	A,I
	push	AF
	ld	A,(IX-2)	; get flags
	ld	(IX+6),A

	pop	AF
	pop	IX
	pop	AF
	ret

	; reenable interrupts if they were enabled
popIFF::
	push	AF
	push	IX
	ld	IX,0
	add	IX,SP

	; get back flags and test P
	bit	2,(IX+6)
	jr	Z,10$
	EI
10$:	
	; move saved AF and return up 2 bytes
	ld	A,(IX+4)
	ld	(IX+6),A
	ld	A,(IX+5)
	ld	(IX+7),A

	ld	A,(IX+2)
	ld	(IX+4),A
	ld	A,(IX+3)
	ld	(IX+5),A

	pop	IX
	pop	AF
	pop	AF
	ret


		.area	NOICE_CODE(CON, REL)
	; placeholder to make sure the linker puts it in the right spot



; *************************************************************************
; *                                                                       *
; *       OSBYTE 154 (&9A) SET VIDEO ULA                                  *       
; *                                                                       *
; *************************************************************************
;;mos_OSBYTE_154
;;		m_txa					;osbyte entry! X transferred to A thence to
mos_VIDPROC_set_CTL::
		call	pushIFF_DI
		ld	(sysvar_VIDPROC_CTL_COPY),A	;save RAM copy of new parameter
		push	BC
		ld	BC,sheila_VIDULA_ctl
		out	(C),A
		pop	BC

		ld	A,(sysvar_FLASH_MARK_PERIOD)	;read  space count
		ld	(sysvar_FLASH_CTDOWN),A		;set flash counter to this value
		call	popIFF
		ret	; NOTE: do not remove this ret popIFF frigs the stack

; *************************************************************************
; *                                                                       *
; *        OSBYTE &9B (155) write to pallette register                    *       
; *                                                                       *
; *************************************************************************
                ;entry X contains value to write

;;mos_OSBYTE_155
;;		m_txa					;	EA10
write_pallette_reg::
		xor	A,7				;	EA11
		push	BC
		call	pushIFF_DI
		ld	(sysvar_VIDPROC_PAL_COPY), A	;	EA15
		ld	BC, sheila_VIDULA_pal
		out	(C), A
		call	popIFF
		pop	BC
		ret


OSWRCH_ENTER::	;TODO: this needs to do all the vectoring bullshit
		push	AF
		push	BC
		push	DE
		push	HL
		push	IX
		push	IY

		ld	IX,vduvars_start
		ld	IY,zp_base

		call	mos_VDU_WRCH

		pop	IY
		pop	IX
		pop	HL
		pop	DE
		pop	BC
		pop	AF
		ret


;; ----------------------------------------------------------------------------
;; *************************************************************************
;; *                                                                       *
;; *        OSBYTE &76 (118) SET LEDs to Keyboard Status                   *
;; *                                                                       *
;; *************************************************************************
                          ;osbyte entry with carry set
                         ;called from &CB0E, &CAE3, &DB8B

mos_OSBYTE_118::

		;; mock version - returns 0, Cy = 0
		or	A,A
		ret
