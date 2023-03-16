		.area _CODE(REL,CON)

; Hodge podge machine

SZ=64	;power of 2
SZS=5	;shift for SZ
Q = 100
K1 = 2
K2 = 2 	
G = 5

OSWRCH	= 0hFFEE

		ld	A,22
		call	OSWRCH
		ld	A,2
		call	OSWRCH

		ld	E,32
		di
		ld	HL,palette
		ld	BC,0xFE23
pl:		ld	A,(HL)
		inc	HL
		out	(C),A
		dec	E
		jr	NZ,pl


		xor	A,A
		ld	(flip),A

		call	srcbank
		ld	DE,SZ*SZ
1$:		call	xrnd
		ld	A,C
		dec	A
		cp	A,Q
		jr	C, 2$
		ld	A,Q
2$:		ld	(HL),A
		inc	HL
		dec	DE
		ld	A,D
		or	A,E
		jr	NZ,1$

mainlp:		call	show
		call	process

		ld	A,(flip)
		xor	A,0xFF
		ld	(flip),A
		jr	mainlp


show:		call	srcbank		; HL points at start of data
		ld	DE,0h3000	; DE points at screen
		ld	BC,64*64

		ld	A,32
		
sh_ch_rw_lp:	ld	(char_rw_ctr),A
		ld	A,64		
sh_ch_col_lp:	ld	(char_col_ctr),A
		push	BC
		ld	A,(HL)
		push	HL
		ld	HL,coltab
		ld	C,A
		ld	B,0
		add	HL,BC
		ld	A,(HL)
		pop	HL

		ld	BC,64		; next row for source data
		add	HL,BC

		pop	BC

		ld	(DE),A
		inc	DE
		ld	(DE),A
		inc	DE
		ld	(DE),A
		inc	DE
		ld	(DE),A
		inc	DE

		; second pixel row in char cell
		push	BC
		ld	A,(HL)
		push	HL
		ld	HL,coltab
		ld	C,A
		ld	B,0
		add	HL,BC
		ld	A,(HL)
		pop	HL

		ld	BC,-63		; prev row, next pixel for source data
		add	HL,BC

		pop	BC

		ld	(DE),A
		inc	DE
		ld	(DE),A
		inc	DE
		ld	(DE),A
		inc	DE
		ld	(DE),A
		inc	DE

		ld	A,(char_col_ctr)
		dec	A	
		jr	NZ, sh_ch_col_lp

		; next screen row
		ld	A,E
		add	A,0h80
		ld	E,A
		jr	NC,1$
		inc	D

		; next data row
		ld	BC,64
		add	HL,BC
1$:

		ld	A,(char_rw_ctr)
		dec	A
		jr	NZ, sh_ch_rw_lp

		ret

process::	xor	A,A
		ld	D,A		; X counter
		ld	E,A		; Y counter
proclp::	call	getNeigh
		call	getXY
		jr	NZ,not_healthy
		; healthy state = 

		ld	A,B
		ld	L,K1
		call	div
		ld	B,H
		ld	A,C
		ld	L,K2
		call	div
		ld	A,B
		add	A,H
		jr	setit		; = infected/k1 + ill/k2

not_healthy::	cp	A,Q
		jr	Z, ill
		; infected
		ld	A,B
		add	A,C
		inc	A		
		call	divHL
		add	A,G
		jr	setit

ill::		xor	A,A		; miraculously recover!
		jr	setit2
setit::		cp	A,Q
		jr	C,setit2
		ld	A,Q
setit2::	call	setXY

		inc	D
		ld	A,D
		cp	A,SZ
		jr	NZ, proclp
		ld	D,0
		inc	E
		ld	A,E
		cp	A,SZ
		jr	NZ, proclp
		ret

getNeigh::	xor	A,A
		ld	B,A
		ld	C,A
		ld	H,A
		call	getXY
		ld	L,A
		dec	D
		call	gn2		;W
		inc	E
		call	gn2		;NW
		inc	D
		call	gn2		;N
		inc	D
		call	gn2		;NE
		dec	E
		call	gn2		;E
		dec	E
		call	gn2		;SE
		dec	D
		call	gn2		;S
		dec	D
		call	gn2		;SW
		inc	D
		inc	E
		ret

gn2::		call	getXY
		ret	Z
		inc	B		;infected
		cp	A,Q
		jr	1$
		inc	C		;ill
1$:		add	A,L
		ld	L,A
		ret	NC
		inc	H
		ret


		; return NC for out of bounds
checkXY::	ld	A,E
		or	A,A
		ret	M
		cp	A,SZ
		ret	NC
		ld	A,D
		or	A,A
		ret	M
		cp	A,SZ
		ret


getXY::		push	BC
		push	HL
		call	checkXY
		jr	NC,1$
		ld	H,0
		ld	L,E		;Y
		add	HL,HL
		add	HL,HL
		add	HL,HL
		add	HL,HL
		add	HL,HL
		add	HL,HL
		ld	B,H
		ld	C,L
		call	srcbank
		add	HL,BC
		ld	C,D		;X
		ld	B,0
		add	HL,BC
		ld	A,(HL)
		pop	HL
		pop	BC
		or	A,A
		scf
		ret

1$:		pop	HL
		pop	BC
		xor	A,A
		ret		

setXY::		push	AF
		call	checkXY
		jr	NC,1$

		ld	H,0
		ld	L,E		;Y
		add	HL,HL
		add	HL,HL
		add	HL,HL
		add	HL,HL
		add	HL,HL
		add	HL,HL
		ld	B,H
		ld	C,L
		call	destbank
		add	HL,BC
		ld	C,D		;X
		ld	B,0
		add	HL,BC
		pop	AF
		ld	(HL),A
		scf
		ret

1$:		pop	AF
		xor	A,A
		ret		

div:		; H=A/L, corrupts A
		ld	H,-1
1$:		inc	H
		sub	A,L
		jr	NC,1$
		ret
		
divHL:		; return HL/A
		ld	C,A
		xor	A,A		; clear carry and get 0
		ld	B,A
1$:		sbc	HL,BC
		inc	A
		jr	NC, 1$
		dec	A
		ret


srcbank:	ld	A,(flip)
		or	A,A
		jr	NZ,1$
		ld	HL,bank1
		ret	
1$:		ld	HL,bank2
		ret

destbank:	ld	A,(flip)
		or	A,A
		jr	NZ,1$
		ld	HL,bank2
		ret	
1$:		ld	HL,bank1
		ret
		
		.macro	RGB,n,r,g,b
		.db	(n << 4)|r
		.db	(g << 4)|b
		.endm

palette:	RGB	0,0,0,0
		RGB	1,4,0,0
		RGB	2,6,0,0
		RGB	3,7,0,0
		RGB	4,8,0,0
		RGB	5,10,0,0
		RGB	6,12,0,0
		RGB	7,13,4,0
		RGB	8,14,8,0
		RGB	9,15,10,0
		RGB	10,15,11,0
		RGB	11,15,12,0
		RGB	12,15,13,0
		RGB	13,15,14,0
		RGB	14,15,15,0
		RGB	15,15,15,8
		

; from https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Random

; 16-bit xorshift pseudorandom number generator by John Metcalf
; 20 bytes, 86 cycles (excluding ret)

; returns   bc = pseudorandom number
; corrupts   a

; generates 16-bit pseudorandom numbers with a period of 65535
; using the xorshift method:

; bc ^= bc << 7
; bc ^= bc >> 9
; bc ^= bc << 8

; some alternative shift triplets which also perform well are:
; 6, 7, 13; 7, 9, 13; 9, 7, 13.


xrnd:
  ld bc,1       ; seed must not be 0

  ld a,b
  rra
  ld a,c
  rra
  xor b
  ld b,a
  ld a,c
  rra
  ld a,b
  rra
  xor c
  ld c,a
  xor b
  ld b,a

  ld (xrnd+1),bc

  ret

CCC	= 1
CCCA    = 0
coltab:
	.db	0
	.rept	Q-2
	.db	(CCC & 1) | ((CCC & 1)<<1) | ((CCC & 2) << 1) | ((CCC & 2)<<2) | ((CCC & 4) << 2) | ((CCC & 4)<<3) | ((CCC & 8) << 3) | ((CCC & 8)<<4)

CCCA = CCCA + 13
	.if CCCA / Q
		CCCA = CCCA - Q
		CCC = CCC + 1
	.endif
	.endm
	.db	0xFF
	.db	0xFF
	.db	0xFF
	.db	0xFF
	.db	0xFF
	.db	0xFF

flip:	.rmb 1
sav:	.rmb 1

char_rw_ctr:	.rmb 1
char_col_ctr:	.rmb 1

		.area _DATA(ABS,CON)

bank1:	.rmb	SZ*SZ
bank2:	.rmb	SZ*SZ

		.end