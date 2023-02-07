
		.globl	DEBUG_PRINTSTR

		.macro	TODO	message
		call	DEBUG_PRINTSTR
		.asciz	/message/
		rst	8
		.endm