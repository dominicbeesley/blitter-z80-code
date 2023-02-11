
; This contains jumps to call the OS through the usual MOS entry points

	
		.area CODE_SW_VEC(ABS)
		.org 0xFFE3

		.globl	OSWRCH_ENTER

OSASCI::	cp   	0x0D
		jr	NZ,OSWRCH
OSNEWL::	ld   	A,0x0A
		call 	OSWRCH
OSWRCR::	ld   	A,0x0D
OSWRCH::	jp  	OSWRCH_ENTER
