	; enable a timer on int 0 and do something with it to test
	; the Blitter interrupt handling



		.include	"../../../includes/hardware.inc"
		.include	"../../includes/hardware-z180.inc"
		.hd64			; z180 instruction set


		.area CODE(REL,CON)

start:		di			; disable interrupts

		; disable int0 in case there's pending stuff
		ld	a,0
		out0	(Z180_ITC),a


		; set up PRT0 to make a 200us interrupt

PRT0_VAL	= (200 * 16 / 20) - 1

		; set the reload regiser
		ld	a,<PRT0_VAL
		out0	(Z180_RLDR0L),a
		out0	(Z180_TMDR0L),a
		ld	a,>PRT0_VAL
		out0	(Z180_RLDR0H),a
		out0	(Z180_TMDR0H),a

		ld	a,0b00010001
		;	    --
		;	      0		; IE timer 1
		;	       1		; IE timer 0
		;	        00	; A18 output
		;	          0	; enable timer 1
		;	           1	; enable timer 0
		out0	(Z180_TCR),a



		; now set up a PRT0 handler at IL+4

		ld	bc,int_prt0_handle
		ld	a,i
		ld	h,a
		in0	a,(Z180_IL)	; get base of im2 vectors
		add	a,4		; PRT0 interrupt is in 2nd word entry
		ld	l,a
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

int_prt0_handle:	push	af
		push	hl
		push	bc

		; timer 1 interrupt clear
		in0	a,(Z180_TCR)
		in0	a,(Z180_TMDR0L)

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