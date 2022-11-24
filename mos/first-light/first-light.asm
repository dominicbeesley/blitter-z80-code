		.include "../../includes/hardware.inc"


		.area   DATA (CON, ABS)

		.globl  scr_ptr

scr_ptr:	.rmb 2


		.area   CODE (CON, ABS)

		.globl	font_data

SCREEN_BASE	= 0x3000
SCREEN_LEN	= 0x5000

handle_res3::	di
		ld	sp, 0x3000


		; switch to mode 0 and do some reading an writing

		; set up palette as B&W
		ld	hl,#sheila_VIDULA_pal
		ld	b,#8
		ld	a,#0h01
pl0:		ld	(hl),a
		add	a,#0h10
		djnz	pl0

		ld	b,#8
		ld	a,#0h87
pl1:		ld	(hl),a
		add	a,#0h10
		djnz	pl1

		ld	b,#18
		ld	e,#17
		ld	hl,#mode_0_setup+17
clp:		ld	d,(hl)
		dec	hl
		ld	(sheila_CRTC_reg),de
		dec	e
		djnz	clp

		
		ld	a,#0h9D
		ld	(sheila_VIDULA_ctl),a

		; cls
		ld	hl, SCREEN_BASE
		ld	de, SCREEN_BASE+1
		ld	a, 0
		ld	(hl),a
		ld	bc, SCREEN_LEN-1
		ldir

		ld	hl, SCREEN_BASE + 64 + 640 * 5
		ld	(scr_ptr), hl
		ld	hl, message

str_loop:	ld	a, (hl)
		or	a
		jr	Z, str_done
		call	scr_char
		inc	hl
		jr	str_loop
str_done:	jr	str_done

scr_char:	push	af
		push	bc
		push	hl
		push	de

		and	#127
		sub	#32

		ld	h,0
		ld	l,a
		add	hl,hl
		add	hl,hl
		add	hl,hl
		ld	de,#font_data
		add	hl,de
		ld	de,(scr_ptr)
		ld	bc,#8
		ldir
		ld	(scr_ptr),de
		pop	de
		pop	hl
		pop	bc
		pop	af
		ret


message:		.asciz	"Hello Stardot Z80!"

mode_0_setup: 	.db	 0h7F, 0h50, 0h62, 0h28, 0h26, 0h00, 0h20, 0h23, 0h01, 0h07, 0h67, 0h08, 0h06, 0h00, 0h00, 0h00, 0h06, 0h00 ;; addr / 8



		.area   CODE_VEC (CON, ABS)
handle_res:

		; this area contains boot code and is mapped read-only to address 00xx in the CPU during boot
		; until the blitter FCFF address is written with 0hD1, writes still write memory at 00 0000
		; normally one would set up the low memory with interrupt vectors etc before switching modes

		jp	handle_res2

handle_res2:	; we are now running in ROM and can disable the boot mapping by writing to FCFF

		ld	a,#0xD1
		ld	(0xFCFF),a

		jp	handle_res3


