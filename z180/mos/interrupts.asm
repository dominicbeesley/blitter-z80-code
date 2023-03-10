		.list(me,meb)

		.hd64
		.include "config.inc"
		.include	"../../includes/hardware.inc"
		.include	"../includes/hardware-z180.inc"

		.globl	INT0_ENTRY

		.area	MOS_CODE (REL, CON)


int0_handle::
		push	AF
		push	BC
		push	HL
		
		ld	BC,sheila_SYSVIA_ifr
		in	A,(C)
		jp	P,88$

		bit	6,A
		jr	Z,88$
		
		ld	A,0h40
		out	(C),A

		; assume 100Hz timer		
		ld	HL,oswksp_TIME+4
		inc	(HL)
		jr	NZ, 1$
		dec	HL
		inc	(HL)
		jr	NZ, 1$
		dec	HL
		inc	(HL)
		jr	NZ, 1$
		dec	HL
		inc	(HL)
		jr	NZ, 1$
		dec	HL
		inc	(HL)
1$:
		ld	A,(oswksp_TIME+4)
		ld	(oswksp_TIME2+4),A
		ld	A,(oswksp_TIME+3)
		ld	(oswksp_TIME2+3),A
		ld	A,(oswksp_TIME+2)
		ld	(oswksp_TIME2+2),A
		ld	A,(oswksp_TIME+1)
		ld	(oswksp_TIME2+1),A
		ld	A,(oswksp_TIME+0)
		ld	(oswksp_TIME2+0),A


		pop	HL
		pop	BC
		pop	AF
		ei
		reti

88$:		pop	HL
		pop	BC
		pop	AF
		jp	INT0_ENTRY

		.end