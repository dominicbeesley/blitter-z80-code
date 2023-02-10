
		.globl	NOICE_PUTCHAR

		.area	NOICE_CODE	(CON, REL)


DEBUG_PRINT_STR_I::
		ex	(SP),HL
		call	DEBUG_PRINT_HL
		ex	(SP),HL
		ret

DEBUG_PRINT_HL::
		push	AF

10$:		ld	a,(HL)
		inc	HL
		and	a,0x7F
		jr	Z,20$
		call	NOICE_PUTCHAR
		jr	10$

20$:		pop	AF
		ret


DEBUG_TODO::
		call	DEBUG_PRINT_STR_I
		.asciz	"TODO: "
		ex	(SP),HL
		call	DEBUG_PRINT_HL
		call	DEBUG_PRINT_STR_I
		.db	13,10,0
		ex	(SP),HL
		ret


DEBUG_PRINT_HEX_A::
		push	af
		rra
		rra
		rra
		rra
		call	print_hexNyb
		pop	af		
print_hexNyb:
		push	af
   		and	a,0x0F
   		add	a,0x90
   		daa
   		adc	a,0x40
   		daa
   		call	NOICE_PUTCHAR
   		pop	af
   		ret
