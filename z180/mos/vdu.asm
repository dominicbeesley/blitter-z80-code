		.list(me,meb)

		.include "config.inc"

		.globl	mos_poke_SYSVIA_orb
		.globl	LE1A2
		.globl	pushIFF_DI
		.globl	popIFF
		.globl	mos_VIDPROC_set_CTL
		.globl	write_pallette_reg		
		.globl	font_data

		.area	MOS_CODE (REL, CON)


; ----------------------------------------------------------------------------
mostbl_byte_mask_4col::
		.db	0x00,0x11,0x22,0x33,0x44,0x55,0x66,0x77 ;	C31F
		.db	0x88,0x99,0xAA,0xBB,0xCC,0xDD,0xEE,0xFF ;	C327
mostbl_byte_mask_16col::
		.db	0x00,0x55,0xAA,0xFF			;	C32F
mostbl_vdu_entry_points::
		.dw	LC511RTS			; VDU 0
		.dw	mos_VDU_1			; VDU 1
		.dw	mos_VDU_2			; VDU 2
		.dw	mos_VDU_3			; VDU 3
		.dw	mos_VDU_4			; VDU 4
		.dw	mos_VDU_5			; VDU 5
		.dw	LC511RTS			; VDU 6
		.dw	mos_VDU_7			; VDU 7

		.dw	mos_VDU_8			; VDU 8
		.dw	mos_VDU_9			; VDU 9
		.dw	mos_VDU_10			; VDU 10
		.dw	mos_VDU_11			; VDU 11
		.dw	mos_VDU_12			; VDU 12
		.dw	mos_VDU_13
		.dw	mos_VDU_14
		.dw	mos_VDU_15

		.dw	mos_VDU_16
		.dw	mos_VDU_17
		.dw	mos_VDU_18
		.dw	mos_VDU_19
		.dw	mos_VDU_20
		.dw	mos_VDU_21
		.dw	mos_VDU_22
		.dw	mos_VDU_23

		.dw	mos_VDU_24
		.dw	mos_VDU_25
		.dw	mos_VDU_26
		.dw	LC511RTS
		.dw	mos_VDU_28
		.dw	mos_VDU_29
		.dw	mos_VDU_30
		.dw	mos_VDU_31

		.dw	mos_VDU_127

;****** 320 MULTIPLICATION TABLE  40COL, 80COL MODES  HIBYTE, LOBYTE ******
; note: this is *640 on the 6502 but we have add HL,HL etc

_MUL320_TABLE:	.dw	320 *  0
		.dw	320 *  1
		.dw	320 *  2
		.dw	320 *  3
		.dw	320 *  4
		.dw	320 *  5
		.dw	320 *  6
		.dw	320 *  7
		.dw	320 *  8
		.dw	320 *  9
		.dw	320 * 10
		.dw	320 * 11
		.dw	320 * 12
		.dw	320 * 13
		.dw	320 * 14
		.dw	320 * 15
		.dw	320 * 16
		.dw	320 * 17
		.dw	320 * 18
		.dw	320 * 19
		.dw	320 * 20
		.dw	320 * 21
		.dw	320 * 22
		.dw	320 * 23
		.dw	320 * 24
		.dw	320 * 25
		.dw	320 * 26
		.dw	320 * 27
		.dw	320 * 28
		.dw	320 * 29
		.dw	320 * 30
		.dw	320 * 31

;****** *40 MULTIPLICATION TABLE  TELETEXT  MODE   HIBYTE, LOBYTE  ******

_MUL40_TABLE:	.dw	40 *  0
		.dw	40 *  1
		.dw	40 *  2
		.dw	40 *  3
		.dw	40 *  4
		.dw	40 *  5
		.dw	40 *  6
		.dw	40 *  7
		.dw	40 *  8
		.dw	40 *  9
		.dw	40 * 10
		.dw	40 * 11
		.dw	40 * 12
		.dw	40 * 13
		.dw	40 * 14
		.dw	40 * 15
		.dw	40 * 16
		.dw	40 * 17
		.dw	40 * 18
		.dw	40 * 19
		.dw	40 * 20
		.dw	40 * 21
		.dw	40 * 22
		.dw	40 * 23
		.dw	40 * 24




mostbl_vdu_q_lengths::	; 2's complement
		.db	0x00,0xFF,0x00,0x00,0x00,0x00,0x00,0x00	; 0-7
		.db	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 ; 8-15
		.db	0x00,0xFF,0xFE,0xFB,0x00,0x00,0xFF,0xF7 ; 16-23
		.db	0xF8,0xFB,0x00,0x00,0xFC,0xFC,0x00,0xFE ; 24-31
		.db	0x00

; TEXT WINDOW -BOTTOM ROW LOOK UP TABLE
mostbl_vdu_window_bottom::
		.db	0xC0,0x1F,0x1F,0x1F,0x18,0x1F,0x1F,0x18 ;	C3E6
		.db	0x18				;	C3EE
; TEXT WINDOW -RIGHT HAND COLUMN LOOK UP TABLE
mostbl_vdu_window_right::
		.db	0x4F,0x27,0x13,0x4F,0x27,0x13,0x27,0x27 ;	C3EF
mostbl_VDU_VIDPROC_CTL_by_mode::
		.db	0x9C,0xD8,0xF4,0x9C,0x88,0xC4,0x88,0x4B ;	C3F7
mostbl_VDU_bytes_per_char::
		.db	0x08,0x10,0x20,0x08,0x08,0x10,0x08,0x01 ;	C3FF
mostbl_VDU_pix_mask_16colour::
		.db	0xAA,0x55				;	C407
mostbl_VDU_pix_mask_4colour::
		.db	0x88,0x44,0x22,0x11			;	C409
mostbl_VDU_pix_mask_2colour::
		.db	0x80,0x40,0x20,0x10,0x08,0x04,0x02	;	C40D
mostbl_VDU_mode_colours_m1::	; - spills into next table
		.db	0x01,0x03,0x0F,0x01,0x01,0x03,0x01	 ;	C414
mostbl_GCOL_options_proc0::
		.db	0x00
; GCOL PLOT OPTIONS PROCESSING LOOK UP TABLE
mostbl_GCOL_options_proc::
		.db	0xFF,0x00,0x00,0xFF,0xFF,0xFF,0xFF,0x00 ;	C41C
; 2 COLOUR MODES PARAMETER LOOK UP TABLE
mostbl_2_colour_pixmasks::
		.db	0x00,0xFF				;	C424
; 4 COLOUR MODES PARAMETER LOOK UP TABLE
mostbl_4_colour_pixmasks::
		.db	0x00,0x0F,0xF0,0xFF			;	C426
; 16 COLOUR MODES PARAMETER LOOK UP TABLE
mostbl_16_colour_pixmasks::
		.db	0x00,0x03,0x0C,0x0F,0x30,0x33,0x3C,0x3F ;	C42A
		.db	0xC0,0xC3,0xCC,0xCF,0xF0,0xF3,0xFC,0xFF ;	C432
mostbl_leftmost_pixels::
		.db	0x80,0x88,0xAA
; modes 3,6,7 are 0 but get set to 0x7 in vdu_init
mostbl_VDU_pixels_per_byte_m1::
		.db	0x07,0x03,0x01,0x00,0x07,0x03		;	C43A
; mode size
mostbl_VDU_mode_size::	; note first two entries shared by previous tbl
		.db	0x00,0x00,0x00,0x01,0x02,0x02,0x03,0x04 ;	C440
; SOUND PITCH OFFSET BY CHANNEL LOOK UP TABLE ???CHECK
mostbl_SOUND_PITCH_OFFSET_BY_CHANNEL_LOOK_UP_TABLE::
		.db	0x00,0x06,0x02			;	C448

; sent direct to orb of SYSVIA dependent on mode_size
mostbl_VDU_hwscroll_offb1::
		.db	0x0D,0x05,0x0D,0x05			;	C44B
; sent direct to orb of SYSVIA dependent on mode_size
mostbl_VDU_hwscroll_offb2::
		.db	0x04,0x04,0x0C,0x0C,0x04		;	C44F

; where to jump to in CLS unwound
;;;mostbl_VDU_cls_vecjmp
;;	.dw	cls_Mode_012_entry_point
;;	.dw	cls_Mode_3_entry_point
;;	.dw	cls_Mode_45_entry_point
;;	.dw	cls_Mode_6_entry_point
;;	.dw	cls_Mode_7_entry_point
mostbl_VDU_screensize_h::
		.db	0x50,0x40,0x28,0x20,0x04		;	C459
mostbl_VDU_screebot_h::
		.db	0x30,0x40,0x58,0x60,0x7C		;	C45E
mostbl_VDU_bytes_per_row_low::
		.db	0x28,0x40,0x80			;	C463
; pointers to tables of 6845 values that follow this by
mostbl_VDU_ptr_end_6845tab::
		.db	0x0B + 1
		.db	0x17 + 1
		.db	0x23 + 1
		.db	0x2F + 1
		.db	0x3B + 1
mostbl_VDU_6845_mode_012::
		.db	0x7F,0x50,0x62,0x28,0x26,0x00,0x20,0x22,0x01,0x07,0x67,0x08
mostbl_VDU_6845_mode_3::
		.db	0x7F,0x50,0x62,0x28,0x1E,0x02,0x19,0x1B,0x01,0x09,0x67,0x09
mostbl_VDU_6845_mode_45::
		.db	0x3F,0x28,0x31,0x24,0x26,0x00,0x20,0x22,0x01,0x07,0x67,0x08
mostbl_VDU_6845_mode_6::
		.db	0x3F,0x28,0x31,0x24,0x1E,0x02,0x19,0x1B,0x01,0x09,0x67,0x09
mostbl_VDU_6845_mode_7::
		.db	0x3F,0x28,0x33,0x24,0x1E,0x02,0x19,0x1B,0x93,0x12,0x72,0x13
;; ----------------------------------------------------------------------------
;; VDU ROUTINE VECTOR ADDRESSES !!!!!ADDRESSES!!!!
mostbl_drawline_major_routine::
		.dw	x_drawline_major_right				;	C4AA
		.dw	x_drawline_major_up				;	C4AC
mostbl_drawline_minor_routine::
		.dw	x_drawline_minor_right
		.dw	x_drawline_minor_left
		.dw	x_drawline_minor_up
		.dw	x_drawline_minor_down
;; TELETEXT CHARACTER CONVERSION TABLE
mostbl_TTX_CHAR_CONV::
		.db	0x23,0x5F,0x60,0x23			;	C4B6
;; SOFT CHARACTER RAM ALLOCATION
mostbl_SOFT_CHARACTER_RAM_ALLOCATION::
		.db	0x04,0x05,0x06,0x00,0x01,0x02		;	C4BA


;; ----------------------------------------------------------------------------
mos_VDU_WRCH::	ld	E,A				; put A into E!
		ld	A,(sysvar_VDU_Q_LEN)
		or	A,A
		jr	NZ, mos_VDU_WRCH_add_to_Q	;	C4C3
		bit	6,(IY+zpIY_vdu_status)
		jr	Z,mos_VDU_WRCH_sk_nocurs
		call	x_start_curs_edit		;	C4C9
		call	x_setup_write_cursor		;	C4CC
		jp	M, mos_VDU_WRCH_sk_nocurs	;	C4CF
		ld	A,0x0D
		xor	A,E
		jr	NZ,mos_VDU_WRCH_sk_nocurs	;	C4D3
		call	x_cancel_cursor_edit		;	C4D5
mos_VDU_WRCH_sk_nocurs:
		ld	A,E
		cp	A,0x7F				;	C4D8
		jr	Z, vdu_jumptable_20		;	C4DA
		cp	A,0x20				;	C4DC
		jr	C,vdu_jumptable_A		;	C4DE
		bit	7,(IY+zpIY_vdu_status)		;	C4E0
		jr	NZ,mos_VDU_WRCH_sk_novdu	;	C4E2
		call	render_char				;	C4E4
		call	mos_VDU_9			;	C4E7
mos_VDU_WRCH_sk_novdu:
		jp	x_main_exit_routine		;	LC4EA
;; ----------------------------------------------------------------------------
;; read linkFDBesses and number of parameters???
vdu_jumptable_20:
		ld	A,0x20				; treat 7F as 20 when doing lookup
;; read linkFDBesses and number of parameters???
vdu_jumptable_A::	TODO "vdu_jumptable_A"
;
;		tfr	A,B				;	C4EF
;		ldx	#mostbl_vdu_q_lengths
;		lda	B,X
;		aslb
;		ldx	#mostbl_vdu_entry_points
;		ldx	B,X
;		tsta
;		beq	x_vdu_no_q
;		sta	sysvar_VDU_Q_LEN
;		stx	vduvar_VDU_VEC_JMP
;	IF CPU_6809
;		ldb	#0x40
;		bitb	zp_vdu_status
;	ELSE
;		tim	#0x40, zp_vdu_status
;	ENDIF
;		bne	LC52F				; cursor editing in force
;		;TODO - check if this is needed!
;		CLC
LC511RTS::	TODO "LC511RTS"
;
;		rts
;; ----------------------------------------------------------------------------
;; B, sysvar_VDU_Q_LEN are 2's complement of number of parameters. **{NETV=>vduvar_Q+5-0x100}
mos_VDU_WRCH_add_to_Q::	TODO "mos_VDU_WRCH_add_to_Q"
;
;		ldx	#vduvar_VDU_Q_END
;		sta	B,X				;	C512
;		incb					;	C515
;		stb	sysvar_VDU_Q_LEN		;	C516
;		bne	LC532				;	C519
;	IF CPU_6809
;		pshs	B
;		ldb	zp_vdu_status			;	C51B
;		bitb	#0xC0
;		puls	B				; TODO get rid of push/pop?
;	ELSE
;		tim	#0xC0, zp_vdu_status
;	ENDIF
;		bmi	mos_exec_vdu1			; bit 7 set - VDU disabled
;		bne	LC526				; bit 6 set - cursor editing in force
;		jsr	[vduvar_VDU_VEC_JMP]
;		CLC					;	C524
;		rts					;	C525
; ----------------------------------------------------------------------------
;LC526:		jsr	x_start_curs_edit		;	C526
;		jsr	x_setup_write_cursor		;	C529
;		jsr	[vduvar_VDU_VEC_JMP]
;LC52F:		jsr	x_cursor_editing_routines	;	C52F
;LC532:		CLC					;	C532
;		rts					;	C533
;; ----------------------------------------------------------------------------
;; 1 parameter required;	 
mos_exec_vdu1::	TODO "mos_exec_vdu1"
;
;		TODOSKIP "Printer character skip"	; printer rediretcted here???
;;	ldb	vduvar_VDU_VEC_JMP			; get top byte of jump
;;	cmpb	#0xC5					; not used like this any more!
;		bne	LC532				;	C539
mos_VDU_1::	TODO "mos_VDU_1"
;
;		ldb	zp_vdu_status
;		lsrb
;		bcc	LC511RTS
;		jmp	LE11E				; send to printer
;; ----------------------------------------------------------------------------
;; if explicit linkFDBess found, no parameters
;x_if_explicit_linkFDBess_found_no_parameters:
x_vdu_no_q::	TODO "x_vdu_no_q"
;
;		stx	vduvar_VDU_VEC_JMP		;	C545

;		lsrb					; this was asl'd above, set back
;		; set C if char > 8 and < 13

;		eorb	#0xFF
;		cmpb	#0xF7
;		eorb	#0xFF
;		bcc	LC553
;		cmpb	#0x13

;LC553:		tst	zp_vdu_status			;	C553
;		bmi	x_reenable_vdu_if_vdu6		;	vdu disabled
;		pshs	CC
;		jsr	[vduvar_VDU_VEC_JMP]
;		puls	CC				;	C55B
;		bcc	LC561				;	C55C
;; main exit routine
x_main_exit_routine:
		ld	A,(zp_vdu_status)		;VDU status byte
		rla					;Carry is set if printer is enabled
LC561:		
		bit	6,(IY+zpIY_vdu_status)
		ret	Z
;; cursor editing routines
x_cursor_editing_routines::	TODO "x_cursor_editing_routines"
;
;		jsr	x_setup_read_cursor		;restore normal write cursor

x_start_curs_edit::	TODO "x_start_curs_edit"
;	;LC568
;		pshs	A,CC
;		ldx	#vduvar_TXT_CUR_X		;	C56A
;		ldy	#vduvar_TEXT_IN_CUR_X		;	C56C
;		jsr	x_exchange_2atY_with_2atX	;	C56E
;		jsr	x_set_up_displayaddress		;	C571
;		ldx	zp_vdu_top_scanline
;		jsr	x_set_cursor_position_HL		;	C574
;		lda	zp_vdu_status			;	C577
;		eora	#0x02				; toggle scrolling disabled
;		sta	zp_vdu_status			;	C57B
;		puls	A,CC,PC

;; ----------------------------------------------------------------------------
x_reenable_vdu_if_vdu6::	TODO "x_reenable_vdu_if_vdu6"
;
;		eorb	#0x06
;		bne	LC58Crts
;		lda	#0x7F
;		bra	mos_VDU_and_A_vdustatus

;; check text cursor in use
x_check_text_cursor_in_use::	TODO "x_check_text_cursor_in_use"
;
;		lda	zp_vdu_status
;		anda	#0x20
LC58Crts::	TODO "LC58Crts"
;
;		rts					;	C58C
;; ----------------------------------------------------------------------------
;; SET PAGED MODE  VDU 14;  
mos_VDU_14::	TODO "mos_VDU_14"
;
;		clr	sysvar_SCREENLINES_SINCE_PAGE	;	C58F
;		lda	#0x04				;	C592
;		bra	x_ORA_with_vdu_status				;	C594
;; VDU 2 PRINTER ON
mos_VDU_2::	TODO "mos_VDU_2"
;
;		TODOSKIP "VDU 2"
;		rts
;	jsr	LE1A2				;	C596
;	lda	#0x94				;	C599
;; no parameters
mos_VDU_21::	TODO "mos_VDU_21"
;
;		lda	#0x80
x_ORA_with_vdu_status:
		or	A,(IY+zpIY_vdu_status)				
		jr	LC5AA				;	C59F
;; No parameters
mos_VDU_3::	call	LE1A2				;	C5A1
		ld	A,0x0A				;	C5A4
;; VDU 15 paged mode off	  No parameters
mos_VDU_15:
		ld	A,~0x04
mos_VDU_and_A_vdustatus:
		and	A,(IY+zpIY_vdu_status)		;	C5A8
LC5AA:		ld	(zp_vdu_status),A		;	C5AA		
LC5ACrts:	ret					;	C5AC
;; ----------------------------------------------------------------------------
;; VDU 4 select Text Cursor  No parameters;  
mos_VDU_4::	TODO "mos_VDU_4"
;
;		lda	vduvar_PIXELS_PER_BYTE_MINUS1
;		beq	LC5ACrts
;		jsr	x_crtc_reset_cursor
;		lda	#0xDF
;		bra	mos_VDU_and_A_vdustatus
;; VDU 5 set graphics cursor
mos_VDU_5::	TODO "mos_VDU_5"
;
;		lda	vduvar_PIXELS_PER_BYTE_MINUS1
;		beq	LC5ACrts
;		lda	#0x20
;		jsr	x_crtc_set_cursor
;		bra	x_ORA_with_vdu_status
;; VDU 8	 CURSOR LEFT	 NO PARAMETERS
mos_VDU_8::	TODO "mos_VDU_8"
;
;		jsr	x_check_text_cursor_in_use	;	C5C5
;		bne	x_cursor_left_and_down_with_graphics_cursor_in_use;	C5C8
;		dec	vduvar_TXT_CUR_X		;	C5CA
;		ldb	vduvar_TXT_CUR_X		;	C5CD
;		cmpb	vduvar_TXT_WINDOW_LEFT		;	C5D0
;		bmi	x_execute_wraparound_left_up	;	C5D3
;		ldb	vduvar_6845_CURSOR_ADDR	+ 1	;	C5D5
;		subb	vduvar_BYTES_PER_CHAR		;	C5D9
;		lda	vduvar_6845_CURSOR_ADDR		;	C5DD
;		sbca	#0x00				;	C5E0
;		cmpa	vduvar_SCREEN_BOTTOM_HIGH	;	C5E2
;		bhs	LC5EA				;	C5E5
;		adda	vduvar_SCREEN_SIZE_HIGH		;	C5E7
;LC5EA:		tfr	D,X				;	C5EA
;		jmp	mos_set_cursor_HL		;	C5EB
;; ----------------------------------------------------------------------------
;; execute wraparound left-up
x_execute_wraparound_left_up::	TODO "x_execute_wraparound_left_up"
;
;		lda	vduvar_TXT_WINDOW_RIGHT		;	C5EE
;		sta	vduvar_TXT_CUR_X		;	C5F1
;; cursor up
x_cursor_up::	TODO "x_cursor_up"
;
;		dec	sysvar_SCREENLINES_SINCE_PAGE	;	C5F4
;		bpl	LC5FC				;	C5F7
;		inc	sysvar_SCREENLINES_SINCE_PAGE	;	C5F9
;LC5FC:		ldb	vduvar_TXT_CUR_Y		;	C5FC
;		cmpb	vduvar_TXT_WINDOW_TOP		;	C5FF
;		beq	x_cursor_at_top_of_window	;	C602
;		dec	vduvar_TXT_CUR_Y		;	C604
;		jmp	x_setup_displayaddress_and_cursor_position
;; ----------------------------------------------------------------------------
;; cursor at top of window
x_cursor_at_top_of_window::	TODO "x_cursor_at_top_of_window"
;
;		CLC
;		jsr	x_move_text_cursor_to_next_line ;	C60B
;	IF CPU_6809
;		lda	#0x08				;	C60E
;		bita	zp_vdu_status			;	C610
;	ELSE
;		tim	#0x08, zp_vdu_status
;	ENDIF
;		bne	LC619				;	C612
;		jsr	x_adjust_screen_RAM_addresses	;	C614
;		bne	LC61C				;	C617
;LC619:		jsr	x_soft_scroll1line		;	C619
;LC61C:		jmp	x_clear_a_line_then_setup_displayaddress_and_cursor_position				;	C61C
;; ----------------------------------------------------------------------------
;; cursor left and down with graphics cursor in use
x_cursor_left_and_down_with_graphics_cursor_in_use::	TODO "x_cursor_left_and_down_with_graphics_cursor_in_use"
;
;		clrb				;	C61F
;; cursor down with graphics in use; B=2 for vertical or 0 for horizontal 
x_cursor_down_with_graphics_in_use::	TODO "x_cursor_down_with_graphics_in_use"
;
;		stb	zp_vdu_wksp + 1			;	C621
;		jsr	x_Check_window_limits		;	C623
;		ldb	zp_vdu_wksp + 1			;	C626
;		ldx	#vduvar_GRA_CUR_INT + 1
;		lda	b,x				;	C629
;		suba	#0x08				;	C62C
;		sta	b,x				;	C62E
;		bcc	LC636				;	C631
;		decb
;		dec	b,x				;	C633
;LC636:		lda	zp_vdu_wksp			;	C636
;		bne	jmp_cal_ext_coors				;	C638
;		jsr	x_Check_window_limits		;	C63A
;		beq	jmp_cal_ext_coors				;	C63D
;		ldy	#vduvar_GRA_WINDOW_RIGHT + 1
;		ldb	zp_vdu_wksp+1			;	C63F
;		lda	b,y				;	C641
;		cmpb	#0x01				;	C644
;		bhs	LC64A				;	C646
;		;;TODO check
;		suba	#0x07				;	C648		-- check
;LC64A:		sta	b,x				;	C64A
;		dec	b
;		lda	b,y				;	C64D
;		sbca	#0x00				;	C650
;		sta	b,x				;	C652
;		incb
;		beq	LC660				;	C656
jmp_cal_ext_coors::	TODO "jmp_cal_ext_coors"
;	; LC658
;		jmp	x_calculate_external_coordinates_from_internal_coordinates;	C658
;; ----------------------------------------------------------------------------
;; VDU 11 Cursor Up    No Parameters
mos_VDU_11::	TODO "mos_VDU_11"
;
;		jsr	x_check_text_cursor_in_use	;	C65B
;		lbeq	x_cursor_up			;	C65E
;LC660:		ldb	#0x02				;	C660
;		bra	x_graphic_cursor_up_Beq2	;	C662
;; VDU 9 Cursor right	No parameters
mos_VDU_9:
		bit	5,(IY+zpIY_vdu_status)
		jp	NZ,x_graphic_cursor_right	;	C668
		ld	A,(vduvar_TXT_CUR_X)		;	C66A
		cp	A,(IX+vduIX_TXT_WINDOW_RIGHT)	;	C66D
		jr	NC,x_text_cursor_down_and_right	;	C670
		inc	(IX+vduIX_TXT_CUR_X)		;	C672
		ld	HL,(vduvar_6845_CURSOR_ADDR)
		ld	E,(IX+vduIX_BYTES_PER_CHAR)
		ld	D,0
		add	HL,DE
		jp	mos_set_cursor_HL		;	C681
;; ----------------------------------------------------------------------------
;; : text cursor down and right
x_text_cursor_down_and_right::	TODO "x_text_cursor_down_and_right"
;
;		lda	vduvar_TXT_WINDOW_LEFT
;		sta	vduvar_TXT_CUR_X
;; : text cursor down
x_text_cursor_down::	TODO "x_text_cursor_down"
;
;		CLC
;		jsr	x_control_scrolling_in_paged_mode_2
;		ldb	vduvar_TXT_CUR_Y
;		cmpb	vduvar_TXT_WINDOW_BOTTOM
;		bhs	LC69B
;		inc	vduvar_TXT_CUR_Y
;		bra	x_setup_displayaddress_and_cursor_position
;LC69B:		jsr	x_move_text_cursor_to_next_line
;	IF CPU_6809
;		lda	#0x08
;		bita	zp_vdu_status
;	ELSE
;		tim	#0x08, zp_vdu_status
;	ENDIF
;		bne	LC6A9
;		jsr	x_adjust_screen_RAM_addresses_one_line_scroll
;		bra	x_clear_a_line_then_setup_displayaddress_and_cursor_position
;LC6A9:		jsr	x_execute_upward_scroll
x_clear_a_line_then_setup_displayaddress_and_cursor_position::	TODO "x_clear_a_line_then_setup_displayaddress_and_cursor_position"
;
;		jsr	x_clear_a_line
x_setup_displayaddress_and_cursor_position::	TODO "x_setup_displayaddress_and_cursor_position"
;
;		jsr	x_set_up_displayaddress
;		ldx	zp_vdu_top_scanline
;		jmp	x_set_cursor_position_HL

;; graphic cursor right
x_graphic_cursor_right::	TODO "x_graphic_cursor_right"
;
;		clrb
;; graphic cursor up  (B=2)
x_graphic_cursor_up_Beq2::	TODO "x_graphic_cursor_up_Beq2"
;
;		stb	zp_vdu_wksp+1			;	C6B6
;		jsr	x_Check_window_limits		;	C6B8
;		ldb	zp_vdu_wksp+1			;	C6BB
;		ldx	#vduvar_GRA_CUR_INT + 1
;		lda	b,x				;	C6BE
;		adda	#0x08				;	C6C1
;		sta	b,x				;	C6C3
;		bcc	LC6CB				;	C6C6
;		decb
;		inc	b,x				;	C6C8
;LC6CB:		lda	zp_vdu_wksp			;	C6CB
;		bne	jmp_cal_ext_coors		;	C6CD
;		jsr	x_Check_window_limits		;	C6CF
;		beq	jmp_cal_ext_coors		;	C6D2
;		ldb	zp_vdu_wksp+1			;	C6D4
;		ldy	#vduvar_GRA_WINDOW_LEFT
;		lda	b,x				;	C6D6
;		cmpb	#0x01				;	C6D9
;		blo	LC6DF				;	C6DB
;		;;TODO check
;		adda	#0x07				;	C6DD
;LC6DF:		sta	b,x				;	C6DF
;		decb
;		lda	b,y				;	C6E2
;		adca	#0x00				;	C6E5
;		sta	b,x				;	C6E7
;		incb					;	C6EA
;		beq	LC6F5				;	C6EB
;		jmp	x_calculate_external_coordinates_from_internal_coordinates;	C6ED
;; ----------------------------------------------------------------------------
;; VDU 10  Cursor down	  No parameters
mos_VDU_10::	TODO "mos_VDU_10"
;
;		jsr	x_check_text_cursor_in_use	;	C6F0
;		lbeq	x_text_cursor_down		;	C6F3
;LC6F5:		ldb	#0x02				;	C6F5
;		jmp	x_cursor_down_with_graphics_in_use;	C6F7
;; ----------------------------------------------------------------------------
;; VDU 28   define text window	      4 parameters; parameters are set up thus ; 0320  P1 left margin ; 0321  P2 bottom margin ; 0322  P3 right margin ; 0323  P4 top margin ; Note that last parameter is always in 0323 
mos_VDU_28::	TODO "mos_VDU_28"
;
;		ldb	vduvar_MODE
;		ldx	#mostbl_vdu_window_bottom+1
;		lda	vduvar_VDU_Q_END - 3
;		cmpa	vduvar_VDU_Q_END - 1
;		blo	LC758rts
;		cmpa	b,x
;		bhi	LC758rts
;		lda	vduvar_VDU_Q_END - 2
;		ldx	#mostbl_vdu_window_right
;		cmpa	b,x
;		bhi	LC758rts
;		suba	vduvar_VDU_Q_END - 4
;		bmi	LC758rts
;		jsr	LCA88_newAPI
;		lda	#0x08
;		jsr	x_ORA_with_vdu_status
;		ldx	#vduvar_VDU_Q_END - 4
;		ldy	#vduvar_TXT_WINDOW_LEFT
;		jsr	copy4fromXtoY
;		jsr	x_check_text_cursor_in_window_setup_display_addr
;		bcs	mos_VDU_30
LC732_set_cursor_position::	TODO "LC732_set_cursor_position"
;
;		ldx	zp_vdu_top_scanline				; CHECK!
;		jmp	x_set_cursor_position_HL
;; ----------------------------------------------------------------------------
;; OSWORD 9    read a pixel; on entry &EF=A=9 ; &F0=X=low byte of parameter blockFDBess ; &F1=Y=high byte of parameter blockFDBess ; PARAMETER BLOCK ; bytes 0,1 X coordinate, bytes 2,3 Y coordinate ; EXIT with result in byte 4 =&FF if point was of screen
;mos_OSWORD_9:
;	ldy	#0x03				;	C735
;LC737::	lda	(zp_mos_OSBW_X),y		;	C737
;	sta	vduvar_TEMP_8,y		;	C739
;	dey					;	C73C
;	bpl	LC737				;	C73D
;	lda	#0x28				;	C73F
;	jsr	x_pixel_reading			;	C741
;	ldy	#0x04				;	C744
;	bne	LC750				;	C746
;; OSWORD 11	  read pallette; on entry &EF=A=11 ; &F0=X=low byte of parameter blockFDBess ; &F1=Y=high byte of parameter blockFDBess ; PARAMETER BLOCK ; bytes 0,logical colour to read		       ; EXIT with result in  4 bytes:-0 logical colour,1
;mos_OSWORD_11:
;	and	vduvar_COL_COUNT_MINUS1		;	C748
;	tax					;	C74B
;	lda	vduvar_PALLETTE,x		;	C74C
;LC74F::	iny					;	C74F
;LC750::	sta	(zp_mos_OSBW_X),y		;	C750
;	lda	#0x00				;	C752
;	cpy	#0x04				;	C754
;	bne	LC74F				;	C756
LC758rts::	TODO "LC758rts"
;
;		rts					;	C758
;; ----------------------------------------------------------------------------
;; VDU 12  Clear text Screen		  0 parameters;	 
mos_VDU_12::	TODO "mos_VDU_12"
;
;		jsr	x_check_text_cursor_in_use
;		bne	x_mos_home_CLG
;		lda	zp_vdu_status
;		anda	#0x08
;		lbeq	LCBC1_clear_whole_screen
;LC767:		ldb	vduvar_TXT_WINDOW_TOP
;LC76A:		stb	vduvar_TXT_CUR_Y
;		jsr	x_clear_a_line
;		ldb	vduvar_TXT_CUR_Y
;		cmpb	vduvar_TXT_WINDOW_BOTTOM
;		incb
;		bcc	LC76A
;; VDU 30  Home cursor			  0  parameters
mos_VDU_30::	TODO "mos_VDU_30"
;
;		jsr	x_check_text_cursor_in_use
;		beq	LC781
;		jmp	x_home_graphics_cursor
;; ----------------------------------------------------------------------------
;LC781:		clr	vduvar_VDU_Q_END - 1
;		clr	vduvar_VDU_Q_END - 2
;; VDU 31  Position text cursor		  2  parameters; 0322 = X coordinate ; 0323 = Y coordinate 
mos_VDU_31::	TODO "mos_VDU_31"
;
;		jsr	x_check_text_cursor_in_use
;		bne	LC758rts
;		jsr	LC7A8
;		lda	vduvar_VDU_Q_END - 2
;		adda	vduvar_TXT_WINDOW_LEFT
;		sta	vduvar_TXT_CUR_X
;		lda	vduvar_VDU_Q_END - 1
;		adda	vduvar_TXT_WINDOW_TOP
;		sta	vduvar_TXT_CUR_Y
;		jsr	x_check_text_cursor_in_window_setup_display_addr
;		bcc	LC732_set_cursor_position
;LC7A8:		ldx	#vduvar_TXT_CUR_X
;		ldy	#vduvar_TEMP_8
;		jmp	x_exchange_2atY_with_2atX
;; ----------------------------------------------------------------------------
;; VDU  13	  Carriage  Return	  0 parameters
mos_VDU_13::	TODO "mos_VDU_13"
;
;		jsr	x_check_text_cursor_in_use	;	C7AF
;		beq	LC7B7				;	C7B2
;		jmp	x_set_graphics_cursor_to_left_hand_column;	C7B4
;LC7B7:		jsr	x_cursor_to_window_left				;	C7B7
;		jmp	x_setup_displayaddress_and_cursor_position				;	C7BA
;; ----------------------------------------------------------------------------
x_mos_home_CLG::	TODO "x_mos_home_CLG"
;	; LC7BD
;		jsr	x_home_graphics_cursor			


;; VDU 16 clear graphics screen		  0 parameters
mos_VDU_16::	TODO "mos_VDU_16"
;
;		lda	vduvar_PIXELS_PER_BYTE_MINUS1		; pixels per byte
;		beq	LC7F8rts				; if 0 current mode has no graphics so exit
;		lda	vduvar_GRA_BACK				; Background graphics colour
;		ldb	vduvar_GRA_PLOT_BACK			; background graphics plot mode (GCOL n)
;		jsr	x_set_gra_masks_newAPI			; set graphics byte mask in &D4/5
;		ldx	#vduvar_GRA_WINDOW_LEFT			; graphics window
;		ldy	#vduvar_TEMP_8				; workspace
;		jsr	copy8fromXtoY				; set(300/7+Y) from (300/7+X)
;		lda	vduvar_GRA_WINDOW_TOP + 1		; graphics window top lo.
;		suba	vduvar_GRA_WINDOW_BOTTOM + 1		; graphics window bottom lo
;		inca						; increment
;		sta	vduvar_GRA_WKSP				; and store in workspace (this is line count)
;10x:		ldx	#vduvar_TEMP_8 + 4			; right
;		ldy	#vduvar_TEMP_8				; left
;		jsr	x_vdu_clear_gra_line_newAPI		; clear line
;		lda	vduvar_TEMP_8 + 7			; decrement window top in pixels
;		bne	2F					; 
;		dec	vduvar_TEMP_8 + 6			; 
;20x:		dec	vduvar_TEMP_8 + 7			; 
;		dec	vduvar_GRA_WKSP				; decrement line count
;		bne	1B					; if <>0 then do it again
;LC7F8rts:	rts					; exit
;; ----------------------------------------------------------------------------
;; COLOUR; parameter in &0323 
mos_VDU_17::	TODO "mos_VDU_17"
;	; COLOUR
;		ldb	#0x00				;	C7F9
;		bra	LC7FF				;	C7FB
;; GCOL; parameters in 323,322 
mos_VDU_18::	TODO "mos_VDU_18"
;	; GCOL
;		ldb	#0x02
;LC7FF:		lda	vduvar_VDU_Q_END - 1
;		bpl	LC805
;		incb
;LC805:		anda	vduvar_COL_COUNT_MINUS1
;		sta	zp_vdu_wksp
;		lda	vduvar_COL_COUNT_MINUS1
;		beq	LC82B
;		anda	#0x07
;		adda	zp_vdu_wksp
;		ldx	#mostbl_2_colour_pixmasks-1
;		lda	a,x
;		ldy	#vduvar_TXT_FORE
;		sta	b,y
;		cmpb	#0x02
;		bhs	LC82C
;		lda	vduvar_TXT_FORE
;		coma
;		sta	zp_vdu_txtcolourEOR
;		eora	vduvar_TXT_BACK
;		sta	zp_vdu_txtcolourOR
;LC82B:		rts
;LC82C:		lda	vduvar_VDU_Q_END - 2
;		ldy	#vduvar_GRA_FORE
;		sta	b,y
;		rts
;; ----------------------------------------------------------------------------
;LC833:		lda	#0x20				;	C833
;		sta	vduvar_TXT_BACK			;	C835
;		rts					;	C838
;; ----------------------------------------------------------------------------
;; VDU 20	  Restore default colours	  0 parameters;	 
mos_VDU_20::	
		; zero all colours
		ld	B, 6				;	C839
		xor	A,A				;	C83B
		ld	HL, vduvar_TXT_FORE
LC83D:		ld	(HL),A				;	C83D
		djnz	LC83D				;	C841
		LD	E,A				; = 0
		ld	A,(vduvar_COL_COUNT_MINUS1)	;	C843
		or	A,A
		jr	Z,x_2colour_mode		; It's mode 7 leave as 0
		ld	E, 0xFF				; All white
		cp	A, 15				; Check for 16 colour mode
		jr	NZ, LC850			; Jump if not
		ld	E, 0x3F				; If it is turn off flash
LC850:		ld	B,A				; remember # of colours
		ld	A,E
		ld	(vduvar_TXT_FORE), A		; Store fore colours
		ld	(vduvar_GRA_FORE), A		;	C853
		cpl					;	C856
		ld	(zp_vdu_txtcolourOR), A		; Setup VDU 4 masks
		ld	(zp_vdu_txtcolourEOR), A		; 

		; setup parameters for calling pallette setup
		ld	A,B
		ld	(IX+vduIX_VDU_Q_END-5), A	; colour #

		cp	A, 3				;	C85F
		jr	Z, x_4_colour_mode		;	C861
		jp	C, x_2colour_mode		;	C863
		; 16 colour mode do them all...
		ld	(IX+vduIX_VDU_Q_END-4), A	;	C865
LC868:		call	mos_VDU_19			;	C868
		dec	(IX+vduIX_VDU_Q_END-4)		;	Q-4
		dec	(IX+vduIX_VDU_Q_END-5)		;	Q-5
		jp	P, LC868			;	C871
		ret					;	C873
;; ----------------------------------------------------------------------------
;; 4 colour mode
x_4_colour_mode::	
		ld	A, 7				;	C874
		ld	(IX+vduIX_VDU_Q_END-4), A	;	C876
LC879:		call	mos_VDU_19			;	C879
		sra	(IX+vduIX_VDU_Q_END-4)		; Q-4
		dec	(IX+vduIX_VDU_Q_END-5)		; Q - 5
		jp	P, LC879			;	C882
		ret					;	C884
; ----------------------------------------------------------------------------
x_2colour_mode:	ld	A, 7				;	White
		call	LC88F				;	C887
		xor	A,A				;	Black
		ld	(IX+vduIX_VDU_Q_END-5),A	;	C88C
LC88F:		ld	(IX+vduIX_VDU_Q_END-4),A	;	C88F
; VDU 19   define logical colours		  5 parameters; &31F=first parameter logical colour ; &320=second physical colour 
mos_VDU_19::	

		call	pushIFF_DI
		ld	D,0
		ld	E,(IX+vduIX_VDU_Q_END-5)	; E <= logical colour
		ld	A,(vduvar_COL_COUNT_MINUS1)	; 
		ld	C,A				; save it
		and	A,E
		ld	E,A
		ld	A,(IX+vduIX_VDU_Q_END-4)	; a <= physical colour
LC89E:		and	A,0x0F				; 

		ld	HL, vduvar_PALLETTE		;
		add	HL,DE
		ld	(HL),A
	
		ld	B,A				; B contains physical colour
							; E logical colour
		ld	A,C				; A <= colours - 1
		inc	C				; C <= colours - used in addition below and test for 4 colour mode

		; shift logical colour into A, left justified
10$:		rr	E
		rra
		jr	C,10$
		rla					
		or	A,B				; A now contains LLLLPPPP where LLLL is left justified
		ld	E,A				; E remembers A we will mess with it for 3 colour modes!

		ld	B,16				; loop counter to 16
30$:		bit	2,C
		jr	Z,40$				; jump ahead if not a 4 colour mode
		and	A,0b01100000
		jr	Z,35$
		cp	A,0b01100000
		jr	Z,35$
		ld	A,E
		xor	A,0b01100000
		jr	40$
35$:		ld	A,E
40$:		
		call	write_pallette_reg				; LC8CC
		
		; get back unmessed A value
		ld	A,E
		add	A,0x10
		ld	E,A

		; do loop count
		ld	A,B				; # of colours
		sub	A,C
		ld	B,A
		ld	A,E
		jr	NZ, 30$

		call	popIFF
		ret


;; ----------------------------------------------------------------------------
;; OSWORD 12    WRITE PALLETTE; on entry X=&F0:Y=&F1:YX points to parameter block ; byte 0 = logical colour;  byte 1 physical colour; bytes 2-4=0 
;mos_OSWORD_12:
;	php					;	C8E0
;	and	vduvar_COL_COUNT_MINUS1		;	C8E1
;	tax					;	C8E4
;	iny					;	C8E5
;	lda	(zp_mos_OSBW_X),y		;	C8E6
;	jmp	LC89E				;	C8E8
;; ----------------------------------------------------------------------------
;; VDU	  22		  Select Mode	1 parameter; parameter in &323 
mos_VDU_22::	ld	A, (vduvar_VDU_Q_END - 1)	;	C8EB
		jp	mos_VDU_set_mode		;	C8EE
;; ----------------------------------------------------------------------------
;; VDU 23 Define characters		  9 parameters; parameters are:- ; 31B character to define ; 31C to 323 definition 
mos_VDU_23::	TODO "mos_VDU_23"
;
;		TODOSKIP	"VDU 23"
;		rts
;	lda	vduvar_VDU_Q_END - 9;	C8F1
;	cmp	#0x20				;	C8F4
;	bcc	x_set_CRT_controller		;	C8F6
;	pha					;	C8F8
;	lsr	a				;	C8F9
;	lsr	a				;	C8FA
;	lsr	a				;	C8FB
;	lsr	a				;	C8FC
;	lsr	a				;	C8FD
;	tax					;	C8FE
;	lda	mostbl_VDU_pix_mask_2colour,x	;	C8FF
;	bit	vduvar_EXPLODE_FLAGS		;	C902
;	bne	LC927				;	C905
;	ora	vduvar_EXPLODE_FLAGS		;	C907
;	sta	vduvar_EXPLODE_FLAGS		;	C90A
;	txa					;	C90D
;	and	#0x03				;	C90E
;	clc					;	C910
;	adc	#0xBF				;	C911
;	sta	zp_vdu_wksp+5			;	C913
;	lda	vduvar_EXPLODE_FLAGS,x		;	C915
;	sta	zp_vdu_wksp+3			;	C918
;	ldy	#0x00				;	C91A
;	sty	zp_vdu_wksp+2			;	C91C
;	sty	zp_vdu_wksp+4			;	C91E
;LC920::	lda	(zp_vdu_wksp+4),y		;	C920
;	sta	(zp_vdu_wksp+2),y		;	C922
;	dey					;	C924
;	bne	LC920				;	C925
;LC927::	pla					;	C927
;	jsr	x_calc_pattern_addr_for_given_char;	C928
;	ldy	#0x07				;	C92B
;LC92D::	lda	0x031C,y				;	C92D
;	sta	(zp_vdu_wksp+4),y		;	C930
;	dey					;	C932
;	bpl	LC92D				;	C933
;	rts					;	C935
;; ----------------------------------------------------------------------------
;	pla					;	C936
;LC937::	rts					;	C937
;; ----------------------------------------------------------------------------
;; VDU EXTENSION
x_VDU_EXTENSION::	TODO "x_VDU_EXTENSION"
;
;		lda	vduvar_VDU_Q_END - 5		;	C938
;		CLC					;	C93B

jmp_VDUV::	TODO "jmp_VDUV"
;	; LC93C
;		jmp	[VDUV]				;	C93C
;; ----------------------------------------------------------------------------
;; set CRT controller
x_set_CRT_controller::	TODO "x_set_CRT_controller"
;
;		cmpa	#0x01				;	C93F
;		blo	LC958				; VDU 23,0,R,X - set (R)eg to (X) in CRTC
;		bne	jmp_VDUV			;	C943
;		ASSERT "Unexpected in x_set_CRT_controller"
;	jsr	x_check_text_cursor_in_use	;	C945
;	bne	LC937				;	C948
;	lda	#0x20				;	C94A
;	ldy	vduvar_VDU_Q_END - 8		;	C94C
;	beq	x_crtc_set_cursor		;	C94F
x_crtc_reset_cursor::	TODO "x_crtc_reset_cursor"
;	; LC951
;		lda	vduvar_CUR_START_PREV		;	C951
x_crtc_set_cursor::	TODO "x_crtc_set_cursor"
;
;		ldb	#0x0A				;	C954
;		bra	LC985				;	C956
;LC958:
;		lda	vduvar_VDU_Q_END - 7		;	C958
;		ldb	vduvar_VDU_Q_END - 8		;	C95B

	; API CHANGE Z80: was set reg B to A
mos_set_6845_regAtoE:
		cp	A,7
		jr	NZ, 10$
		ld	A,(oswksp_VDU_VERTADJ)
		add	A,E
		ld	E,A
		ld	A,7
		jr	LC985
10$:		jr	NC, LC985
		cp	A,8				;	C967
		jr	NZ, LC972			;	C969
		; if interlaced then keep interlaced else eor with flag
		bit	7,E
		jp	NZ, LC972
		ld	A,(oswksp_VDU_INTERLACE)	;	C96F
		xor	A,E
		ld	E,A
		ld	A,8
LC972:		cp	A,10				;	C972
		jr	NZ, LC985			;	C974
		ld	A,E
		ld	(vduvar_CUR_START_PREV),A	;	C976
		ld	A,10
		bit	5,(IY+zpIY_vdu_status)		;	C97A
		jr	NZ, LC98B			;	C983
LC985:		push	AF
		push	BC
		ld	BC,sheila_CRTC_reg
		out	(C),A
		ld	A,E
		inc	C
		out	(C),A
		pop	BC
		pop	AF
LC98B:		ret					;	C98B
;; ----------------------------------------------------------------------------
;; VDU 25	  PLOT			  5 parameters;	 
mos_VDU_25::	TODO "mos_VDU_25"
;
;		tst	vduvar_PIXELS_PER_BYTE_MINUS1	;pixels per byte
;		beq	x_VDU_EXTENSION			;if no graphics available go via VDU Extension 
;		jmp	x_PLOT_ROUTINES_ENTER_HERE	;else enter Plot routine at D060
;; ----------------------------------------------------------------------------
;; adjust screen RAMFDBesses
x_adjust_screen_RAM_addresses::	TODO "x_adjust_screen_RAM_addresses"
;
;		ldd	vduvar_6845_SCREEN_START	
;		jsr	x_subtract_bytes_per_line_from_D
;		bcc	LC9B3
;		adda	vduvar_SCREEN_SIZE_HIGH
;		bcc	LC9B3
x_adjust_screen_RAM_addresses_one_line_scroll::	TODO "x_adjust_screen_RAM_addresses_one_line_scroll"
;
;		ldd	vduvar_BYTES_PER_ROW
;		addd	vduvar_6845_SCREEN_START
;		bpl	LC9B3
;		suba	vduvar_SCREEN_SIZE_HIGH
;LC9B3:		std	vduvar_6845_SCREEN_START
;		tfr	D,X
		ld	B,0xC
;		bra	x_set_6845_screenstart_from_HL
;; VDU 26  set default windows		  0 parameters
mos_VDU_26::
		xor	A,A
		ld	B,vduIX_TEMP_8+5
		ld	HL,vduvar_GRA_WINDOW
LC9C1:		ld	(HL),A
		inc	HL
		djnz	LC9C1
		ld	D,0
		ld	E,(IX+vduIX_MODE)		;	C9C7
		ld	HL,mostbl_vdu_window_right
		add	HL,DE
		ld	A,(HL)				;	C9CA
		ld	(vduvar_TXT_WINDOW_RIGHT),A	;	C9CD
		call	LCA88_newAPI			;	C9D0
		ld	HL,mostbl_vdu_window_bottom+1	;	C9D3
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_TXT_WINDOW_BOTTOM),A	;	C9D6
		ld	B,3				;	C9D9
		ld	(IX+vduIX_VDU_Q_END - 1),B	;	C9DB
		inc	B				;	C9DE
		ld	(IX+vduIX_VDU_Q_END - 3),B	;	C9DF
		dec	(IX+vduIX_VDU_Q_END - 2)	;	set to FF
		dec	(IX+vduIX_VDU_Q_END - 4)	;	set to FF
		call	mos_VDU_24			;	C9E8
		ld	A, 0xF7				;	C9EB
		call	mos_VDU_and_A_vdustatus		;	C9ED
		ld	HL,(vduvar_6845_SCREEN_START)	;	C9F0
mos_set_cursor_HL:
		ld	(vduvar_6845_CURSOR_ADDR),HL	;	C9F6
		ld	A,0x7F
		cp	A,H
		jr	NC,x_set_cursor_position_HL	; > 8000
		ld	A,H				; if so normalize by subtracting screen size
		sub	A,(IX+vduIX_SCREEN_SIZE_HIGH)
		ld	H,A
x_set_cursor_position_HL:
		ld	(zp_vdu_top_scanline),HL
		ld	HL,(vduvar_6845_CURSOR_ADDR)	; get back unadjusted value
		ld	B,0xE
x_set_6845_screenstart_from_HL:				; LCA0E
		ld	A,(vduvar_MODE)
		cp	A,7
		jr	NC,LCA27
		sra	H
		rr	L
		sra	H
		rr	L
		sra	H
		rr	L
		jr	mos_stHL_6845rB			;	CA24
;; ----------------------------------------------------------------------------
LCA27:		
		; convert normal address to teletext crtc address
		ld	A,0x8C				; -0x74
		add	A,H
		xor	A,0x20				
		ld	H,A
mos_stHL_6845rB:
		ld	A,B
		ld	E,H
		call	mos_set_6845_regAtoE
		inc	A
		ld	E,L
		jp	mos_set_6845_regAtoE		; EXIT

db_endian_vdu_q_swap::	TODO "db_endian_vdu_q_swap"
;
;		***********************************************
;		* BODGE: endianness swap for VDU drivers      *
;		* This is subject to change                   *
;		*                                             *
;		* workspace vars are all in big endian        *
;		* Q is in little endian so swap all the bytes *
;		* Y contain number of 16 bit params at end of *
;		* Q to swap				      *
;		***********************************************
;		ldx	#vduvar_VDU_Q_END
;10x:		ldd	,--X
;		exg	A,B
;		std	,X
;		leay	-1,Y
;		bne	1B
;		rts


;; ----------------------------------------------------------------------------
;; VDU 24 Define graphics window		  8 parameters; &31C/D Left margin ; &31E/F Bottom margin ; &320/1 Right margin ; &322/3 Top margin 
mos_VDU_24::
		ret				; TODO: GRAPHICS
		TODO "mos_VDU_24"
;
;		ldy	#4
;		jsr	db_endian_vdu_q_swap

;; temporary equs to make things clearer
vduvar_VDU_Q_24_LEFT	=	vduvar_VDU_Q_END - 8
vduvar_VDU_Q_24_BOTTOM	=	vduvar_VDU_Q_END - 6
vduvar_VDU_Q_24_RIGHT	=	vduvar_VDU_Q_END - 4
vduvar_VDU_Q_24_TOP	=	vduvar_VDU_Q_END - 2
vduvar_TMP_CURSAVE	=	vduvar_TEMP_8
vudvar_TMP_XY		=	vduvar_TEMP_8 + 4


;		jsr	x_exchange_310_with_328		; save current cursor value at vduvar_TEMP_8
;		ldx	#vduvar_VDU_Q_24_LEFT
;		ldy	#vudvar_TMP_XY
;		jsr	x_coords_to_width_height	; calculate new width/height at TMP_XY
;		ora	vudvar_TMP_XY			; A already contains to byte of height, or with top byte of width
;		bmi	x_exchange_310_with_328		; if either negative, quit
;		ldx	#vduvar_VDU_Q_24_RIGHT
;		jsr	x_set_up_and_adjust_coords_atX
;		ldx	#vduvar_VDU_Q_24_LEFT
;		jsr	x_set_up_and_adjust_coords_atX
;		lda	vduvar_VDU_Q_24_BOTTOM
;		ora	vduvar_VDU_Q_24_TOP
;		bmi	x_exchange_310_with_328		; if top or bottom -ve
;		lda	vduvar_VDU_Q_24_TOP
;		bne	x_exchange_310_with_328		; if top internal coords > 255
;		LDX_B	vduvar_MODE			; screen mode
;		lda	vduvar_VDU_Q_24_RIGHT		; right margin hi
;		sta	zp_vdu_wksp			; store it
;		lda	vduvar_VDU_Q_24_RIGHT + 1	; right margin lo
;		lsr	zp_vdu_wksp			; /2
;		rora					; A=A/2
;		lsr	zp_vdu_wksp			; /2
;		bne	x_exchange_310_with_328		; exchange 310/3 with 328/3 - its too big!
;		rora					; A=A/2
;		lsra					; A=A/2
;		cmpa	mostbl_vdu_window_right,x	; text window right hand margin maximum
;		beq	LCA7A				; if equal CA7A
;		bpl	x_exchange_310_with_328		; exchange 310/3 with 328/3
;LCA7A:		ldy	#vduvar_GRA_WINDOW_LEFT
;		ldx	#vduvar_VDU_Q_END - 8
;		jsr	copy8fromXtoY			; save updated data

x_exchange_310_with_328::	TODO "x_exchange_310_with_328"
;
;		ldx	#vduvar_GRA_CUR_EXT		; ==0x310
;		ldy	#vduvar_TEMP_8			; ==0x328
;		jmp	x_exchange_4atY_with_4atX

;; ----------------------------------------------------------------------------
LCA88_newAPI:

		; old API (y == window width in chars - 1)
		; new API (a == window width in chars - 1)
		inc	A	; 1M	4T	1
		ld	L,A	; 1M	4T	1
		ld	H,0	; 2M	7T	2

;		ld	L,A	; 1M	4T	1
;		xor	A	; 1M	4T	1
;		ld	H,A	; 1M	4T	1
;		inc	L	; 1M	4T	1

;		or	A,A	; 1M	4T	1
;		sbc	HL,HL	; 4M	15T	2
;		ld	L,A	; 1M	4T	1

		ld	A,(vduvar_BYTES_PER_CHAR)
		srl	A
		jr	Z,LCAA1				; if BYTES_PER_CHAR > 2 then Mode 7 POH
10$:		add	HL,HL				; double it
		srl	A				; keep shifting right
		jr	NC,10$				; while bits left in BPC
		ld	(vduvar_BYTES_PER_ROW),HL
LCAA1:		ret					;	CAA1
;; ----------------------------------------------------------------------------
;; VDU 29  Set graphics origin			  4 parameters;	 
mos_VDU_29::	TODO "mos_VDU_29"
;
;		ldx	#vduvar_VDU_Q_END - 4
;		ldy	#vduvar_GRA_ORG_EXT
;		jsr	copy4fromXtoY
;		jmp	x_calculate_external_coordinates_from_internal_coordinates
;; ----------------------------------------------------------------------------
;; VDU 32  (&7F)	  Delete			  0 parameters
mos_VDU_127::	TODO "mos_VDU_127"
;	; LCAAC
;		jsr	mos_VDU_8			;cursor left
;		jsr	x_check_text_cursor_in_use	;A=0 if text cursor A=&20 if graphics cursor
;		bne	LCAC7				;if graphics then CAC7
;		ldb	vduvar_COL_COUNT_MINUS1		;number of logical colours less 1
;		beq	LCAC2				;if mode 7 CAC2
;		ldd	#mostbl_chardefs
;		std	zp_vdu_wksp+4			;store in &DF (&DE) now points to C300 SPACE pattern
;		jmp	LCFBF_renderchar2		;display a space
;; ----------------------------------------------------------------------------
;LCAC2:		lda	#0x20				;A=&20
;		jmp	x_convert_teletext_characters	;and return to display a space
;; ----------------------------------------------------------------------------
;LCAC7:		lda	#0x7F				;for graphics cursor
;		jsr	x_calc_pattern_addr_for_given_char;set up character definition pointers
;		lda	vduvar_GRA_BACK			;Background graphics colour
;		ldb	#0x00				;plotmode = 0
;		jmp	x_plot_char_gra_mode				;invert pattern data (to background colour)
;; ----------------------------------------------------------------------------
;; control scrolling in paged mode
x_control_scrolling_in_paged_mode::	TODO "x_control_scrolling_in_paged_mode"
;	; LCAE0
;		jsr	x_zero_paged_mode_counter
x_control_scrolling_in_paged_mode_2::	TODO "x_control_scrolling_in_paged_mode_2"
;
;		jsr	mos_OSBYTE_118
;		bcc	LCAEA
;		bmi	x_control_scrolling_in_paged_mode
;LCAEA:		lda	zp_vdu_status
;		eora	#0x04
;		anda	#0x46
;		bne	LCB1Crts
;		lda	sysvar_SCREENLINES_SINCE_PAGE
;		bmi	LCB19
;		lda	vduvar_TXT_CUR_Y
;		cmpa	vduvar_TXT_WINDOW_BOTTOM
;		blo	LCB19
;		lsra
;		lsra
;		SEC
;		adca	sysvar_SCREENLINES_SINCE_PAGE
;		adca	vduvar_TXT_WINDOW_TOP
;		cmpa	vduvar_TXT_WINDOW_BOTTOM
;		blo	LCB19
;		CLC
;LCB0E:		jsr	mos_OSBYTE_118
;		SEC
;		bpl	LCB0E
;; zero paged mode  counter
x_zero_paged_mode_counter::	TODO "x_zero_paged_mode_counter"
;
;		lda	#0xFF				;	CB14
;		sta	sysvar_SCREENLINES_SINCE_PAGE	;	CB16
;LCB19:		inc	sysvar_SCREENLINES_SINCE_PAGE	;	CB19
LCB1Crts::	TODO "LCB1Crts"
;
;		rts					;	CB1C
; ----------------------------------------------------------------------------
; Set vdu vars to 0, called with mode in A
mos_VDU_init::						; LCB1D

		push	AF				; Save MODE in A ;TODOZ80 - use regs for save
		ld	BC,0x7F-1			; Prepare B=&7F-1 for reset loop
		xor	A,A				; A=0 set first to 0 then clear reset by copying
		ld	(zp_vdu_status),A		; Clear VDU status byte to set default conditions
		ld	HL,vduvars_start
		ld	(HL),A				; zero the first vdu var
		ld	DE,vduvars_start+1
; clear vdu vars block
		ldir					; clear the whole vdu vars block
		ld	(zp_mos_OSBW_X),A
		call	mos_OSBYTE_20			; Implode character definitions
		ld	A, 0x7F				; X=&7F
		ld	(vduvar_MO7_CUR_CHAR),A		; MODE 7 copy cursor character (could have set this at CB1E)
		pop	AF				; Get initial MODE back to A

		ld	IX,vduvars_start		; this is used in all mos_VDU_x functions
		ld	IY,zp_base			; phone zero page vars

;; ??? Set mode ???
mos_VDU_set_mode::	
;		; TODO remove this
;;	tst	sysvar_RAM_AVAIL		;	CB33
;;	bmi	mos_VDU_set_mode_gt16Ksk	;	CB36
;;	ora	#0x04				;	CB38
;;;; Skip if > 16k memory available
;;mos_VDU_set_mode_gt16Ksk
		and	A, 7				; Save current screen MODE
		ld	(vduvar_MODE),A		
		ld	D,0
		ld	E,A				; DE = mode offset

		ld	HL,mostbl_VDU_mode_colours_m1
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_COL_COUNT_MINUS1),A	; Get number of colours -1 for this MODE


		ld	HL,mostbl_VDU_bytes_per_char
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_BYTES_PER_CHAR),A

		ld	HL,mostbl_VDU_pixels_per_byte_m1
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_PIXELS_PER_BYTE_MINUS1),A
		
		or	A,A
		jr	NZ, mos_VDU_set_mode_bmsk1
		ld	A, 7				; set all "0bpp modes" to 8bpp
;		;; bytes per pixel 1 => 8?
mos_VDU_set_mode_bmsk1::




		sla	A
		ld	E,A						
		ld	HL,mostbl_VDU_pix_mask_16colour - 1
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_RIGHTMOST_PIX_MASK),A
;		;; shunt bitmask to leftmost
10$:		sla	A				; justify left
		jp	P, 10$
		ld	(vduvar_LEFTMOST_PIX_MASK),A

		ld	A,(vduvar_MODE)
		ld	E,A
		ld	HL, mostbl_VDU_mode_size
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_MODE_SIZE),A
		ld	E,A

		ld	HL,mostbl_VDU_hwscroll_offb2	; get scroll latch values and set
		add	HL,DE
		ld	A,(HL)
		call	mos_poke_SYSVIA_orb
		ld	HL,mostbl_VDU_hwscroll_offb1
		add	HL,DE
		ld	A,(HL)
		call	mos_poke_SYSVIA_orb		

		ld	HL,mostbl_VDU_screensize_h
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_SCREEN_SIZE_HIGH),A

		ld	HL,mostbl_VDU_screebot_h
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_SCREEN_BOTTOM_HIGH),A

		; translate mode map type (0=20K, 1=16K, 2=10k, 3=8K, 4=1K)
		; to index into 	0 => 3,C=1
		;			1 => 2,C=0
		;			2 => 1,C=1
		;			3 => 1,C=0
		;			4 => 0,C=1


		; mode size should already be in E
		ld	A,E
		ld	HL,_MUL320_TABLE
		; TODO: think about putting this somewhere else?
		or	A,A
		jr	NZ, 1$
		ld	HL,_MUL40_TABLE
1$:		ld	(zp_vdu_row_mul),HL
		add	A,2				;	CB83
		xor	A,7				;	CB85
		srl	A
		ld	E,A
		ld	(vduvar_BYTES_PER_ROW),A
		ld	HL,mostbl_VDU_bytes_per_row_low
		add	HL,DE
		ld	A,(HL)
		ld	(vduvar_BYTES_PER_ROW + 1),A


		ld	A, 0x43				;	CB9B
		call	mos_VDU_and_A_vdustatus		;	CB9D
		ld	A,(vduvar_MODE)			;	CBA0
		ld	E,A
		ld	HL,mostbl_VDU_VIDPROC_CTL_by_mode
		add	HL,DE
		ld	A, (HL)				;	CBA3
		call	mos_VIDPROC_set_CTL		;	CBA6

		call	pushIFF_DI

;		; Send commands from table for current mode size to 6845
		; TODO: try a multiply and get rid of table?
		ld	A,(vduvar_MODE_SIZE)
		ld	E,A
		ld	HL,mostbl_VDU_ptr_end_6845tab
		add	HL,DE
		ld	E,(HL)
		ld	HL,mostbl_VDU_6845_mode_012
		add	HL,DE
		ld	A,11				
mos_send6845lp:						; LCBB0
		dec	HL
		ld	E,(HL)				;	CBB0
		call	mos_set_6845_regAtoE		;	CBB3
		dec	A
		jp	P,mos_send6845lp			;	CBB8
		call	popIFF				; interrupts back




		call	mos_VDU_20			; default logical colours
		call	mos_VDU_26			; default windows
LCBC1_clear_whole_screen::
		ld	H,(IX+vduIX_SCREEN_BOTTOM_HIGH)
		ld	L,0
		ld	(vduvar_6845_SCREEN_START),HL
		call	mos_set_cursor_HL		;	CBCC
		ld	B,0x0C				;	CBCF
		call	mos_stHL_6845rB			;	CBD1
		ld	A,(vduvar_TXT_BACK)		;	CBD4

		ld	HL,(vduvar_6845_SCREEN_START)
		ld	(HL),A
		ld	B,(IX+vduIX_SCREEN_SIZE_HIGH)	;	CBD7
		xor	A,A
		ld	C,A
		ld	(sysvar_SCREENLINES_SINCE_PAGE),A	;	CBE7
		ld	(vduvar_TXT_CUR_X),A		;	CBEA
		ld	(vduvar_TXT_CUR_Y),A		;	CBED

		dec	BC
		ld	D,H
		ld	E,1
		ldir
		ret

;; ----------------------------------------------------------------------------
;; OSWORD 10	  Read character definition; &EF=A:&F0=X:&F1=Y, on entry YX contains number of byte to be read	; (&DE) points toFDBess ; on exit byte YX+1 to YX+8 contain definition 
;mos_OSWORD_10:
;	jsr	x_calc_pattern_addr_for_given_char;	CBF3
;	ldy	#0x00				;	CBF6
;LCBF8::	lda	(zp_vdu_wksp+4),y		;	CBF8
;	iny					;	CBFA
;	sta	(zp_mos_OSBW_X),y		;	CBFB
;	cpy	#0x08				;	CBFD
;	bne	LCBF8				;	CBFF
;	rts					;	CC01
;; ----------------------------------------------------------------------------
;; Mode 0,1,2 entry point
;;;cls_Mode_012_entry_point
;;;	ldx	#0x3000
;;;1	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	sta	,x+
;;;	cmpx	#0x8000
;;;	blo	1B
;;;	rts
;;;;; Mode 3 entry point
;;;cls_Mode_3_entry_point
;;;	ldx	#0x4000
;;;	bra	1B
;;;;; Mode 4,5 entry point
;;;cls_Mode_45_entry_point
;;;	ldx	#0x5800
;;;	bra	1B
;;;;; Mode 6 entry point
;;;cls_Mode_6_entry_point
;;;	ldx	#0x6000
;;;	bra	1B
;;;;; Mode 7 entry point
;;;cls_Mode_7_entry_point
;;;	ldx	#0x7C00
;;;	bra	1B
;; ----------------------------------------------------------------------------
;; subtract bytes per line from X/A
; note new API, address in D instead of X/A and carry flag is opposite sense
x_subtract_bytes_per_line_from_D::	TODO "x_subtract_bytes_per_line_from_D"
;
;		subd	vduvar_BYTES_PER_ROW
;		cmpa	vduvar_SCREEN_BOTTOM_HIGH
;LCD06:		rts					;	CD06
; ----------------------------------------------------------------------------
; OSBYTE 20		  Explode characters;  
mos_OSBYTE_20::
		ret

;		lda	#0x0F				;	CD07
;		sta	vduvar_EXPLODE_FLAGS		;	CD09
;		lda	#0x0C				;	CD0C
;		ldb	#0x06				;	CD0E
;		ldy	#vduvar_FONT_LOC32_63
;LCD10:		sta	b,y
;		decb
;		bpl	LCD10				;	CD14
;	tfr	X,D
;		ldb	zp_mos_OSBW_X
;		cmpb	#0x07				;	CD16
;		blo	LCD1C				;	CD18
;		ldb	#0x06				;	CD1A
;LCD1C:		stb	sysvar_EXPLODESTATUS		;	CD1C
;		lda	sysvar_PRI_OSHWM		;	CD1F
;		ldb	#0x00				;	CD22
;		ldx	#mostbl_SOFT_CHARACTER_RAM_ALLOCATION
;		ldy	#vduvar_FONT_LOC32_63
;LCD24:		cmpb	sysvar_EXPLODESTATUS		;	CD24
;		bhs	LCD34				;	CD27
;		pshs	b
;		ldb	b,x				;	CD29
;		sta	b,y				;	CD2C
;		inca					;	CD2F
;		puls	b
;		incb					;	CD31
;		bne	LCD24				;	CD32
;LCD34:		sta	sysvar_CUR_OSHWM		;	CD34
;		beq	LCD06				;	CD38
;		ldb	#SERVICE_11_FONT_BANG		;	CD3A
;		jmp	mos_OSBYTE_143_b_cmd_x_param
;						;	CD3C
;; ----------------------------------------------------------------------------
;; :move text cursor to next line (direction up/down depends on CC_C)
x_move_text_cursor_to_next_line::	TODO "x_move_text_cursor_to_next_line"
;
;		lda	zp_vdu_status
;		bita	#0x02
;		bne	LCD47				; scrolling disabled
;		bita	#0x40
;		beq	LCD65rts			; curor editing
;LCD47:		ldb	vduvar_TXT_WINDOW_BOTTOM	; if carry set on entry get TOP else get BOTTOM
;		bcc	LCD4F				
;		ldb	vduvar_TXT_WINDOW_TOP		
;LCD4F:		bita	#0x40
;		bne	LCD59				; if cursor editing
;		stb	vduvar_TXT_CUR_Y		
;		leas	2,S				; skip return and setup address and cursor
;		jmp	x_setup_displayaddress_and_cursor_position
;; ----------------------------------------------------------------------------
;LCD59:		pshs	CC				;	CD59
;		cmpb	vduvar_TEXT_IN_CUR_Y		;	CD5A
;		beq	1F				;	CD5D
;		puls	CC				;	CD5F
;		bcc	LCD66				;	CD60
;		dec	vduvar_TEXT_IN_CUR_Y		;	CD62
LCD65rts::	TODO "LCD65rts"
;
;		rts
;10x:		puls	CC,PC
;; ----------------------------------------------------------------------------
;LCD66:		inc	vduvar_TEXT_IN_CUR_Y		;	CD66
;		rts					;	CD69
;; ----------------------------------------------------------------------------
;; set up write cursor
x_setup_write_cursor::	TODO "x_setup_write_cursor"
;
;		pshs	A,B,CC,X
;		ldb	vduvar_BYTES_PER_CHAR
;		decb
;		ldx	zp_vdu_top_scanline
;		bne	LCD8F				; it's not MO.7
;		lda	vduvar_GRA_WKSP+8
;		sta	,X				; restore original MO.7 character?
;		puls	A,B,CC,X,PC

;;	php					;	CD6A
;;	pha					;	CD6B
;;	ldy	vduvar_BYTES_PER_CHAR		;	CD6C
;;	dey					;	CD6F
;;	bne	LCD8F				;	CD70
;;	lda	vduvar_GRA_WKSP+8		;	CD72
;;	sta	(zp_vdu_top_scanline),y		;	CD75

;;LCD77:	pla					;	CD77
;;LCD78:	plp					;	CD78
;;LCD79:	rts					;	CD79
;; ----------------------------------------------------------------------------
x_setup_read_cursor::	TODO "x_setup_read_cursor"
;
;		pshs	A,B,CC,X
;		ldx	zp_vdu_top_scanline
;		ldb	vduvar_BYTES_PER_CHAR			;bytes per character
;		decb						;
;		bne	LCD8F					;if not mode 7
;		lda	,x					;get cursor from top scan line
;		sta	vduvar_GRA_WKSP+8			;store it
;		lda	vduvar_MO7_CUR_CHAR			;mode 7 write cursor character
;		sta	,x					;store it at scan line
;		puls	A,B,CC,X,PC				;and exit

;; ----------------------------------------------------------------------------
;LCD8F:		lda	#0xFF					;A=&FF =cursor
;		cmpb	#0x1F					;except in mode 2 (Y=&1F)
;		bne	x_produce_white_block_write_cursor	;if not CD97
;		lda	#0x3F					;load cursor byte mask
;; produce white block write cursor
x_produce_white_block_write_cursor::	TODO "x_produce_white_block_write_cursor"
;
;		sta	zp_vdu_wksp			;	CD97
;10x:		lda	,x				;	CD99
;		eora	zp_vdu_wksp			;	CD9B
;		sta	,x+				;	CD9D
;		decb					;	CD9F
;		bpl	1B				;	CDA0
;;;	bmi	LCD77				;	CDA2
;		puls	A,B,CC,X,PC



x_soft_scroll1line::	TODO "x_soft_scroll1line"
;
;		jsr	x_exchange_TXTCUR_wksp_doublertsifwindowempty ; also saves height in wksp+4
;		lda	vduvar_TXT_WINDOW_BOTTOM	;	CDA7
;		sta	vduvar_TXT_CUR_Y		;	CDAA
;		jsr	x_set_up_displayaddress	;	CDAD
;LCDB0:		jsr	x_subtract_bytes_per_line_from_D;	CDB0
;		bcc	LCDB8				;	CDB3
;		adda	vduvar_SCREEN_SIZE_HIGH		;	CDB5
;LCDB8:		std	zp_vdu_wksp			;	CDB8
;		sta	zp_vdu_wksp+2			;	CDBC
;		bcs	LCDC6				;	CDBE
;LCDC0:		jsr	x_copy_text_line_window_LCE73				;	CDC0
;		bra	LCDCE
;; ----------------------------------------------------------------------------
;LCDC6:		jsr	x_subtract_bytes_per_line_from_D;	CDC6
;		bcs	LCDC0				;	CDC9
;		jsr	x_copy_text_line_window_LCE38			;	CDCB
;LCDCE:		lda	zp_vdu_wksp+2			;	CDCE
;		ldb	zp_vdu_wksp+1			;	CDD0
;		std	zp_vdu_top_scanline		;	CDD2
;		dec	zp_vdu_wksp+4
;		bne	LCDB0

x_exchange_TXT_CUR_with_BITMAP_READ::	TODO "x_exchange_TXT_CUR_with_BITMAP_READ"
;	; LCDDA
;		ldx	#vduvar_TEMP_8
;		ldy	#vduvar_TXT_CUR_X
x_exchange_2atY_with_2atX::	TODO "x_exchange_2atY_with_2atX"
;	; LCDDE
;		ldb	#0x02				;	CDDE TODO: this is a straigh 16 bit copy do something better?
;		bra	x_exchange_B_atY_with_B_atX	;	CDE0
x_exg4atGRACURINTwithGRACURINTOLD::	TODO "x_exg4atGRACURINTwithGRACURINTOLD"
;	; LCDE2
;		ldx	#vduvar_GRA_CUR_INT		;	CDE2
x_exg4atGRACURINTOLDwithX::	TODO "x_exg4atGRACURINTOLDwithX"
;	; LCDE4
;		ldy	#vduvar_GRA_CUR_INT_OLD		;	CDE4
x_exchange_4atY_with_4atX::	TODO "x_exchange_4atY_with_4atX"
;
;		ldb	#0x04				;	CDE6
;; exchange (300/300+A)+Y with (300/300+A)+X
x_exchange_B_atY_with_B_atX::	TODO "x_exchange_B_atY_with_B_atX"
;
;		stb	zp_vdu_wksp			;	CDE8
;LCDEA:		lda	,x
;		ldb	,y
;		sta	,y+
;		stb	,x+
;		dec	zp_vdu_wksp			;	CDFA
;		bne	LCDEA				;	CDFC
;		rts					;	CDFE
;; ----------------------------------------------------------------------------
;; execute upward scroll;  
x_execute_upward_scroll::	TODO "x_execute_upward_scroll"
;
;		TODO	"x_execute_upward_scroll"
;	jsr	x_exchange_TXTCUR_wksp_doublertsifwindowempty				;	CDFF
;	ldy	vduvar_TXT_WINDOW_TOP		;	CE02
;	sty	vduvar_TXT_CUR_Y		;	CE05
;	jsr	x_set_up_displayaddress	;	CE08
;LCE0B::	jsr	x_Add_number_of_bytes_in_a_line_to_XA;	CE0B
;	bpl	LCE14				;	CE0E
;	sec					;	CE10
;	sbc	vduvar_SCREEN_SIZE_HIGH		;	CE11
;LCE14::	sta	zp_vdu_wksp+1			;	CE14
;	stx	zp_vdu_wksp			;	CE16
;	sta	zp_vdu_wksp+2			;	CE18
;	bcc	LCE22				;	CE1A
;LCE1C::	jsr	x_copy_text_line_window_LCE73				;	CE1C
;	jmp	LCE2A				;	CE1F
;; ----------------------------------------------------------------------------
;LCE22::	jsr	x_Add_number_of_bytes_in_a_line_to_XA;	CE22
;	bmi	LCE1C				;	CE25
;	jsr	x_copy_text_line_window_LCE38			;	CE27
;LCE2A::	lda	zp_vdu_wksp+2			;	CE2A
;	ldx	zp_vdu_wksp			;	CE2C
;	sta	zp_vdu_top_scanline+1		;	CE2E
;	stx	zp_vdu_top_scanline		;	CE30
;	dec	zp_vdu_wksp+4			;	CE32
;	bne	LCE0B				;	CE34
;	beq	x_exchange_TXT_CUR_with_BITMAP_READ				;	CE36
;; copy routines
x_copy_text_line_window_LCE38::	TODO "x_copy_text_line_window_LCE38"
;
;		pshs	u
;		ldy	vduvar_TXT_WINDOW_WIDTH_BYTES
;		ldx	zp_vdu_wksp
;		ldu	zp_vdu_top_scanline
;10x:		lda	,x+
;		sta	,u+
;		leay	-1,y
;		bne	1B
;		puls	u,pc
;							;	CE5A
;; ----------------------------------------------------------------------------
x_exchange_TXTCUR_wksp_doublertsifwindowempty::	TODO "x_exchange_TXTCUR_wksp_doublertsifwindowempty"
;	; LCE5B
;		jsr	x_exchange_TXT_CUR_with_BITMAP_READ
;		lda	vduvar_TXT_WINDOW_BOTTOM	;	CE5F
;		suba	vduvar_TXT_WINDOW_TOP		;	CE62
;		sta	zp_vdu_wksp+4			;	CE65
;		bne	x_cursor_to_window_left				;	CE67
;		leas	2,S
;		jmp	x_exchange_TXT_CUR_with_BITMAP_READ	; if no text window pull return address, put back cursor and exit parent subroutine
;; ----------------------------------------------------------------------------
x_cursor_to_window_left::	TODO "x_cursor_to_window_left"
;
;		lda	vduvar_TXT_WINDOW_LEFT		
;		bra	LCEE3_sta_TXT_CUR_X_setC_rts

x_copy_text_line_window_LCE73::	TODO "x_copy_text_line_window_LCE73"
;
;		TODO "x_copy_text_line_window_LCE73"
;x_copy_text_line_window_LCE73:	lda	zp_vdu_wksp			;	CE73 TODO copy lines of text - scroll window?
;	pha					;	CE75
;	sec					;	CE76
;	lda	vduvar_TXT_WINDOW_RIGHT		;	CE77
;	sbc	vduvar_TXT_WINDOW_LEFT		;	CE7A
;	sta	zp_vdu_wksp+5			;	CE7D
;LCE7F::	ldy	vduvar_BYTES_PER_CHAR		;	CE7F
;	dey					;	CE82
;LCE83::	lda	(zp_vdu_wksp),y			;	CE83
;	sta	(zp_vdu_top_scanline),y		;	CE85
;	dey					;	CE87
;	bpl	LCE83				;	CE88
;	ldx	#0x02				;	CE8A
;LCE8C::	clc					;	CE8C
;	lda	zp_vdu_top_scanline,x		;	CE8D
;	adc	vduvar_BYTES_PER_CHAR		;	CE8F
;	sta	zp_vdu_top_scanline,x		;	CE92
;	lda	zp_vdu_top_scanline+1,x		;	CE94
;	adc	#0x00				;	CE96
;	bpl	LCE9E				;	CE98
;	sec					;	CE9A
;	sbc	vduvar_SCREEN_SIZE_HIGH		;	CE9B
;LCE9E::	sta	zp_vdu_top_scanline+1,x		;	CE9E
;	dex					;	CEA0
;	dex					;	CEA1
;	beq	LCE8C				;	CEA2
;	dec	zp_vdu_wksp+5			;	CEA4
;	bpl	LCE7F				;	CEA6
;	pla					;	CEA8
;	sta	zp_vdu_wksp			;	CEA9
;	rts					;	CEAB
;; ----------------------------------------------------------------------------
;; clear a line
x_clear_a_line::	TODO "x_clear_a_line"
;
;		lda	vduvar_TXT_CUR_X
;		pshs	A
;		jsr	x_cursor_to_window_left
;		jsr	x_set_up_displayaddress
;		lda	vduvar_TXT_WINDOW_RIGHT
;		suba	vduvar_TXT_WINDOW_LEFT
;		sta	zp_vdu_wksp+2
;		ldx	zp_vdu_top_scanline
;		lda	vduvar_TXT_BACK	
;LCEBF:		ldb	vduvar_BYTES_PER_CHAR
;LCEC5:		sta	,X+
;		decb
;		bne	LCEC5
;		cmpx	#0x8000
;		blo	LCEDA
;		lda	vduvar_SCREEN_SIZE_HIGH
;		nega
;		clrb
;		leax	D,X
;		lda	vduvar_TXT_BACK
;LCEDA:		dec	zp_vdu_wksp+2
;		bpl	LCEBF
;		stx	zp_vdu_top_scanline
;		puls	A
LCEE3_sta_TXT_CUR_X_setC_rts::	TODO "LCEE3_sta_TXT_CUR_X_setC_rts"
;
;		sta	vduvar_TXT_CUR_X
LCEE6_setC_rts::	TODO "LCEE6_setC_rts"
;
;		SEC
;		rts
;; ----------------------------------------------------------------------------
x_check_text_cursor_in_window_setup_display_addr::	TODO "x_check_text_cursor_in_window_setup_display_addr"
;
;		ldb	vduvar_TXT_CUR_X
;		cmpb	vduvar_TXT_WINDOW_LEFT
;		bmi	LCEE6_setC_rts
;		cmpb	vduvar_TXT_WINDOW_RIGHT
;		beq	LCEF7
;		bpl	LCEE6_setC_rts
;LCEF7:		ldb	vduvar_TXT_CUR_Y
;		cmpb	vduvar_TXT_WINDOW_TOP
;		bmi	LCEE6_setC_rts
;		cmpb	vduvar_TXT_WINDOW_BOTTOM
;		beq	x_set_up_displayaddress
;		bpl	LCEE6_setC_rts
;; set up displayaddressess
; 
; Mode 0: (0319)*640+(0318)* 8 		0
; Mode 1: (0319)*640+(0318)*16 		0
; Mode 2: (0319)*640+(0318)*32 		0
; Mode 3: (0319)*640+(0318)* 8 		1
; Mode 4: (0319)*320+(0318)* 8 		2
; Mode 5: (0319)*320+(0318)*16 		2
; Mode 6: (0319)*320+(0318)* 8 		3
; Mode 7: (0319)* 40+(0318)  		4
 ;this gives a displacement relative to the screen RAM start address
 ;which is added to the calculated number and stored in in 34A/B
 ;if the result is less than &8000, the top of screen RAM it is copied into X/A
 ;and D8/9.  
 ;if the result is greater than &7FFF the hi byte of screen RAM size is
 ;subtracted to wraparound the screen. X/A, D8/9 are then set from this

x_set_up_displayaddress::	TODO "x_set_up_displayaddress"
;
;		lda	vduvar_TXT_CUR_Y
;		ldb	vduvar_MODE_SIZE
;		cmpb	#4
;		beq	x_set_up_displayaddress_mo7
;		cmpb	#2
;		bhs	x_set_up_displayaddress_320
;		ldb	#160
;		mul
;		aslb
;		rola
x_set_up_displayaddress_sk1::	TODO "x_set_up_displayaddress_sk1"
;
;		aslb
;		rola
x_set_up_displayaddress_sk2::	TODO "x_set_up_displayaddress_sk2"
;
;		addd	vduvar_6845_SCREEN_START
;		std	zp_vdu_top_scanline
;		lda	vduvar_TXT_CUR_X
;		ldb	vduvar_BYTES_PER_CHAR
;		mul
;		addd	zp_vdu_top_scanline
;		std	vduvar_6845_CURSOR_ADDR
;		bpl	x_set_up_displayaddress_nowrap
;		suba	vduvar_SCREEN_SIZE_HIGH
x_set_up_displayaddress_nowrap::	TODO "x_set_up_displayaddress_nowrap"
;
;		std	zp_vdu_top_scanline

;		rts
x_set_up_displayaddress_320::	TODO "x_set_up_displayaddress_320"
;
;		ldb	#160
;		mul
;		bra	x_set_up_displayaddress_sk1
x_set_up_displayaddress_mo7::	TODO "x_set_up_displayaddress_mo7"
;
;		ldb	#40
;		mul
;		bra	x_set_up_displayaddress_sk2



;;;	lda	vduvar_TXT_CUR_Y		;	CF06
;;;	asl	a				;	CF09
;;;	tay					;	CF0A
;;;	lda	(zp_rom_mul),y			;	CF0B
;;;	sta	zp_vdu_top_scanline+1		;	CF0D
;;;	iny					;	CF0F
;;;	lda	#0x02				;	CF10
;;;	and	vduvar_MODE_SIZE		;	CF12
;;;	php					;	CF15
;;;	lda	(zp_rom_mul),y			;	CF16
;;;	plp					;	CF18
;;;	beq	LCF1E				;	CF19
;;;	lsr	zp_vdu_top_scanline+1		;	CF1B
;;;	ror	a				;	CF1D;;
;;

;;;LCF1E:	adc	vduvar_6845_SCREEN_START	;	CF1E
;;;	sta	zp_vdu_top_scanline		;	CF21
;;;	lda	zp_vdu_top_scanline+1		;	CF23
;;;	adc	vduvar_6845_SCREEN_START+1	;	CF25
;;;	tay					;	CF28
;;;	lda	vduvar_TXT_CUR_X		;	CF29
;;;	ldx	vduvar_BYTES_PER_CHAR		;	CF2C
;;;	dex					;	CF2F
;;;	beq	LCF44				;	CF30
;;;	cpx	#0x0F				;	CF32
;;;	beq	LCF39				;	CF34
;;;	bcc	LCF3A				;	CF36
;;;	asl	a				;	CF38
;;;LCF39:	asl	a				;	CF39
;;;LCF3A:	asl	a				;	CF3A
;;;	asl	a				;	CF3B
;;;	bcc	LCF40				;	CF3C
;;;	iny					;	CF3E
;;;	iny					;	CF3F
;;;LCF40:	asl	a				;	CF40
;;;	bcc	LCF45				;	CF41
;;;	iny					;	CF43
;;;LCF44:	clc					;	CF44
;;;LCF45:	adc	zp_vdu_top_scanline		;	CF45
;;;	sta	zp_vdu_top_scanline		;	CF47
;;;	sta	vduvar_6845_CURSOR_ADDR		;	CF49
;;;	tax					;	CF4C
;;;	tya					;	CF4D
;;;	adc	#0x00				;	CF4E
;;;	sta	vduvar_6845_CURSOR_ADDR+1	;	CF50
;;;	bpl	LCF59				;	CF53
;;;	sec					;	CF55
;;;	sbc	vduvar_SCREEN_SIZE_HIGH		;	CF56
;;;LCF59:	sta	zp_vdu_top_scanline+1		;	CF59
;;;	clc					;	CF5B
;;;	rts					;	CF5C
;; ----------------------------------------------------------------------------
;; Graphics cursor display routine
x_vdu5_render_char::	TODO "x_vdu5_render_char"


; check where pointer to character pattern is now was (zp_vdu_wksp+4) 

;	ldx	vduvar_GRA_FORE			;	CF5D
;	ldy	vduvar_GRA_PLOT_FORE		;	CF60
x_plot_char_gra_mode::	TODO "x_plot_char_gra_mode"
;	; LCF63
;		TODO "x_plot_char_gra_mode"
;		jsr	x_set_gra_masks_newAPI		;	CF63
;		jsr	copy4from324to328				; LCF66
;	ldy	#0x00				;	CF69
;LCF6B::	sty	zp_vdu_wksp+2			;	CF6B
;	ldy	zp_vdu_wksp+2			;	CF6D
;	lda	(zp_vdu_wksp+4),y		;	CF6F
;	beq	LCF86				;	CF71
;	sta	zp_vdu_wksp+3			;	CF73
;LCF75::	bpl	LCF7A				;	CF75
;	jsr	LD0E3				;	CF77
;LCF7A::	inc	vduvar_GRA_CUR_INT		;	CF7A
;	bne	LCF82				;	CF7D
;	inc	vduvar_GRA_CUR_INT+1		;	CF7F
;LCF82::	asl	zp_vdu_wksp+3			;	CF82
;	bne	LCF75				;	CF84
;LCF86::	ldx	#0x28				;	CF86
;	ldy	#0x24				;	CF88
;	jsr	copy2fromXtoY				;	CF8A
;	ldy	vduvar_GRA_CUR_INT+2		;	CF8D
;	bne	LCF95				;	CF90
;	dec	vduvar_GRA_CUR_INT+3		;	CF92
;LCF95::	dec	vduvar_GRA_CUR_INT+2		;	CF95
;	ldy	zp_vdu_wksp+2			;	CF98
;	iny					;	CF9A
;	cpy	#0x08				;	CF9B
;	bne	LCF6B				;	CF9D
;	ldx	#0x28				;	CF9F
;	ldy	#0x24				;	CFA1
;	jmp	copy4fromXtoY				;	CFA3
;; ----------------------------------------------------------------------------
;; home graphics cursor
x_home_graphics_cursor::	TODO "x_home_graphics_cursor"
;
;		ldx	#vduvar_GRA_WINDOW_TOP
;		ldy	#vduvar_GRA_CUR_INT + 2
;		jsr	copy2fromXtoY
;; set graphics cursor to left hand column
x_set_graphics_cursor_to_left_hand_column::	TODO "x_set_graphics_cursor_to_left_hand_column"
;
;		ldx	#vduvar_GRA_WINDOW_LEFT
;		ldy	#vduvar_GRA_CUR_INT
;		jsr	copy2fromXtoY
;		jmp	x_calculate_external_coordinates_from_internal_coordinates
;; ----------------------------------------------------------------------------
render_char::	bit	0,(IX+vduIX_COL_COUNT_MINUS1)	; mode 7 == 0, all others == odd number!?
		jr	Z,x_convert_teletext_characters
		call	x_calc_pattern_addr_for_given_char
LCFBF_renderchar2:
		bit	5,(IY+zpIY_vdu_status)		;	CFC2
		jp	NZ,x_vdu5_render_char		;	CFC6
render_logo2::

		ld	B,8				; row counter
		ld	DE,(zp_vdu_top_scanline)
		ld	A,(vduvar_COL_COUNT_MINUS1)	;	CFBF
		cp	A,3				;	CFCA
		jp	Z,render_char_4colour		;	CFCC
		jp	NC,render_char_16colour		;	CFCE

		ld	C,(IY+zpIY_vdu_txtcolourOR)
1$:		ld	A,(HL)
		or	A,C
		xor	A,(IY+zpIY_vdu_txtcolourEOR)
		ld	(DE),A
		inc	HL
		inc	DE
		djnz	1$
		ret

render_logox4::	TODO "render_logox4"
;
;		jsr	render_logox2
render_logox2::	TODO "render_logox2"
;
;		jsr	render_logo
render_logo::	TODO "render_logo"
;
;		pshs	X
;		jsr	render_logo2
;		jsr	mos_VDU_9
;		puls	X
;		leax	8,X
;		rts
;; ----------------------------------------------------------------------------
;; convert teletext characters; mode 7 
x_convert_teletext_characters::	TODO "x_convert_teletext_characters"
;
;		ldb	#0x02
;		ldx	#mostbl_TTX_CHAR_CONV
;LCFDE:		cmpa	B,X
;		beq	LCFE9				;	CFE1
;		decb					;	CFE3
;		bpl	LCFDE				;	CFE4
;LCFE6:		sta	[zp_vdu_top_scanline]
;		rts					;	CFE8
;; ----------------------------------------------------------------------------
;LCFE9:		incb
;		lda	B,X
;;		TODO check 
;		;;decb					
;		bra	LCFE6
;; four colour modes
render_char_4colour::	TODO "render_char_4colour"
;
;		pshs	U
;		ldu	#mostbl_byte_mask_4col
;10x:
;		lda	b,x
;		lsra
;		lsra
;		lsra
;		lsra
;		lda	a,U
;		ora	zp_vdu_txtcolourOR
;		eora	zp_vdu_txtcolourEOR
;		sta	b,y
;		lda	b,x
;		addb	#8
;		anda	#0x0F
;		lda	a,U
;		ora	zp_vdu_txtcolourOR
;		eora	zp_vdu_txtcolourEOR
;		sta	b,y
;		subb	#9
;		bpl	1B
LD017rts::	TODO "LD017rts"
;
;		puls	U
;		rts
;; ----------------------------------------------------------------------------
;LD018:		subb	#0x21
;		bmi	LD017rts				;	D01B
;		bra	rc16csk1
;; 16 COLOUR MODES
render_char_16colour::	TODO "render_char_16colour"
;
;		pshs	U
;		ldu	#mostbl_byte_mask_16col
rc16csk1::	TODO "rc16csk1"
;
;		lda	B,X
;		sta	zp_vdu_wksp+2
;		SEC
;LD023:		lda	#0				; cant use clra here as we need the carry set
;		rol	zp_vdu_wksp+2
;		beq	LD018
;		rola
;		asl	zp_vdu_wksp+2
;		rola
;		lda	A,U
;		ora	zp_vdu_txtcolourOR
;		eora	zp_vdu_txtcolourEOR
;		sta	B,y
;		addb	#0x08
;		bra	LD023

x_calc_pattern_addr_for_given_char:
		ld	H,0
		ld	L,A
		add	HL,HL		
		add	HL,HL		
		add	HL,HL		

		; now check to see if the page worth of char defs is "exploded"
		ld	B,H
		ld	A,0
		scf
1$:		rr	A
		djnz	1$
		; A now contains a bitmask 0x80..0x01
		and	A,(IX+vduIX_EXPLODE_FLAGS)
		jr	NZ,x_cpa_sk_exploded	
		; it's not exploded page add the address from the mos rom table
		ld	BC,font_data-256	; we start at char 0x20 so subtract 256	
		add	HL,BC
		ret
x_cpa_sk_exploded:
		ld	B,L
		ld	E,H
		ld	D,0
		ld	HL,vduvar_EXPLODE_FLAGS
		add	HL,DE
		ld	A,(HL)
		ld	H,A
		ld	B,L
		ret

;; ----------------------------------------------------------------------------
;; PLOT ROUTINES ENTER HERE; 
; **************************************************************************
; * on entry	
; *	ADDRESS		PARAMETER	DESCRIPTION 
; *	031F		1		plot type 	vduvar_VDU_Q_END - 5
; *	0320/1		2,3		X coordinate	vduvar_VDU_Q_END - 4
; *	0322/3		4,5		Y coordinate	vduvar_VDU_Q_END - 2
; **************************************************************************


vduvar_VDU_Q_PLT_CODE	=	vduvar_VDU_Q_END - 5
vduvar_VDU_Q_PLT_X	=	vduvar_VDU_Q_END - 4
vduvar_VDU_Q_PLT_Y	=	vduvar_VDU_Q_END - 2

x_PLOT_ROUTINES_ENTER_HERE::	TODO "x_PLOT_ROUTINES_ENTER_HERE"
;
;		; swap coordinates endiannes
;		ldy	#2
;		jsr	db_endian_vdu_q_swap			; - if removed reinstate LDX below!

;;	ldx	#vduvar_VDU_Q_PLT_X			; X=&20 - DB: already set up by endiannes swap
;		jsr	x_set_up_and_adjust_coords_atX_2	; translate xoordinates
;		lda	vduvar_VDU_Q_PLT_CODE			; get plot type
;		cmpa	#0x04					; if its 4
;		lbeq	mos_PLOT_MOVE_absolute			; D0D9 move absolute
;		ldb	#0x05					; Y=5
;		anda	#0x03					; mask only bits 0 and 1
;		beq	LD080					; if result is 0 then its a move (multiple of 8)
;		lsra						; else move bit 0 int C
;		bcs	x_graphics_colour_wanted		; if set then D078 graphics colour required
;		decb						; Y=4
;		bra	LD080					; logic inverse colour must be wanted
;; graphics colour wanted
x_graphics_colour_wanted::	TODO "x_graphics_colour_wanted"
;
;		jsr	mos_tax					; X=A if A=0 its a foreground colour 1 its background
;		ldb	vduvar_GRA_PLOT_FORE,x			; get fore or background graphics PLOT mode
;		lda	vduvar_GRA_FORE,x			; get fore or background graphics colour
;;;	tax						; X=A
;LD080:		jsr	x_set_gra_masks_newAPI		; set up colour masks in D4/5
;		lda	vduvar_VDU_Q_PLT_CODE			; get plot type
;		lbmi	x_VDU_EXTENSION				; if &80-&FF then D0AB type not implemented
;		asla						; bit 7=bit 6
;		bpl	x_analyse_first_parameter_in_0to63_range; if bit 6 is 0 then plot type is 0-63 so D0C6
;		anda	#0xF0					; else mask out lower nybble
;		asla						; shift old bit 6 into C bit old 5 into bit 7
;		beq	mos_PLOT_A_SINGLE_POINT			; if 0 then type 64-71 was called single point plot
;							; goto D0D6
;		eora	#0x40					; if bit 6 NOT set type &80-&87 fill triangle
;		lbeq	mos_PLOT_Fill_triangle_routine		; so D0A8
;		pshs	A					; else push A
;		jsr	x_copyplotcoordsexttoGRACURINT					; copy 0320/3 to 0324/7 setting XY in current graphics
;							; coordinates
;		puls	A					; get back A
;		eora	#0x60					; if BITS 6 and 5 NOT SET type 72-79 lateral fill 
;		beq	LD0AE					; so D0AE
;		cmpa	#0x40					; if type 88-95 horizontal line blanking
;		lbne	x_VDU_EXTENSION				; so D0AB

;		lda	#0x02					; else A=2
;		sta	zp_vdu_wksp+2				; store it
;		jmp	plot_filhorz_back_qry			; and jump to D506 type not implemented ??? DB: I think is fill line in background colour!
; ----------------------------------------------------------------------------
;LD0AE:		sta	zp_vdu_wksp+2				;	D0AE
;		jmp	mos_LATERAL_FILL_ROUTINE		;	D0B0
; ----------------------------------------------------------------------------
; set colour masks; graphics plot mode in B ; colour in A
; was plot mode in Y, colour in X
x_set_gra_masks_newAPI::	TODO "x_set_gra_masks_newAPI"
;
;		ldx	#0
;		abx
;		pshs	A
;		ora	mostbl_GCOL_options_proc,X	;	D0B4
;		eora	mostbl_GCOL_options_proc+1,X	;	D0B7
;		sta	zp_vdu_gracolourOR		;	D0BA
;		puls	A
;		ora	mostbl_GCOL_options_proc0,X	;	D0BD
;		eora	mostbl_GCOL_options_proc+4,X	;	D0C0
;		sta	zp_vdu_gracolourEOR		;	D0C3
;		rts					;	D0C5
;; ----------------------------------------------------------------------------
;; analyse first parameter in 0-63 range;  
x_analyse_first_parameter_in_0to63_range::	TODO "x_analyse_first_parameter_in_0to63_range"
;
;		asla					;shift left again
;		lbmi	x_VDU_EXTENSION			;if -ve options are in range 32-63 not implemented
;		asla					;shift left twice more
;		asla					;
;		bpl	1F				;if still +ve type is 0-7 or 16-23 so D0D0
;		jsr	x_PLOT_grpixmask_ckbounds	;else display a point
;10x:		jsr	x_mos_draw_line	;perform calculations
;		jmp	mos_PLOT_MOVE_absolute		;
;; ----------------------------------------------------------------------------
;; PLOT A SINGLE POINT
mos_PLOT_A_SINGLE_POINT::	TODO "mos_PLOT_A_SINGLE_POINT"
;	; LD0D6
;		jsr	x_PLOT_grpixmask_ckbounds		; plot the point
mos_PLOT_MOVE_absolute::	TODO "mos_PLOT_MOVE_absolute"
;	; LD0D9
;		jsr	x_exg4atGRACURINTwithGRACURINTOLD	; save the old cursor
x_copyplotcoordsexttoGRACURINT::	TODO "x_copyplotcoordsexttoGRACURINT"
;	; LD0DC
;		ldy	#vduvar_GRA_CUR_INT			;	D0DC
x_copyplotcoordsexttoY::	TODO "x_copyplotcoordsexttoY"
;	; LD0DE
;		ldx	#vduvar_VDU_Q_PLT_X			;	D0DE
;		jmp	copy4fromXtoY				;	D0E0
;; ----------------------------------------------------------------------------
;LD0E3::	ldx	#0x24				;	D0E3
;	jsr	x__check_in_window_bounds_setup_screen_addr_atX				;	D0E5
;	beq	x_mos_vdu_gra_drawpixels_in_grpixmask				;	D0E8
;	rts					;	D0EA
;; ----------------------------------------------------------------------------
x_PLOT_grpixmask_ckbounds::	TODO "x_PLOT_grpixmask_ckbounds"
;
;		jsr	x__check_in_window_bounds_setup_screen_addr	;	D0EB
;		bne	LD103rts				;	D0EE
x_mos_vdu_gra_drawpixels_in_grpixmask::	TODO "x_mos_vdu_gra_drawpixels_in_grpixmask"
;	; LD0F0
;		ldb	vduvar_GRA_CUR_CELL_LINE	;	D0F0
;		;; new API check LD0F3 
x_mos_vdu_gra_drawpixels_in_grpixmask_cell_line_in_B::	TODO "x_mos_vdu_gra_drawpixels_in_grpixmask_cell_line_in_B"
;	; LD0F3 
;		ldx	zp_vdu_gra_char_cell
;		abx
;		lda	zp_vdu_grpixmask		;	D0F3
;		anda	zp_vdu_gracolourOR		;	D0F5
;		ora	,x				;	D0F7
;		sta	zp_vdu_wksp			;	D0F9
;		lda	zp_vdu_gracolourEOR		;	D0FB
;		anda	zp_vdu_grpixmask		;	D0FD
;		eora	zp_vdu_wksp			;	D0FF
;		sta	,x				;	D101
LD103rts::	TODO "LD103rts"
;
;		rts					;	D103
;; ----------------------------------------------------------------------------

x_mos_vdu_gra_drawpixel_whole_byte::	TODO "x_mos_vdu_gra_drawpixel_whole_byte"
;
;		pshs	A
;		ldx	zp_vdu_gra_char_cell
;		abx
;		lda	,X				; LD104
;		ora	zp_vdu_gracolourOR
;		eora	zp_vdu_gracolourEOR
;		sta	,X
;		puls	A,PC
;; ----------------------------------------------------------------------------
;; Check window limits;	
;		; returns A = %0000TBRL where any bit means (T)op(B)ottom(R)ight(L)eft bounds
x_Check_window_limits::	TODO "x_Check_window_limits"
;
;		ldx	#vduvar_GRA_CUR_INT		;	D10D
x_Check_window_limits_atX::	TODO "x_Check_window_limits_atX"
;
;		clr	zp_vdu_wksp			;	D111
;		ldy	#vduvar_GRA_WINDOW + 2		;	D113 - bottom
;		jsr	x_cursor_and_margins_check	;	D115	; check Y against BOTTOM/TOP
;		asl	zp_vdu_wksp			;	D118
;		asl	zp_vdu_wksp			;	D11A
;		leax	-2,X
;		leay	-2,Y
;		jsr	x_cursor_and_margins_check	;	D120
;		leax	2,X
;		lda	zp_vdu_wksp			;	D125
;		rts					;	D127
;; ----------------------------------------------------------------------------
;; cursor and margins check;  
;		; API: X is coords to check
;		; return 1 if (2,X) < (0,Y)
;		; return 2 if (2,X) >=(4,Y)
;		; return is in zp_vdu_wksp which is 0 on entry
x_cursor_and_margins_check::	TODO "x_cursor_and_margins_check"
;
;		ldd	2,x				;	D128
;		cmpd	0,y				;	D12B
;		bmi	LD146				;	D134
;		ldd	4,y				;	D136
;		cmpd	2,x				;	D139
;		bpl	LD148				;	D142
;		inc	zp_vdu_wksp			;	D144
;LD146:		inc	zp_vdu_wksp			;	D146
;LD148:		rts					;	D148
;; ----------------------------------------------------------------------------
;; set up and adjust positional data
x_set_up_and_adjust_coords_atX::	TODO "x_set_up_and_adjust_coords_atX"
;	; LD149
;		lda	#0xFF					;A=&FF
;		bne	1F					;then &D150
x_set_up_and_adjust_coords_atX_2::	TODO "x_set_up_and_adjust_coords_atX_2"
;	; LD14D
;		lda	vduvar_VDU_Q_END - 5			;get first parameter in plot;	D14D
;10x:		sta	zp_vdu_wksp				;store in &DA
;		ldy	#vduvar_GRA_WINDOW_BOTTOM		;Y=302
;		jsr	x_gra_coord_ext2int			;set up vertical coordinates/2
;		jsr	signeddivby2atxplus2			;/2 again to convert 1023 to 0-255 for internal use
;							;this is why minimum vertical plot separation is 4
;		ldy	#vduvar_GRA_WINDOW_LEFT			;Y=0
;		leax	-2,X					;X=X-2
;		jsr	x_gra_coord_ext2int			;set up horiz. coordinates/2 this is OK for mode0,4
;		ldb	vduvar_PIXELS_PER_BYTE_MINUS1		;get number of pixels/byte (-1)
;		cmpb	#0x03					;if Y=3 (modes 1 and 5)
;		beq	1F					;D16D
;		bhs	2F					;for modes 0 & 4 this is 7 so D170
;		jsr	signeddivby2atxplus2			;for other modes divide by 2 twice

;10x:		jsr	signeddivby2atxplus2			;divide by 2
;20x:		lda	vduvar_MODE_SIZE			;get screen display type
;		bne	signeddivby2atxplus2			;if not 0 (modes 3-7) divide by 2 again
;		rts						;and exit
;; ----------------------------------------------------------------------------
;; calculate external coordinates in internal format; 
; on entry 	X is usually &31E or &320  
;		Y is vduvar_GRA_WINDOW_BOTTOM or vduvar_GRA_WINDOW_LEFT for vert/horz calc  
x_gra_coord_ext2int::	TODO "x_gra_coord_ext2int"
;	; LD176
;	;;TODO CHECK
;;		CLC
;		lda	zp_vdu_wksp			;get &DA
;		anda	#0x04				;if bit 2=0
;		beq	1F				;then D186 to calculate relative coordinates
;		ldd	2,x				;else get coordinate 
;		bra	2F				;	D184
;10x:		ldd	2,x				;get coordinate 
;		addd	0x10,y				;add cursor position
;20x:		std	0x10,y				;save new cursor 
;		addd	0xC,y				;add graphics origin
;		std	2,x
signeddivby2atxplus2::	TODO "signeddivby2atxplus2"
;	; LD1AD
;		asr	2,x				; DB: change to ASR - TODO: check
;		ror	3,x
;		rts
;; ----------------------------------------------------------------------------
;; calculate external coordinates from internal coordinates
x_calculate_external_coordinates_from_internal_coordinates::	TODO "x_calculate_external_coordinates_from_internal_coordinates"
;	; TODO: speed up by loading X with address of coords instead of offset?
;		ldy	#vduvar_GRA_CUR_EXT
;		jsr	copy4fromGRA_CUR_INTtoY
;		ldx	#0x02
;		ldb	#0x02
;		jsr	LD1D5
;		ldx	#0x00
;		ldb	#0x04
;		lda	vduvar_PIXELS_PER_BYTE_MINUS1
;LD1CB:		decb
;		lsra
;		bne	LD1CB
;		lda	vduvar_MODE_SIZE
;		beq	LD1D5
;		incb
;LD1D5:		asl	vduvar_GRA_CUR_EXT,x
;		rol	vduvar_GRA_CUR_EXT+1,x
;		decb
;		bne	LD1D5
;		ldd	vduvar_GRA_CUR_EXT,x
;		subd	vduvar_GRA_ORG_EXT,x
;		std	vduvar_GRA_CUR_EXT,x
;		rts
;; ----------------------------------------------------------------------------
;; compare X and Y PLOT spans

vduvar_TEMP_draw_W	=	vduvar_TEMP_8 + 0
vduvar_TEMP_draw_H	=	vduvar_TEMP_8 + 2
vduvar_TEMP_draw_XY	=	vduvar_TEMP_8 + 4
vduvar_TEMP_draw_Y	=	vduvar_TEMP_8 + 6

zp_vdu_wksp_draw_flags	=	zp_vdu_wksp + 1		; contains 0x80 if dotted line to be drawn, 0x40 if current point is out of bounds
zp_vdu_wksp_draw_loop_ctr	=	zp_vdu_wksp + 2		; save X (counter?)
zp_vdu_wksp_draw_stop	=	zp_vdu_wksp + 3		; pointer to end of line to be drawn (contains 0x20 or 0x24)
zp_vdu_wksp_draw_slope	=	zp_vdu_wksp + 4		; either 0 or 2 depending on slop of line
zp_vdu_wksp_draw_start	=	zp_vdu_wksp + 5		; pointer to start of line to be drawn (contains either 0x20 or 0x24)
zp_vdu_wksp_draw_sav	=	zp_vdu_wksp + 6		; DB: new used to save single byte register. TODO: check for clash!
;	; bits	purpose
;	; 7	dotted line
;	; 6	start point out of bounds
DRAWFLAGS_START_OOB	=	0x80			; note these are opposite way round to 6502
DRAWFLAGS_START_DOT	=	0x40


vduvar_GRA_WKSP_0_ENDMAJ	=	vduvar_GRA_WKSP + 0
vduvar_GRA_WKSP_2_JMP	=	vduvar_GRA_WKSP + 2	; code to draw pixels?
vduvar_GRA_WKSP_4_DOTORNOT	=	vduvar_GRA_WKSP + 4	; when to draw a dot for dotted lines
vduvar_GRA_WKSP_5_ERRACC	=	vduvar_GRA_WKSP + 5	; the error accumulator, starts with 1/2 the major
vduvar_GRA_WKSP_7_DELTA_MINOR	=	vduvar_GRA_WKSP + 7	; the minor delta (mag of W or H which ever is less)
vduvar_GRA_WKSP_9_DELTA_MAJOR	=	vduvar_GRA_WKSP + 9	; the minor delta (mag of W or H which ever is greater)

x_mos_draw_line::	TODO "x_mos_draw_line"
;	; LD1ED
;		jsr	x_PLOTXYsubGRACURStoTEMP8	; get line width/height
;		lda	vduvar_TEMP_draw_H		; eor top bytes of height
;		eora	vduvar_TEMP_draw_W		; and width
;		bmi	1F				; if differing signs
;		ldd	vduvar_TEMP_draw_W		; compare width to height
;		subd	vduvar_TEMP_draw_H		; NOTE: swapped sense here for differing C flag behaviour TODO: check!
;		bra	2F				;
; ---------------------------------------------------------------------------
;10x:		ldd	vduvar_TEMP_draw_W		; signs are different add width to
;		addd	vduvar_TEMP_draw_H		; height
;20x:		
;		; 	W	H	C
;		;	-	-	|W|>|H|
;		;	+	+	|W|<|H|
;		;	-	+	|W|<|H|
;		;	+	-	|W|>|H|

;		rora						
;		ldb	#0x00					
;		eora	vduvar_TEMP_draw_H			

;		; 	W	H	C
;		;	-	-	|W|<|H|
;		;	+	+	|W|<|H|
;		;	-	+	|W|<|H|
;		;	+	-	|W|<|H|

;		bpl	1F		; branch if |W| > |H|			
;		ldb	#0x02					

;		; at this point B = 0 if |W| < |H|


;10x:		stb	zp_vdu_wksp_draw_slope			;	D21E
;		ldx	#mostbl_drawline_major_routine
;		ldx	B,X
;		stx	vduvar_VDU_VEC_JMP			;	D229

;		; at this point the choice has been made whether to:
;		; move up every pixel (|H|>|W|) or 
;		; move right every pixel (|H|<|W|)

;		ldx	#vduvar_TEMP_8			; get sign of either X or Y
;		tst	B,X				; depending on B (Y if moving up, X if moving right)
;		bpl	1F				; test direction
;		ldx	#vduvar_GRA_CUR_INT		; start drawing from current cursor
;		bra	2F
;10x:		ldx	#vduvar_VDU_Q_PLT_X		; start from plot point and work back
;20x:		STX_B	zp_vdu_wksp_draw_start		; store the low byte of the start coords pointer
;		ldy	#vduvar_TEMP_draw_XY		; 
;		jsr	copy4fromXtoY			; copy starting coord to XY accumulator
;		ldb	zp_vdu_wksp_draw_start		; get the ending coordinate
;		eorb	#0x04				; by eor'ing with 4
;		stb	zp_vdu_wksp_draw_stop		; and store the low byte of this
;		orb	zp_vdu_wksp_draw_slope		; select X or Y depending on slope 
;		ldx	#vduvars_start			; point at page 3
;		abx					; X points at ending X or Y depending on slope
;		jsr	copy2fromXto330			; store in vduvar_GRA_WKSP_0_ENDMAJ

;		lda	vduvar_VDU_Q_PLT_CODE			
;		anda	#0x10				; dotted line
;		asla					; 
;		asla					; 
;		sta	zp_vdu_wksp_draw_flags		; store in flags as bit 7

;		ldx	#vduvar_TEMP_draw_XY		; get starting coordinate
;		jsr	x_Check_window_limits_atX	; check bounds
;		sta	zp_vdu_wksp_draw_loop_ctr	; store for later check of ending coords
;		beq	1F				; if eq then in bounds don't set flag

;	IF CPU_6309
;		oim	#DRAWFLAGS_START_OOB, zp_vdu_wksp_draw_flags	; flag start point is out of bounds
;	ELSE
;		rol	zp_vdu_wksp_draw_flags
;		SEC
;		ror	zp_vdu_wksp_draw_flags		
;	ENDIF

;10x:		ldb	zp_vdu_wksp_draw_stop		; LD263
;		ldx	#vduvars_start
;		abx
;		jsr	x_Check_window_limits_atX	; check to see if endpoint is OOB
;		bita	zp_vdu_wksp_draw_loop_ctr	; and with saved OOB flags from above
;		beq	1F				; not the same
;		rts					; if both start and stop out of bounds 
;							; _in the same extreme_ POH
;; ----------------------------------------------------------------------------
;10x:
;	IF BLITTER
;		ora	zp_vdu_wksp_draw_flags
;		sta	zp_vdu_wksp_draw_flags		; used int blitter test
;	ENDIF
;		ldb	zp_vdu_wksp_draw_slope		; LD26D
;		beq	1F				; depending on slope
;		lsra					; shift top bound flag into right bound flag
;		lsra					;
;10x:		anda	#0x02				; check right bound (or top) flag
;		beq	x_drawline_majorend_notoob	; skip following if not oob
;		orb	#0x04				; == 6 or 4 depending on slope
;		ldx	#vduvars_start
;		abx
;		jsr	copy2fromXto330			; copy right (or top) graphics window value into
;							; vduvar_GRA_WKSP_0_ENDMAJ, replacing requested coord
x_drawline_majorend_notoob::	TODO "x_drawline_majorend_notoob"
;
;		jsr	x_drawline_init_bresenham	;	D27E

;	IF BLITTER

;		lda	sysvar_USERFLAG
;		coma
;		ora	zp_vdu_wksp_draw_flags
;		lbeq	x_drawline_blit
;	ENDIF



;		ldb	zp_vdu_wksp_draw_slope		;	D281
;		eorb	#0x02				;	D283
;		stb	zp_vdu_wksp_draw_sav
;;;	tax						;	D285
;;;	tay						;	D286
;		lda	vduvar_TEMP_draw_W		; check for with width / height -ve
;		eora	vduvar_TEMP_draw_H		;	D28A
;		bpl	LD290				;	D28D
;		incb					;	D28F
;LD290:		ldx	#mostbl_drawline_minor_routine
;		aslb
;		ldx	B,X
;		rorb
;		stx	vduvar_GRA_WKSP_2_JMP		;	D293
;		lda	#0x7F				;	D29C
;		sta	vduvar_GRA_WKSP_4_DOTORNOT	;	D29E
;	IF BLITTER
;		lda	zp_vdu_wksp_draw_flags		; test and remove end OOB flags
;		anda	#0xC0
;		sta	zp_vdu_wksp_draw_flags
;	ELSE
;		tsta
;	ENDIF
;		tfr	B,A
;		bmi	LD2CE				;	D2A3
;		ldx	#mostbl_VDU_mode_size+7
;		ldb	B,X				; 4, 0, 6 or 2 depending on B
;	tax						;	D2A8
;		ldx	#vduvar_GRA_WINDOW_LEFT
;		ldd	B,X				; 	D2AA
;		LDY_B	zp_vdu_wksp_draw_sav
;		subd	vduvar_TEMP_draw_XY,Y
;;;	sbc	vduvar_TEMP_8+4,y			;	D2AD
;;;	sta	zp_vdu_wksp				;	D2B0
;;;	lda	vduvar_GRA_WINDOW_LEFT+1,x		;	D2B2
;;;	sbc	vduvar_TEMP_8+5,y			;	D2B5
;;;	ldy	zp_vdu_wksp				;	D2B8
;;;	tax						;	D2BA
;		bpl	LD2C0				;	D2BB
;		m_NEGD	;	D2BD
;LD2C0:
;;;	tax						;	D2C0
;;;	iny						;	D2C1
;;;	bne	LD2C5					;	D2C2
;;;	inx						;	D2C4
;LD2C5::	txa						;	D2C5
;;;		addd	#1
;;;
;;;		tsta
;		incb
;		bne	LD2C5
;		inca
;LD2C5:		tsta	; TODO REMOVE?
;	
;		beq	1F					;	D2C6
;		ldb	#0x00					;	D2C8
;10x:		stb	zp_vdu_wksp_draw_start			;	D2CA
;		beq	LD2D7					;	D2CC

;LD2CE:		
;;;	txa						;	D2CE
;		lsra						;	D2CF
;		rora						;	D2D0
;		ora	#0x02					;	D2D1
;		eora	zp_vdu_wksp_draw_slope			;	D2D3
;		sta	zp_vdu_wksp_draw_slope			;	D2D5
;LD2D7:		ldx	#vduvar_TEMP_draw_XY			;	D2D7
;		jsr	x_setup_screen_addr_from_intcoords_atX	;	D2D9
;		ldx	zp_vdu_wksp_draw_loop_ctr
;		leax	-1,X
;		stx	zp_vdu_wksp_draw_loop_ctr
x_drawline_loop::	TODO "x_drawline_loop"
;	; LD2E3
;		lda	zp_vdu_wksp_draw_flags		; check flags
;		beq	x_drawline_plot_point		; no flags - plot this point
;		asla
;		bpl	x_drawline_notdotted		; if not 0x80 set then not dotted line
;		tst	vduvar_GRA_WKSP_4_DOTORNOT	;	D2E9
;		bpl	LD2F3				;	D2EC
;		dec	vduvar_GRA_WKSP_4_DOTORNOT	;	D2EE
;		bne	LD316				;	D2F1
;LD2F3:		inc	vduvar_GRA_WKSP_4_DOTORNOT	;	D2F3
;		bcc	x_drawline_plot_point		; not expecting to go oob
x_drawline_notdotted::	TODO "x_drawline_notdotted"
;	; LD2F9	
;		ldx	#vduvar_TEMP_draw_XY			;	D2FB
;		jsr	x__check_in_window_bounds_setup_screen_addr_atX				;	D2FD
;;;	ldx	zp_vdu_wksp_draw_loop_ctr			;	D300
;		tsta						;	D302
;		bne	LD316					;	D304

x_drawline_plot_point::	; LD306	

;		lda	zp_vdu_grpixmask			;	D306
;		anda	zp_vdu_gracolourOR			;	D308
;		ldb	vduvar_GRA_CUR_CELL_LINE
;		ldx	zp_vdu_gra_char_cell
;		abx
;		ora	,X
;		sta	zp_vdu_wksp			;	D30C
;		lda	zp_vdu_gracolourEOR		;	D30E
;		anda	zp_vdu_grpixmask		;	D310
;		eora	zp_vdu_wksp			;	D312
;		sta	,X
;		;;;	sta	(zp_vdu_gra_char_cell),y	;	D314
;LD316:
;;;	sec					;	D316
;		ldd	vduvar_GRA_WKSP_5_ERRACC		;	D317
;		subd	vduvar_GRA_WKSP_7_DELTA_MINOR		;	D31A
;		bcc	LD339				;	D326
;		addd	vduvar_GRA_WKSP_9_DELTA_MAJOR		;	D32D
;		SEC					;	D338
;LD339:		std	vduvar_GRA_WKSP_5_ERRACC		;	D339
;		pshs	CC				;	D33C
;		bcc	LD348				;	D33D
;		jmp	[vduvar_GRA_WKSP_2_JMP]		;	D33F
;; ----------------------------------------------------------------------------
;; vertical scan module 1
x_drawline_minor_up::	TODO "x_drawline_minor_up"
;	; LD342
;		dec	vduvar_GRA_CUR_CELL_LINE	;	D342
;		bpl	LD348				;	D343
;		jsr	x_move_display_point_up_a_line	;	D345
;LD348:		jmp	[vduvar_VDU_VEC_JMP]		; call major increment routine
;; ----------------------------------------------------------------------------
;; vertical scan module 2
x_drawline_minor_down::	TODO "x_drawline_minor_down"
;	; LD34B
;		inc	vduvar_GRA_CUR_CELL_LINE
;		ldb	vduvar_GRA_CUR_CELL_LINE	; increment cell line counter
;		cmpb	#0x08				; if overflowed
;		bne	LD348				; add a line's worth to pointer
;		ldd	zp_vdu_gra_char_cell		;
;		addd	vduvar_BYTES_PER_ROW		;
;		bpl	LD363				;
;		suba	vduvar_SCREEN_SIZE_HIGH		; if we got here wrap screen
;LD363:		clr	vduvar_GRA_CUR_CELL_LINE
;		std	zp_vdu_gra_char_cell		;
;		jmp	[vduvar_VDU_VEC_JMP]
;; ----------------------------------------------------------------------------
;; horizontal scan module 1
x_drawline_minor_right::	TODO "x_drawline_minor_right"
;	; LD36A
;		lsr	zp_vdu_grpixmask		;	D36A
;		bcc	LD348				;	D36C
;		jsr	x_move_display_move_right_to_next_cell				;	D36E
;		jmp	[vduvar_VDU_VEC_JMP]		;	D371
;; ----------------------------------------------------------------------------
;; horizontal scan module 2
x_drawline_minor_left::	TODO "x_drawline_minor_left"
;	; LD374
;		asl	zp_vdu_grpixmask		;	D374
;		bcc	LD348				;	D376
;		jsr	x_move_display_move_left_to_next_cell				;	D378
;		jmp	[vduvar_VDU_VEC_JMP]		;	D37B


;; ----------------------------------------------------------------------------
x_drawline_major_up::	TODO "x_drawline_major_up"
;	; LD37D
;		dec	vduvar_GRA_CUR_CELL_LINE	;	D37E
;		bpl	1F				;	D37F
;		jsr	x_move_display_point_up_a_line	;	D381
;		bra	1F				;	D384
x_drawline_major_right::	TODO "x_drawline_major_right"
;	; LD386
;		lsr	zp_vdu_grpixmask		;	D386
;		bcc	1F				;	D388
;		jsr	x_move_display_move_right_to_next_cell				;	D38A
;10x:		puls	CC				;	D38D
;;		ldx	zp_vdu_wksp_draw_loop_ctr
;;		leax	1,X
;;		stx	zp_vdu_wksp_draw_loop_ctr
;		inc	zp_vdu_wksp_draw_loop_ctr+1
;		bne	1F
;		inc	zp_vdu_wksp_draw_loop_ctr+0
;		beq	LD39Frts				;	D393
;10x:		tst	zp_vdu_wksp_draw_flags		;	D395
;		bmi	x_drawline_move_coords_for_check				;	D397
;		lbcc	x_drawline_loop				;	D399
;		dec	zp_vdu_wksp_draw_start			;	D39B
;		lbne	x_drawline_loop				;	D39D
LD39Frts::	TODO "LD39Frts"
;
;		rts					;	D39F
;; ----------------------------------------------------------------------------
; Still doing starting bounds check update the X/Y coords 
x_drawline_move_coords_for_check::	TODO "x_drawline_move_coords_for_check"
;	; LD3A0
;		lda	zp_vdu_wksp_draw_slope			;	D3A0
;		ldy	#vduvar_TEMP_draw_XY
;		anda	#0x02				;	D3A4
;		bcc	LD3C2				; DB: swapped sense here

;		tst	zp_vdu_wksp_draw_slope		;	D3A9
;		bmi	LD3B7				;	D3AB
;		ldx	A,Y
;		leax	1,X
;		stx	A,Y
;	inc	vduvar_TEMP_8+4,x		;	D3AD
;	bne	LD3C2				;	D3B0
;	inc	vduvar_TEMP_8+5,x		;	D3B2
;	bcc	LD3C2				;	D3B5
;		bra	LD3C2
;LD3B7:		
;		ldx	A,Y
;		leax	-1,X
;		stx	A,Y

;;;	lda	vduvar_TEMP_8+4,x		;	D3B7
;;;	bne	LD3BF				;	D3BA
;;;	dec	vduvar_TEMP_8+5,x		;	D3BC
;;;LD3BF:	dec	vduvar_TEMP_8+4,x	;	D3BF

;LD3C2:		eora	#0x02				;	D3C3
;		ldx	A,Y
;		leax	1,X
;		stx	A,Y
;;;	inc	vduvar_TEMP_8+4,x		;	D3C6
;;;	bne	LD3CE				;	D3C9
;;;	inc	vduvar_TEMP_8+5,x		;	D3CB
;;;LD3CE:	ldx	zp_vdu_wksp+2		;	D3CE
;		jmp	x_drawline_loop				;	D3D0
;; ----------------------------------------------------------------------------
;; move display point up a line
x_move_display_point_up_a_line::	TODO "x_move_display_point_up_a_line"
;
;		ldd	zp_vdu_gra_char_cell
;		subd	vduvar_BYTES_PER_ROW
;		cmpa	vduvar_SCREEN_BOTTOM_HIGH
;		bhs	1F
;		adda	vduvar_SCREEN_SIZE_HIGH		; wrap!
;10x:		std	zp_vdu_gra_char_cell
;		ldb	#7
;		stb	vduvar_GRA_CUR_CELL_LINE
;		rts
;; ----------------------------------------------------------------------------
;		;TODO: use index register instead?
;		; keep 8 bit ops, slightly quicker
x_move_display_move_right_to_next_cell::	TODO "x_move_display_move_right_to_next_cell"
;	; LD3ED
;		lda	vduvar_LEFTMOST_PIX_MASK	;	D3ED
;		sta	zp_vdu_grpixmask		;	D3F0
;		ldb	zp_vdu_gra_char_cell+1
;		addb	#8
;		stb	zp_vdu_gra_char_cell+1
;		bcc	1F
;		inc	zp_vdu_gra_char_cell
;10x:		rts					;	D3FC
;; ----------------------------------------------------------------------------
;		; keep 8 bit ops, slightly quicker
x_move_display_move_left_to_next_cell::	TODO "x_move_display_move_left_to_next_cell"
;
;		lda	vduvar_RIGHTMOST_PIX_MASK	;	D3FD
;		sta	zp_vdu_grpixmask		;	D400
;		ldb	zp_vdu_gra_char_cell+1
;		subb	#8
;		stb	zp_vdu_gra_char_cell+1
;		bcc	1F
;		dec	zp_vdu_gra_char_cell+0
;10x:		rts
;; ----------------------------------------------------------------------------
;; :: coordinate subtraction
x_PLOTXYsubGRACURStoTEMP8::	TODO "x_PLOTXYsubGRACURStoTEMP8"
;
;		ldy	#vduvar_TEMP_8
;		ldx	#vduvar_VDU_Q_PLT_X
x_coords_to_width_height::	TODO "x_coords_to_width_height"
;	; LD411
;		jsr	1F				
;10x:		ldd	4,x
;		subd	,x++
;		std	,y++
;		rts					;	D42B
;; ----------------------------------------------------------------------------

; caculate the initial error accumulator and deltas
; on entry 	X = 306 or 304 depending on slope
; 		Y = zp_vdu_wksp+2 (332)

x_drawline_init_bresenham::	TODO "x_drawline_init_bresenham"
;	; LD42C
;		lda	zp_vdu_wksp_draw_slope		; depending on slope
;		bne	LD437				;
;		ldx	#vduvar_TEMP_draw_W		;
;		ldy	#vduvar_TEMP_draw_H		;
;		jsr	x_exchange_2atY_with_2atX	; swap width / height if going up
;LD437:		ldx	#vduvar_TEMP_draw_W		;
;		ldy	#vduvar_GRA_WKSP_7_DELTA_MINOR	;
;		jsr	copy4fromXtoY			; 
;		LDX_B	zp_vdu_wksp_draw_slope		;	D43F
;		ldd	vduvar_GRA_WKSP_0_ENDMAJ	; get major end point
;		subd	vduvar_TEMP_draw_XY,X		; subtract major start point
;		bmi	LD453				; get absolute value
;		m_NEGD					;	D450

;LD453:		std	zp_vdu_wksp_draw_loop_ctr	
;		ldx	#vduvar_GRA_WKSP_5_ERRACC	;	D457

; This is used in both line drawing and triangle filling to initialise the variables needed
; to track along the edge. Sets the deltas to absolute values, and initialises an error
; term to half the absolute delta in Y.
;
;   X[4,5] = ABS(X[4,5])
;   X[2,3] = ABS(X[2,3])
;   X[0,1] = X[4,5] / 2
;
; On Entry:
;       X = source (offset from .vduVariablesStart)
;
; On Exit:
;       D = absolute value of X[2,3]


;LD459:		jsr	x_drawline_init_get_delta	;	D459
;		lsra					;	D45C
;		rorb					;	D461
;		std	0,X				; store half the major delta as the initial error (middle of point)
;		leax	-2,X

x_drawline_init_get_delta::	TODO "x_drawline_init_get_delta"
;
;		ldd	4,X				; get the delta
;		bpl	1F				; if +ve skip
;		m_NEGD					; negate
;		std	4,X				; store the delta
;10x:		rts					; LD47B
;; ----------------------------------------------------------------------------
copy8fromXtoY::	TODO "copy8fromXtoY"
;
;		ldb	#0x08				; LD47C
;		bra	x_copy_B_bytes_from_XtoY
copy2fromXto330::	TODO "copy2fromXto330"
;	; LD480
;		ldy	#vduvar_GRA_WKSP
copy2fromXtoY::	TODO "copy2fromXtoY"
;	; LD482
;		ldb	#0x02				
;		bra	x_copy_B_bytes_from_XtoY
copy4from324to328::	TODO "copy4from324to328"
;
;		ldy	#vduvar_TEMP_8		; LD486
copy4fromGRA_CUR_INTtoY::	TODO "copy4fromGRA_CUR_INTtoY"
;
;		ldx	#vduvar_GRA_CUR_INT		; LD488
copy4fromXtoY::	TODO "copy4fromXtoY"
;
;		ldb	#0x04				; LD48A
x_copy_B_bytes_from_XtoY::	TODO "x_copy_B_bytes_from_XtoY"
;	; LDF8C
;		lda	,x+
;		sta	,y+
;		decb
;		bne	x_copy_B_bytes_from_XtoY
;		rts

;	IF CPU_6809

;; ----------------------------------------------------------------------------
;; negation routine
x_negation_routine_newAPI::	TODO "x_negation_routine_newAPI"
;
;		coma					; TODO CHECK!
;		comb
;		addd	#1
;		rts
;	ENDIF


;	IF BLITTER
x_drawline_blit::	TODO "x_drawline_blit"
;
;		ldx	#vduvar_TEMP_draw_XY
;		jsr 	x_setup_screen_addr_from_intcoords_atX


;		lda	zp_mos_jimdevsave
;		pshs	A
;		lda	#JIM_DEVNO_BLITTER
;		sta	zp_mos_jimdevsave
;		sta	fred_JIM_DEVNO
;		ldx	#jim_page_DMAC
;		stx	fred_JIM_PAGE_HI

;		; line drawing test
;		;============================
;		; set start point address
;		lda	#0xFF
;		sta	jim_DMAC_ADDR_C
;		sta	jim_DMAC_ADDR_D
;		ldx	zp_vdu_gra_char_cell
;		ldb	vduvar_GRA_CUR_CELL_LINE
;		abx
;		stx	jim_DMAC_ADDR_C+1
;		stx	jim_DMAC_ADDR_D+1
;		ldx	vduvar_BYTES_PER_ROW
;		stx	jim_DMAC_STRIDE_C
;		stx	jim_DMAC_STRIDE_D

;		; set start point pixel mask and colour
;		lda	zp_vdu_gracolourOR
;		eora	zp_vdu_gracolourEOR
;		sta	jim_DMAC_DATA_B		
;		lda	zp_vdu_grpixmask				
;		sta	jim_DMAC_DATA_A
;		; set major length
;		ldd	zp_vdu_wksp_draw_loop_ctr
;		m_NEGD
;		std	jim_DMAC_WIDTH		; 16 bits!
;		; set slope
;		ldd	vduvar_GRA_WKSP_9_DELTA_MAJOR
;		std	jim_DMAC_ADDR_B+1		
;		ldd	vduvar_GRA_WKSP_5_ERRACC
;		std	jim_DMAC_ADDR_A+1		; initial error accumulator value
;		ldd	vduvar_GRA_WKSP_7_DELTA_MINOR
;		std	jim_DMAC_STRIDE_A

;		;set func gen to be plot B masked by A
;		lda	#0xCA				; B masked by A
;		sta	jim_DMAC_FUNCGEN

;		; set bltcon 0
;		lda	#BLITCON_EXEC_C + BLITCON_EXEC_D
;		sta	jim_DMAC_BLITCON
;		; set bltcon 1 - right/down
;		ldb	zp_vdu_wksp_draw_slope
;		lda	vduvar_TEMP_draw_W		; check for with width / height -ve
;		eora	vduvar_TEMP_draw_H		;	D28A
;		bpl	1F				;	D28D
;		incb					;	D28F
;10x:		ldx	#mostbl_slope2bltcon		
;		lda	B,X
;		ora	#BLITCON_ACT_ACT + BLITCON_ACT_CELL + BLITCON_ACT_LINE
;		
;		sta	jim_DMAC_BLITCON

;		puls	A
;		sta	zp_mos_jimdevsave
;		sta	fred_JIM_DEVNO

;		rts

mostbl_slope2bltcon::
		.db	0x20,0x00,0x10,0x30

;	ENDIF

;	pha					;	D49B
;	tya					;	D49C
;	eor	#0xFF				;	D49D
;	tay					;	D49F
;	pla					;	D4A0
;	eor	#0xFF				;	D4A1
;	iny					;	D4A3
;	bne	LD4A9				;	D4A4
;	clc					;	D4A6
;	adc	#0x01				;	D4A7
;LD4A9::	rts					;	D4A9
;; ----------------------------------------------------------------------------
;LD4AA::	jsr	x__check_in_window_bounds_setup_screen_addr;	D4AA
;	bne	LD4B7				;	D4AD
;	lda	(zp_vdu_gra_char_cell),y	;	D4AF
;	eor	vduvar_GRA_BACK			;	D4B1
;	sta	zp_vdu_wksp			;	D4B4
;	rts					;	D4B6
;; ----------------------------------------------------------------------------
;LD4B7::	pla					;	D4B7
;	pla					;	D4B8
;LD4B9::	inc	vduvar_GRA_CUR_INT+2		;	D4B9
;	jmp	LD545				;	D4BC
;; ----------------------------------------------------------------------------
;; LATERAL FILL ROUTINE
mos_LATERAL_FILL_ROUTINE::	TODO "mos_LATERAL_FILL_ROUTINE"
;
;		TODO "mos_LATERAL_FILL_ROUTINE"
;	jsr	LD4AA				;	D4BF
;	and	zp_vdu_grpixmask		;	D4C2
;	bne	LD4B9				;	D4C4
;	ldx	#0x00				;	D4C6
;	jsr	LD592				;	D4C8
;	beq	LD4FA				;	D4CB
;	ldy	vduvar_GRA_CUR_CELL_LINE	;	D4CD
;	asl	zp_vdu_grpixmask		;	D4D0
;	bcs	LD4D9				;	D4D2
;	jsr	LD574				;	D4D4
;	bcc	LD4FA				;	D4D7
;LD4D9::	jsr	x_move_display_move_left_to_next_cell				;	D4D9
;	lda	(zp_vdu_gra_char_cell),y	;	D4DC
;	eor	vduvar_GRA_BACK			;	D4DE
;	sta	zp_vdu_wksp			;	D4E1
;	bne	LD4F7				;	D4E3
;	sec					;	D4E5
;	txa					;	D4E6
;	adc	vduvar_PIXELS_PER_BYTE_MINUS1	;	D4E7
;	bcc	LD4F0				;	D4EA
;	inc	zp_vdu_wksp_draw_flags			;	D4EC
;	bpl	LD4F7				;	D4EE
;LD4F0::	tax					;	D4F0
;	jsr	x_mos_vdu_gra_drawpixel_whole_byte				;	D4F1
;	sec					;	D4F4
;	bcs	LD4D9				;	D4F5
;LD4F7::	jsr	LD574				;	D4F7
;LD4FA::	ldy	#0x00				;	D4FA
;	jsr	LD5AC				;	D4FC
;	ldy	#0x20				;	D4FF
;	ldx	#0x24				;	D501
;	jsr	x_exchange_300_3Y_with_300_3X	;	D503
plot_filhorz_back_qry::	TODO "plot_filhorz_back_qry"
;	; LD506
;		TODO	"plot_filhorz_back_qry - plot fill back?"
;	jsr	LD4AA				;	D506
;	ldx	#0x04				;	D509
;	jsr	LD592				;	D50B
;	txa					;	D50E
;	bne	LD513				;	D50F
;	dec	zp_vdu_wksp_draw_flags			;	D511
;LD513::	dex					;	D513
;LD514::	jsr	LD54B				;	D514
;	bcc	LD540				;	D517
;LD519::	jsr	x_move_display_move_right_to_next_cell				;	D519
;	lda	(zp_vdu_gra_char_cell),y	;	D51C
;	eor	vduvar_GRA_BACK			;	D51E
;	sta	zp_vdu_wksp			;	D521
;	lda	zp_vdu_wksp+2			;	D523
;	bne	LD514				;	D525
;	lda	zp_vdu_wksp			;	D527
;	bne	LD53D				;	D529
;	sec					;	D52B
;	txa					;	D52C
;	adc	vduvar_PIXELS_PER_BYTE_MINUS1	;	D52D
;	bcc	LD536				;	D530
;	inc	zp_vdu_wksp_draw_flags			;	D532
;	bpl	LD53D				;	D534
;LD536::	tax					;	D536
;	jsr	x_mos_vdu_gra_drawpixel_whole_byte				;	D537
;	sec					;	D53A
;	bcs	LD519				;	D53B
;LD53D::	jsr	LD54B				;	D53D
;LD540::	ldy	#0x04				;	D540
;	jsr	LD5AC				;	D542
;LD545::	jsr	mos_PLOT_MOVE_absolute				;	D545
;	jmp	x_calculate_external_coordinates_from_internal_coordinates;	D548
;; ----------------------------------------------------------------------------
;LD54B::	lda	zp_vdu_grpixmask		;	D54B
;	pha					;	D54D
;	clc					;	D54E
;	bcc	LD560				;	D54F
;LD551::	pla					;	D551
;	inx					;	D552
;	bne	LD559				;	D553
;	inc	zp_vdu_wksp_draw_flags			;	D555
;	bpl	LD56F				;	D557
;LD559::	lsr	zp_vdu_grpixmask		;	D559
;	bcs	LD56F				;	D55B
;	ora	zp_vdu_grpixmask		;	D55D
;	pha					;	D55F
;LD560::	lda	zp_vdu_grpixmask		;	D560
;	bit	zp_vdu_wksp			;	D562
;	php					;	D564
;	pla					;	D565
;	eor	zp_vdu_wksp+2			;	D566
;	pha					;	D568
;	plp					;	D569
;	beq	LD551				;	D56A
;	pla					;	D56C
;	eor	zp_vdu_grpixmask		;	D56D
;LD56F::	sta	zp_vdu_grpixmask		;	D56F
;	jmp	x_mos_vdu_gra_drawpixels_in_grpixmask				;	D571
;; ----------------------------------------------------------------------------
;LD574::	lda	#0x00				;	D574
;	clc					;	D576
;	bcc	LD583				;	D577
;LD579::	inx					;	D579
;	bne	LD580				;	D57A
;	inc	zp_vdu_wksp_draw_flags			;	D57C
;	bpl	LD56F				;	D57E
;LD580::	asl	a				;	D580
;	bcs	LD58E				;	D581
;LD583::	ora	zp_vdu_grpixmask		;	D583
;	bit	zp_vdu_wksp			;	D585
;	beq	LD579				;	D587
;	eor	zp_vdu_grpixmask		;	D589
;	lsr	a				;	D58B
;	bcc	LD56F				;	D58C
;LD58E::	ror	a				;	D58E
;	sec					;	D58F
;	bcs	LD56F				;	D590
;LD592::	lda	vduvar_GRA_WINDOW_LEFT,x	;	D592
;	sec					;	D595
;	sbc	vduvar_VDU_Q_END - 4			;	D596
;	tay					;	D599
;	lda	vduvar_GRA_WINDOW_LEFT+1,x	;	D59A
;	sbc	vduvar_VDU_Q_END - 3			;	D59D
;	bmi	LD5A5				;	D5A0
;	jsr	x_negation_routine		;	D5A2
;LD5A5::	sta	zp_vdu_wksp_draw_flags			;	D5A5
;	tya					;	D5A7
;	tax					;	D5A8
;	ora	zp_vdu_wksp_draw_flags			;	D5A9
;	rts					;	D5AB
;; ----------------------------------------------------------------------------
;LD5AC::	sty	zp_vdu_wksp			;	D5AC
;	txa					;	D5AE
;	tay					;	D5AF
;	lda	zp_vdu_wksp_draw_flags			;	D5B0
;	bmi	LD5B6				;	D5B2
;	lda	#0x00				;	D5B4
;LD5B6::	ldx	zp_vdu_wksp			;	D5B6
;	bne	LD5BD				;	D5B8
;	jsr	x_negation_routine		;	D5BA
;LD5BD::	pha					;	D5BD
;	clc					;	D5BE
;	tya					;	D5BF
;	adc	vduvar_GRA_WINDOW_LEFT,x	;	D5C0
;	sta	vduvar_VDU_Q_END - 4			;	D5C3
;	pla					;	D5C6
;	adc	vduvar_GRA_WINDOW_LEFT+1,x	;	D5C7
;	sta	vduvar_VDU_Q_END - 3			;	D5CA
;	rts					;	D5CD
;; ----------------------------------------------------------------------------
;; OSWORD 13 read last two graphic cursor positions;  
;mos_OSWORD_13:
;	lda	#0x03				;	D5CE
;	jsr	LD5D5				;	D5D0
;	lda	#0x07				;	D5D3
;LD5D5::	pha					;	D5D5
;	jsr	x_exg4atGRACURINTwithGRACURINTOLD				;	D5D6
;	jsr	x_calculate_external_coordinates_from_internal_coordinates;	D5D9
;	ldx	#0x03				;	D5DC
;	pla					;	D5DE
;	tay					;	D5DF
;LD5E0::	lda	vduvar_GRA_CUR_EXT,x		;	D5E0
;	sta	(zp_mos_OSBW_X),y		;	D5E3
;	dey					;	D5E5
;	dex					;	D5E6
;	bpl	LD5E0				;	D5E7
;	rts					;	D5E9
;; ----------------------------------------------------------------------------
;; PLOT Fill triangle routine
mos_PLOT_Fill_triangle_routine::	TODO "mos_PLOT_Fill_triangle_routine"
;
;	ldx	#vduvar_VDU_Q_START+5
;	ldy	#vduvar_GRA_WKSP+0xE
;	jsr	copy8fromXtoY			; copy 300/7+X to 300/7+Y
;						; this gets XY data parameters and current graphics
;						; cursor position
;	jsr	LD632				; exchange 320/3 with 314/7 if 316/7=<322/3
;	ldx	#vduvar_GRA_CUR_INT_OLD				
;	ldy	#vduvar_GRA_CUR_INT				
;	jsr	LD636				; exchange 324/3 with 314/7 if 316/7=<326/3
;	jsr	LD632				; exchange 320/3 with 314/7 if 316/7=<322/3
;	; =============== Toby Lobster comments and references interspersed see https://tobylobster.github.io/mos/mos/S-s8.html#SP60


;	ldx	#vduvar_VDU_Q_START+5		; Get "main" line delta 
;	ldy	#vduvar_TEMP_8+2		
;	jsr	x_coords_to_width_height	; stores result in Y

;	lda	vduvar_TEMP_8+2			; Get high byte of dX as a flag for later
;	sta	vduvar_GRA_WKSP+2		
;	ldx	#vduvar_TEMP_8			
;	jsr	LD459				; Initialise main line "erracc"
;	ldy	#vduvar_TEMP_8+6		
;	jsr	x_copyplotcoordsexttoY		
;	jsr	x_exg4atGRACURINTwithGRACURINTOLD

;	; fill triangle bottom half

;	CLC						
;	jsr	plotFillTriangleHalf	

;	jsr	x_exg4atGRACURINTwithGRACURINTOLD
;	ldx	#vduvar_VDU_Q_START+5		
;	jsr	x_exg4atGRACURINTOLDwithX
;	SEC			
;	jsr	plotFillTriangleHalf

;	ldx	#vduvar_GRA_WKSP+0xE
;	ldy	#vduvar_VDU_Q_START+5
;	jsr	copy8fromXtoY
;	jmp	mos_PLOT_MOVE_absolute
;; ----------------------------------------------------------------------------
;LD632:	ldx	#vduvar_VDU_Q_START+5
;	ldy	#vduvar_GRA_CUR_INT_OLD		
;LD636:	ldd	2,x				;	if [2+Y] > [2+X] then swap
;	cmpd	2,y				
;	blo	LD657rts				
;	jmp	x_exchange_4atY_with_4atX	
;; ----------------------------------------------------------------------------
;; OSBYTE 134  Read cursor position
mos_OSBYTE_134::	TODO "mos_OSBYTE_134"
;
;		clra
;		ldb	vduvar_TXT_CUR_X		;	D647
;		subb	vduvar_TXT_WINDOW_LEFT		;	D64B
;		tfr	D,X
;		ldb	vduvar_TXT_CUR_Y		;	D64F
;		subb	vduvar_TXT_WINDOW_TOP		;	D653
;		tfr	D,Y
;LD657rts	rts					;	D657
;; ----------------------------------------------------------------------------
plotFillTriangleHalf::	TODO "plotFillTriangleHalf"
;
;		pshs	CC				; store bottom/top flag

;		; find dX,dY for "minor" line

;		ldx	#vduvar_VDU_Q_START+5
;		ldy	#vduvar_GRA_WKSP+5
;		jsr	x_coords_to_width_height

;		; get and store sign of dX for later
;		lda	vduvar_GRA_WKSP+5	
;		sta	vduvar_GRA_WKSP+0xD

;		ldx	#vduvar_GRA_WKSP+3	
;		jsr	LD459				; init minor line delta

;		; init point on minor line

;		ldy	#vduvar_GRA_WKSP+9
;		
;		jsr	x_copyplotcoordsexttoY
;		
;		ldd	vduvar_VDU_Q_START+7		
;		subd	vduvar_GRA_CUR_INT+2		
;		std	vduvar_VDU_Q_START
;		beq	LD69F				;	D686

;LD688:		jsr	LD6A2				;	D688
;		ldx	#vduvar_GRA_WKSP+3		;	D68B
;		jsr	LD774				;	D68D
;		ldx	#vduvar_TEMP_8			;	D690
;		jsr	LD774				;	D692
;		inc	vduvar_VDU_Q_START+1		;	D695
;		bne	LD688				;	D698
;		inc	vduvar_VDU_Q_START		;	D69A
;		bne	LD688				;	D69D
;LD69F:		puls	CC				;	D69F
;		bcc	LD657rts			;	D6A0

;		; do final row at top of triangle

;LD6A2:		ldx	#vduvar_GRA_WKSP+9		;	D6A2
;		ldy	#vduvar_TEMP_8+6		;	D6A4

; *****************************************************
; * OLD API X,Y contained PAGE 3 relative pointers to *
; * start end of line to plot			    *
; * now X,Y contain full pointers			    *
; *****************************************************

x_vdu_clear_gra_line_newAPI::	TODO "x_vdu_clear_gra_line_newAPI"
;	; 	LD6A6
;		stx	zp_vdu_wksp+4				;	check left < right, if not swap em
;		ldd	,X
;		cmpd	,Y
;		blo	1F
;		exg	X,Y
;		stx	zp_vdu_wksp+4				; note: now using 4,6 instead of 4,5
;10x:		sty	zp_vdu_wksp+6				; 
;		ldd	0,y					; right on stack, we're going to use it to count down...
;		pshs	D
;		ldx	zp_vdu_wksp+6				; check right bound
;		jsr	x_Check_window_limits_atX		;
;		beq	1F					;

;		cmpa	#0x02					; check for bounds broken == right
;		bne	3F					; if it's any other bound we're off the screen, skip this line
;		ldd	vduvar_GRA_WINDOW_RIGHT			;
;		std	0,X					; reset right bound to right edge of window/screen 
;10x:		jsr	x_setup_screen_addr_from_intcoords_atX	; setup the screen address pointer
;		ldx	zp_vdu_wksp+4				; check left pointer bounds
;		jsr	x_Check_window_limits_atX		;
;		lsra						; shift right, Left broken into carry rest in A
;		bne	3F					; if anything other than left we're off the screen, skip line
;		bcc	1F					; if not C then left bound ok
;		ldx	#vduvar_GRA_WINDOW_LEFT			;
;10x:		ldd	[zp_vdu_wksp+6]				; subtract left coord (or window left if bounds broken) from right 
;		subd	,x					; to get width
;		std	zp_vdu_wksp+2				; store here
;		clra
;LD6FE:		asla						; shift left one
;		ora	zp_vdu_grpixmask			; copy in another right most pixel to A
;		ldb	zp_vdu_wksp+3				; decrement width counter
;		bne	LD719					;
;		dec	zp_vdu_wksp+2				;
;		bpl	LD719					;
;		sta	zp_vdu_grpixmask			; we're at the left of the line, plot pixels in current pixel mask
;		jsr	x_mos_vdu_gra_drawpixels_in_grpixmask
;30x:		puls	D		
;		std	[zp_vdu_wksp+6]				; restore right bound
;		rts						; done
;; ----------------------------------------------------------------------------
;LD719:		dec	zp_vdu_wksp+3				; decrement width counter
;		tsta						; see if we've filled up A with pixel mask bits
;		bpl	LD6FE					; if not try another pixel
;		sta	zp_vdu_grpixmask			; store the pixel mask
;		jsr	x_mos_vdu_gra_drawpixels_in_grpixmask 	; and plot
;		lda	zp_vdu_wksp+3				; get low byte of width counter
;		inca						; increment it
;		bne	LD72A					;
;		inc	zp_vdu_wksp+2				; and high byte if needed
;LD72A:		pshs	A					; store updated low byte on stack
;		lsr	zp_vdu_wksp+2				; divide by width low by two
;		rora						; divide A by two
;		ldb	vduvar_PIXELS_PER_BYTE_MINUS1		; get pixels per byte
;		cmpb	#0x03					; 
;		beq	LD73B					;
;		bcs	LD73E					;
;		lsr	zp_vdu_wksp+2				;
;		rora						;
;LD73B:		lsr	zp_vdu_wksp+2				;
;		lsra						; 
;LD73E:		ldb	vduvar_GRA_CUR_CELL_LINE		;
;		tsta						;
;		beq	LD753					;	D742
;LD744:		subb	#0x08					;	D746
;		bcc	LD74D					;	D749
;		dec	zp_vdu_gra_char_cell + 0		;	D74B
;LD74D:		jsr	x_mos_vdu_gra_drawpixel_whole_byte
;		deca						;	D750
;		bne	LD744					;	D751


;LD753:
;		puls	A				;	D753
;		anda	vduvar_PIXELS_PER_BYTE_MINUS1	;	D754
;		beq	3B				;	D757
;		pshs	B
;		clrb					;	D75A
;LD75C:		aslb					;	D75C
;		orb	vduvar_RIGHTMOST_PIX_MASK	;	D75D
;		deca					;	D760
;		bne	LD75C				;	D761
;		stb	zp_vdu_grpixmask		;	D763
;		puls	B
;		subb	#0x08				;	D767
;		bcc	LD76E				;	D76A
;		dec	zp_vdu_gra_char_cell		;	D76C
;LD76E:		jsr	x_mos_vdu_gra_drawpixels_in_grpixmask_cell_line_in_B				;	D76E
;		jmp	3B				;	D771
;; ----------------------------------------------------------------------------
;LD774:		inc	9,x				; inc curY (16)
;		bne	LD77C				
;		inc	8,x	
;LD77C:
;		ldd	0,x
;		subd	2,X
;		std	0,X
;		bpl	LD7C1
;LD791:		lda	10,x			; direction flag
;		bmi	LD7A1				
;		inc	7,x				
;		bne	LD7AC				
;		inc	6,x				
;		jmp	LD7AC				
; ----------------------------------------------------------------------------
;LD7A1:		lda	7,x			; decrement cur X
;		bne	LD7A9
;		dec	6,x
;LD7A9:		dec	7,x

;		; update error term
;LD7AC:
;		ldd	0,x
;		addd	4,x
;		std	0,x
;		bmi	LD791				;	D7BF
;LD7C1:		rts					;	D7C1
;; ----------------------------------------------------------------------------
;; OSBYTE 135  Read character at text cursor position
mos_OSBYTE_135::	TODO "mos_OSBYTE_135"
;
;		tst	vduvar_COL_COUNT_MINUS1			;	D7C2
;		bne	LD7DC					;	D7C5
;		lda	[zp_vdu_top_scanline]			;	D7C7
;		ldy	#mostbl_TTX_CHAR_CONV+4			;	D7C9
;LD7CB:		cmpa	,-y					;	D7CB
;		bne	LD7D4					;	D7CE
;		lda	,-y					;	D7D0
;								;	D7D3
;LD7D4:		cmpy	#mostbl_TTX_CHAR_CONV+1			;	D7D4
;		bhi	LD7CB					;	D7D5
mos_OSBYTE_135_YeqMODE_XeqArts::	TODO "mos_OSBYTE_135_YeqMODE_XeqArts"
;
;		LDY_B	vduvar_MODE				;	D7D7
;mos_tax:	m_tax
;		rts						;	D7DB
;; ----------------------------------------------------------------------------
;LD7DC:		jsr	x_set_up_pattern_copy		;set up copy of the pattern bytes at text cursor
;		lda	#0x20				;X=&20
;		ldx	#vduvar_TEMP_8
;		sta	zp_vdu_wksp			;store current char
;		bra	1F
mos_OSBYTE_135_lp1::	TODO "mos_OSBYTE_135_lp1"
;	; LD7E1
;;;	txa						;A=&20
;;;	pha						;Save it
;		lda	zp_vdu_wksp
;10x:		jsr	x_calc_pattern_addr_for_given_char	;get pattern address for code in A
;		ldy	zp_vdu_wksp + 4
;;;	pla						;get back A
;;;	tax						;and X
;LD7E8:		ldb	#0x07				;Y=7
;LD7EA:		lda	B,X				;get byte in pattern copy
;		cmpa	B,Y				;check against pattern source
;		bne	LD7F9				;if not the same D7F9
;		decb					;else Y=Y-1
;		bpl	LD7EA				;and if +ve D7EA
;		lda	zp_vdu_wksp
;		cmpa	#0x7F				;is X=&7F (delete)
;		bne	mos_OSBYTE_135_YeqMODE_XeqArts	;if not D7D7
;LD7F9:		clra
;		inc	zp_vdu_wksp			;else X=X+1
;		beq	mos_OSBYTE_135_YeqMODE_XeqArts	; past 255 give up return A = 0
;		leay	8,Y
;		tfr	Y,D
;		tstb
;	lda	zp_vdu_wksp+4				;get byte lo address
;	clc						;clear carry
;	adc	#0x08					;add 8
;	sta	zp_vdu_wksp+4				;store it
;		bne	LD7E8					;and go back to check next character if <>0
;		bra	mos_OSBYTE_135_lp1			; recalc char pointer (may be into redeffed chars)
;; set up pattern copy
x_set_up_pattern_copy::	TODO "x_set_up_pattern_copy"
;
;		ldb	#0x07				; Y=7
;		ldx	zp_vdu_top_scanline
;		ldy	#vduvar_TEMP_8
;LD80A:		stb	zp_vdu_wksp			; &DA=Y
;		lda	#0x01				; A=1 - this will rol out and signal end of loop
;		sta	zp_vdu_wksp_draw_flags		; &DB=A
;LD810:		lda	vduvar_LEFTMOST_PIX_MASK	; A=left colour mask
;		sta	zp_vdu_wksp+2			; store an &DC
;		lda	B,X				; get a byte from current text character
;		eora	vduvar_TXT_BACK			; EOR with text background colour
;		CLC					; clear carry
;LD81B:		bita	zp_vdu_wksp+2			; and check bits of colour mask
;		beq	LD820				; if result =0 then D820
;		SEC					; else set carry
;LD820:		rol	zp_vdu_wksp_draw_flags		; &DB=&DB+Carry
;		bcs	LD82E				; if carry now set (bit 7 DB originally set) D82E
;		lsr	zp_vdu_wksp+2			; else  &DC=&DC/2 - roll screen bits right
;		bcc	LD81B				; if carry clear D81B - keep going for this mask
;;;	tya					; A=Y
;;;	adc	#0x07				; ADD ( (7+carry)
;;;	tay					; Y=A
;		addb	#8
;		bra	LD810				; 

;LD82E:		ldb	zp_vdu_wksp			; read modified values into Y and A
;		lda	zp_vdu_wksp_draw_flags		; 
;		sta	B,y				; store copy
;		decb					; and do it again
;		bpl	LD80A				; until 8 bytes copied
;		rts					; exit
;; ----------------------------------------------------------------------------
;; pixel reading
;x_pixel_reading:
;	pha					;	D839
;	tax					;	D83A
;	jsr	x_set_up_and_adjust_positional_data;	D83B
;	pla					;	D83E
;	tax					;	D83F
;	jsr	x__check_in_window_bounds_setup_screen_addr_atX				;	D840
;	bne	LD85A				;	D843
;	lda	(zp_vdu_gra_char_cell),y	;	D845
;LD847::	asl	a				;	D847
;	rol	zp_vdu_wksp			;	D848
;	asl	zp_vdu_grpixmask		;	D84A
;	php					;	D84C
;	bcs	LD851				;	D84D
;	lsr	zp_vdu_wksp			;	D84F
;LD851::	plp					;	D851
;	bne	LD847				;	D852
;	lda	zp_vdu_wksp			;	D854
;	and	vduvar_COL_COUNT_MINUS1		;	D856
;	rts					;	D859
;; ----------------------------------------------------------------------------
;LD85A::	lda	#0xFF				;	D85A
LD85Crts::	TODO "LD85Crts"
;
;		rts					;	D85C
;; ----------------------------------------------------------------------------
;; : check for window violations and set up screen address
x__check_in_window_bounds_setup_screen_addr::	TODO "x__check_in_window_bounds_setup_screen_addr"
;
;		ldx	#vduvar_VDU_Q_END - 4		;	D85D
x__check_in_window_bounds_setup_screen_addr_atX::	TODO "x__check_in_window_bounds_setup_screen_addr_atX"
;
;		jsr	x_Check_window_limits_atX	;	D85F
;		bne	LD85Crts				;	D862
x_setup_screen_addr_from_intcoords_atX::	TODO "x_setup_screen_addr_from_intcoords_atX"
;
;		lda	3,X				; get y coord
;		eora	#0xFF				;	D867
;		tfr	A,B				; todo speed this up by using D and MUL?
;		anda	#0x07				;	D86A
;		sta	vduvar_GRA_CUR_CELL_LINE	;	D86C
;		andb	#0xF8
;		lda	#640/8
;		mul
;		tst	vduvar_MODE_SIZE		;	D87C
;		beq	LD884				;	D87F
;		lsra
;		rorb
;LD884:		addd	vduvar_6845_SCREEN_START	;	D884
;		std	zp_vdu_gra_char_cell		;	D887
;		ldd	,X
;		pshs	D
;		andb	vduvar_PIXELS_PER_BYTE_MINUS1	
;		addb	vduvar_PIXELS_PER_BYTE_MINUS1	
;		ldy	#mostbl_VDU_pix_mask_16colour - 1
;		lda	b,y	
;		sta	zp_vdu_grpixmask		
;		ldb	vduvar_PIXELS_PER_BYTE_MINUS1	;	D8A6
;		cmpb	#0x03				;	D8A9
;		puls	D
;		beq	LD8B2				;	4 pixels per byte
;		bhs	LD8B5				;	8 pixels per byte
;						;	2 pixels per byte
;		aslb
;		rola
;		aslb
;		rola
;		bra	LD8B5
;LD8B2:		 aslb
;		rola
;LD8B5:		andb	#0xF8				;	D8B5
;		addd	zp_vdu_gra_char_cell
;		bpl	LD8C6				;	D8C0
;		suba	vduvar_SCREEN_SIZE_HIGH		;	D8C3
;LD8C6:		std	zp_vdu_gra_char_cell		;	D8C6
;		ldb	vduvar_GRA_CUR_CELL_LINE	;	D8C8
LD8CBclrArts::	TODO "LD8CBclrArts"
;
;		clra
;		rts					;	D8CD
;; ----------------------------------------------------------------------------
x_cursor_start::	TODO "x_cursor_start"
;	; LD8CE
;		pshs	A				; Push A
;		ldb	sysvar_VDU_Q_LEN		; X=number of items in VDU queque
;		bne	LD916pulsArts			; if not 0 D916
;	IF CPU_6809
;		lda	#0xA0				; A=&A0
;		bita	zp_vdu_status			; else check VDU status byte
;	ELSE
;		tim	#0xA0, zp_vdu_status
;	ENDIF
;		bne	LD916pulsArts			; if either VDU is disabled or plot to graphics
;						; cursor enabled then D916
;	IF CPU_6809
;		lda	#0x40
;		bita	zp_vdu_status
;	ELSE
;		tim	#0x40, zp_vdu_status
;	ENDIF
;		bne	1F				; if cursor editing enabled D8F5
;		lda	vduvar_CUR_START_PREV		; else get 6845 register start setting
;		anda	#0x9F				; clear bits 5 and 6
;		ora	#0x40				; set bit 6 to modify last cursor size setting
;		jsr	x_crtc_set_cursor		; change write cursor format
;		ldx	#vduvar_TXT_CUR_X		; X=&18
;		ldy	#vduvar_TEXT_IN_CUR_X		; Y=&64
;		jsr	copy2fromXtoY			; set text input cursor from text output cursor
;		jsr	x_setup_read_cursor		; modify character at cursor poistion
;		lda	#0x02				; A=2
;		jsr	x_ORA_with_vdu_status		; bit 1 of VDU status is set to bar scrolling
;10x:
;		lda	#0xBF				;A=&BF
;		jsr	mos_VDU_and_A_vdustatus		;bit 6 of VDU status =0 
;		puls	A				;Pull A
;		anda	#0x7F				;clear hi bit (7)
;		jsr	mos_VDU_WRCH			; exec up down left or right?
;		lda	#0x40				;A=&40
;		jmp	x_ORA_with_vdu_status		;exit 
;; ----------------------------------------------------------------------------
x_cursor_COPY::	TODO "x_cursor_COPY"
;	; LD905
;;	lda	#0x20				;A=&20
;;	bita	zp_vdu_status			
;;	bvc	LD8CBclrArts			;if bit 6 cursor editing is set
;;	bne	LD8CBclrArts			;or bit 5 is set exit &D8CB
;	IF CPU_6809
;		lda	#0x40
;		bita	zp_vdu_status
;	ELSE
;		tim	#0x40, zp_vdu_status
;	ENDIF
;		beq	LD8CBclrArts			; not cursor editing
;	IF CPU_6809
;		lda	#0x20
;		bita	zp_vdu_status
;	ELSE
;		tim	#0x20, zp_vdu_status
;	ENDIF
;		bne	LD8CBclrArts			; VDU5
;		pshs	B,X,Y
;		lda	#135
;		jsr	OSBYTE				;read a character from the screen - note changed this to use
;		tfr	X,D				;OSBYTE instead of direct jump to allow 135 to be intercepted
;		tfr	B,A				;in VNULA utils ROM
;		puls	B,X,Y
;		tsta
;		beq	LD917rts			;if A=0 on return exit via D917
;		pshs	A				;else store A
;		jsr	mos_VDU_9			;perform cursor right
LD916pulsArts::	TODO "LD916pulsArts"
;
;		puls	A				;	D916
LD917rts::	TODO "LD917rts"
;
;		rts					;	D917
;; ----------------------------------------------------------------------------


x_cancel_cursor_edit::	TODO "x_cancel_cursor_edit"
;	; LD918
;		lda	#0xBD				;	D918
;		jsr	mos_VDU_and_A_vdustatus		;	D91A
;		jsr	x_crtc_reset_cursor				;	D91D
;		lda	#0x0D				;	D920
;		rts					;	D922
;; ----------------------------------------------------------------------------
;; OSBYTE 132  Read bottom of display RAM;  
mos_OSBYTE_132::	TODO "mos_OSBYTE_132"
;
;		ldb	vduvar_MODE			; get current screen mode
;; OSBYTE 133  Read lowest address for given mode
mos_OSBYTE_133::	TODO "mos_OSBYTE_133"
;
;		andb	#0x07				; modulo 7 TODO: EXTRA MODES
;		IF MACH_CHIPKIT
;		; TODO: remove bodge for chipkit mk1 (see also mos_VDU_set_mode)
;		cmpb	#7
;		bne	1F
;		ldb	#6
;10x:		
;		ENDIF
;		ldx	#mostbl_VDU_mode_size
;		ldb	B,X				;	D92A
;		ldx	#mostbl_VDU_screebot_h
;		lda	B,X				;	D92D
;		clrb
;		tfr	D,X				; return X is full adress, Y is high byte
;		jmp	LE71F_tay_c_rts
;		m_tay
;;;	tst	sysvar_RAM_AVAIL		;	D932 - removed < 32k check
;;;	bmi	LD93E				;	D935
;;;	anda	#0x3F				;	D937
;;;	cpy	#0x04				;	D939
;;;	bcs	LD93E				;	D93B
;;;	txa					;	D93D
;;;LD93E:	tay					;	D93E
;		rts					;	D93F



mos_VDU_7:	TODO "BELL"
