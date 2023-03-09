
; This contains jumps to call the OS through the usual MOS entry points

		.globl	OSWRCH_ENTER

		.area CODE_SW_VEC(ABS)
		.org 0x63				; offset into vector block


OSASCI::	cp   	0x0D
		jr	NZ,OSWRCH
OSNEWL::	ld   	A,0x0A
		call 	OSWRCH
OSWRCR::	ld   	A,0x0D
OSWRCH::	jp  	OSWRCH_ENTER
