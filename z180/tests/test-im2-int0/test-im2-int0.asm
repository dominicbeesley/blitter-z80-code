	; enable a timer on int 0 and do something with it to test
	; the Blitter interrupt handling - this uses interrupt mode 2
	; 



		.include	"../../../includes/hardware.inc"
		.include	"../../includes/hardware-z180.inc"
		.hd64			; z180 instruction set


		.area CODE(REL,CON)

start:		di			; disable interrupts
		im	2		; force interrupt mode 2

		; set up SYS VIA to generate 100Hz interrupt

T1_VAL	= 10000 - 2


		; clear all IER for SYSVIA
		ld	bc,sheila_SYSVIA_ier
		ld	a,0x7f
		out	(c),a
		; enable timer 1 (bit 6)
		ld	a,0xC0
		out	(c),a

		; enable free run T1 interrupts (no PB7)
		ld	bc,sheila_SYSVIA_acr
		ld	a,0x40		; T1 continuous, no PB7, T2 timed, no shift reg, no PA/PB latchesz

		;set counter
		ld	bc,sheila_SYSVIA_t1ll
		ld	a,<T1_VAL
		out	(c),a

		inc	c
		ld	a,>T1_VAL
		out	(c),a
		dec	c
		dec	c
		out	(c),a		; set cur val in counter

		; no set up an rst 0x56 interrupt handler

		ld	bc,int0_handle
		ld	a,i
		ld	h,a
		ld	l,IM2_INT0_VEC
		ld	(hl),c
		inc	hl
		ld	(hl),b

		ld	a,0
		ld	bc,3
		ld	hl,clock_counter
		ld	de,clock_counter+1
		ld	(hl),a
		ldir


		ei			; enable interrupts

here:		di
		ld	hl,clock_counter
		ld	de,clock_val
		ld	bc,4
		ldir
		ei

		call	home

		ld	a,(clock_val+3)
		call	print_hex8
		ld	a,(clock_val+2)
		call	print_hex8
		ld	a,(clock_val+1)
		call	print_hex8
		ld	a,(clock_val+0)
		call	print_hex8

		jr	here		; spin

		rst	8		; return to NoIce Debugger

int0_handle:	push	af
		push	hl
		push	bc

		; assume a via interrupt and clear all
		ld	bc,sheila_SYSVIA_ifr
		ld	a,0x7F
		out	(c),a

		ld	a,4
		ld	hl,clock_counter
1$:		inc	(hl)
		jr	nz, 2$
		inc	hl
		dec	a
		or	a
		jr	nz, 1$

2$:		pop	bc
		pop	hl
		pop	af
		ei
		reti

home:		push	hl
		ld	hl,0x7c00
		ld	(vdu_ptr),hl
		pop	hl
		ret

print:		push	hl
		ld	hl,(vdu_ptr)
		ld	(hl),a
		inc	hl
		ld	(vdu_ptr),hl
		pop	hl
		ret

print_hex8:
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
   		call	print
   		pop	af
   		ret

		.area DATA(REL,CON)

clock_counter:	.rmb	4
clock_val:	.rmb	4

vdu_ptr:		.rmb	2


		.ascii "some data"