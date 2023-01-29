		.hd64

		.include "../includes/hardware.inc"

		.globl screen_mo7

		.macro WAIT8US
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		.endm

		.macro WAITL ?bl
		ld	hl,0
		ld	b,8
bl:		dec	h
		jr	nz, bl
		dec	l
		jr	nz, bl
		dec	b
		jr	nz, bl
		.endm


		.macro MODEx tbl, ula, ?lp

		ld	b,18
		ld	e,17
		ld	hl,tbl+17
lp:		ld	d,(hl)
		dec	hl
		ld	(sheila_CRTC_reg),de
		dec	e
		djnz	lp

		ld	a,ula
		ld	(sheila_VIDULA_ctl),a

		.endm

		.macro PAL f, ?lp, ?lp2

		exx
		ex	AF,AF'
		; set up palette as B&W
		ld	a, 7
		ld	hl, sheila_VIDULA_pal
lp:		ld	(hl), a
		add	a, 0h10
		jp	p, lp

		ld	a,0h80 + f
lp2:		ld	(hl), a
		add	a, 0h10
		jp	m, lp2

		exx
		ex	AF,AF'
		.endm

		.macro MAGNIFY ?lp, ?lp2, ?sk2, ?lp3
		; show 8 bytes from 3000-3007 magnified at bottom of screen
		exx
		ld	ix, SCREEN_BASE_MO4
		ld	hl, SCREEN_BASE_MO4+(320*24)
		ld	c, 8
lp:		ld	a,(ix+0)
		inc	ix
		ld	e,a
		ld	b, 8
lp2:		ld	a,0
		rlc	e		; shift out leftmost
		jr	nc, sk2
		dec	a
sk2:		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		ld	(hl),a
		inc	hl
		djnz	lp2
		ld	de,320-8*16
		add	hl,de
		dec	c
		jr	nz, lp
		exx
		.endm


STACK = 0h1000
SCREEN_BASE_MO7 = 0h7C00
SCREEN_SIZE_MO7 = 0h03E8
SCREEN_BASE_MO0 = 0h3000
SCREEN_SIZE_MO0 = 0h5000
SCREEN_BASE_MO4 = 0h5800
SCREEN_SIZE_MO4 = 0h2800

		.area CODE(ABS, CON)


handle_res3:
		di
		ld	sp, STACK

		; Disable and clear all VIA interrupts

		ld	a, 0h7F
		ld	(sheila_SYSVIA_ier), a
		ld	(sheila_SYSVIA_ifr), a
		ld	(sheila_USRVIA_ier), a
		ld	(sheila_USRVIA_ifr), a

		ld	a, 0hFF
		ld	(sheila_SYSVIA_ddra), a
		ld	(sheila_SYSVIA_ddrb), a
		ld	(sheila_SERIAL_ULA), a

		ld	a, 4
		ld	(sheila_SYSVIA_pcr), a ; vsync \\ CA1 negative-active-edge CA2 input-positive-active-edge CB1 negative-active-edge CB2 input-nagative-active-edge
		ld	a, 0
		ld	(sheila_SYSVIA_acr), a ; none  \\ PA latch-disable PB latch-disable SRC disabled T2 timed-interrupt T1 interrupt-t1-loaded PB7 disabled

		; disable all slow bus stuff
		ld	a,0hF
		ld	(sheila_SYSVIA_ddrb), a
$100:		ld	(sheila_SYSVIA_orb), a
		dec	a
		cp	9
		jr	nc, $100



	; SN76489 data byte format
	; %1110-wnn latch noise (channel 3) w=white noise (otherwise periodic), nn: 0=hi, 1=med, 2=lo, 3=freq from channel %10
	; %1cc0pppp latch channel (%00-%10) period (low bits)
	; %1cc1aaaa latch channel (0-3) atenuation (%0000=loudest..%1111=silent)
	; if latched 1110---- %0----nnn noise (channel 3)
	; else                %0-pppppp period (high bits)
	; See SMS Power! for details http://www.smspower.org/Development/SN76489?sid=ae16503f2fb18070f3f40f2af56807f1
	; int volume_table[16]={32767, 26028, 20675, 16422, 13045, 10362, 8231, 6568, 5193, 4125, 3277, 2603, 2067, 1642, 1304, 0};

		ld	a, 0hFF
		ld	(sheila_SYSVIA_ddra), a

		ld	a, 0h9F      		; silence channel 0
$101:
		ld	(sheila_SYSVIA_ora_nh),a  	; sample says SysViaRegH but OS uses no handshake \\ handshake regA
		ld	c,a
		ld	a,0
		ld	(sheila_SYSVIA_orb),a	; enable sound for 8us

		WAIT8US
		ld	a,8
		ld	(sheila_SYSVIA_orb), a
		WAIT8US

		ld	a,c
		add	a, 0h20
		jr	nc, $101

		; switch to mode 7 and show a nice screen


		MODEx	mode_7_setup, 0h4B

		; copy mode7 to screen
		ld	hl,screen_mo7
		ld	de,SCREEN_BASE_MO7
		ld	bc,SCREEN_SIZE_MO7
		ldir

		WAITL
		WAITL

		; show debug/version info

		; switch to version page
		ld	a,JIM_DEVNO_BLITTER
		ld	(fred_JIM_DEVNO),a
		ld	a,>jim_page_VERSION
		ld	(fred_JIM_PAGE_HI),a
		ld	a,<jim_page_VERSION
		ld	(fred_JIM_PAGE_LO),a

		ld	de,SCREEN_BASE_MO7 + 17*40
		ld	b,40*4
		ld	a,0
$106:		ld	(de),a
		inc	de
		djnz	$106

		ld	de,SCREEN_BASE_MO7 + 17*40
		ld	hl,JIM		
		ld	c,129
$102:		ld	b,0

		; a bit of colour
		ld	a,c
		ld	(de),a
		inc	de
		inc	c

		; get first byte of string
		ld	a,(hl)
		inc	l
		jr	z, $103			; jim wrap
		or	a
		jr	z, $103			; first byte of string == 0, exit	

$104:		inc	b
		ld	(de),a			; stpre to screen
		inc	de
		ld	a,(hl)
		inc	l
		jr	z, $103
		or	a
		jr	nz, $104
		; move to next line
		ld	a,b
$107:		sub	40
		jp	p, $107
		cpl
		ld	b,a
		ld	a,0
$108:		ld	(de),a
		inc	de
		djnz	$108
		jr	$102
$103:		

		WAITL
		WAITL


;;		; switch to mode 0 and do some reading an writing
		MODEx	mode_4_setup, 0h88

		PAL	3

		WAITL


		; clear screen memory
		ld	de,SCREEN_BASE_MO4+1
		ld	hl,SCREEN_BASE_MO4
		ld	a,0hFF
		ld	(hl),a
		ld	bc,SCREEN_SIZE_MO4-1
		ldir




		; increment bytes

		ld	e,0
		ld	b,0
ilo:		ld	hl,SCREEN_BASE_MO4
		ld	c,>(320*24)
ilo2:		inc	(hl)
		inc	hl
		djnz	ilo2
		dec	c
		jr	nz,ilo2

		MAGNIFY

;;;		ld	a,e
;;;		rlc	a
;;		jr	c,palw

		dec	e
		jp	nz,ilo


		WAITL
		WAITL
		WAITL
here:		jp	handle_res3


;;		; increment words
;;
;;		WAITL 2000000
;;
;;
;;		move.w	#0hFFFF,D2
;;.ilo1:		lea.l	-0hD000,A0		; FF3000
;;		move.w	#0h5000/16,D1
;;.ilo21:		addq.w	#1,(A0)+
;;		dbf	D1,.ilo21		
;;
;;		MAGNIFY
;;
;;		dbf	D2,.ilo1
;;
;;
;;		WAITL 2000000
;;
;;
;;		bra	kernel_go_todo
;;
;;
;;
;;
;;		move.l	#0h12345678,-(A7)
;;		move.l	(A7)+, D0
;;
;;lp2:
;;		movea.l #-0hD000,A0
;;		move.l	#0h5000,D1
;;		addq	#1,D0
;;lp:		addq	#1,D0
;;		move.b	D0,(A0)+
;;		dbf	D1,lp
;;		bra	lp2




mode_7_setup: 	.db 0h3F, 0h28, 0h33, 0h24, 0h1E, 0h02, 0h19, 0h1C, 0h93, 0h12, 0h72, 0h13, 0h28, 0h00, 0h00, 0h00, 0h28, 0h00 ;; HI(((mode_7_screen) - &74) EOR &20), LO(mode_7_screen)
mode_0_setup: 	.db 0h7F, 0h50, 0h62, 0h28, 0h26, 0h00, 0h20, 0h23, 0h01, 0h07, 0h67, 0h08, 0h06, 0h00, 0h00, 0h00, 0h06, 0h00 ;; addr / 8
mode_4_setup: 	.db 0h3F, 0h28, 0h31, 0h24, 0h26, 0h00, 0h20, 0h22, 0h01, 0h07, 0h67, 0h08, 0h0B, 0h00, 0h00, 0h00, 0h0B, 0h00 ;; addr / 8



		.area   CODE_VEC (CON, ABS)
handle_res:

		; this area contains boot code and is mapped read-only to address 00xx in the CPU during boot
		; until the blitter FCFF address is written with 0hD1, writes still write memory at 00 0000
		; normally one would set up the low memory with interrupt vectors etc before switching modes

		jp	handle_res2

handle_res2:	
		; on the z180 we need to map the MOS ROM into the top bank

		; first set banking boundaries, for this test we'll map: 
		; ChipRAM 		0..2FFF (Common Area 0)
		; SysRAM/screen 		3000..C000 (Banked Area)
		; the MOS ROM at 		C000 (Common Area 1)

		ld	a,#0xC3
		out0	(CBAR),a

		ld	a,#0xF0
		out0	(BBR),a

		ld	a,#0xF0
		out0	(CBR),a

		ld	a,#"a"
		ld	(0x7C02),a

; we are now running in ROM and can disable the boot mapping by writing to FCFF

		ld	a,#0xD1
		ld	bc,#0xFCFF
		out	(c),a


		jp	handle_res3

