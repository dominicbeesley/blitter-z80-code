
		.globl	DEBUG_TODO
		.globl	DEBUG_PRINT_HEX_A

		.macro	TODO	message
		call	DEBUG_TODO
		.asciz	/message/
		rst	8
		.endm

		.macro DEBUG_HEX_A
		call	DEBUG_PRINT_HEX_A
		.endm