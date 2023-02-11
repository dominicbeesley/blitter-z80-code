
		.globl	DEBUG_TODO
		.globl	DEBUG_PRINT_HEX_A
		.globl	DEBUG_PRT_A

		.macro	TODO	message
		call	DEBUG_TODO
		.asciz	/message/
		rst	8
		.endm

		.macro DEBUG_HEX_A
		call	DEBUG_PRINT_HEX_A
		.endm

		.macro DEBUG_PRINT_A
		call	DEBUG_PRT_A
		.endm