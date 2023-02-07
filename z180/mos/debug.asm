
		.globl	NOICE_PUTCHAR

		.area	NOICE_CODE	(CON, REL)


DEBUG_PRINTSTR::
		ex	(SP),HL
		push	AF

10$:		ld	a,(HL)
		inc	HL
		and	a,0x7F
		jr	Z,20$
		call	NOICE_PUTCHAR
		jr	10$

20$:		pop	AF
		ex	(SP),HL

		ret


