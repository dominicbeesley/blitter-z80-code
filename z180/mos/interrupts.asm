		.list(me,meb)

		.hd64
		.include "config.inc"
		.include	"../../includes/hardware.inc"
		.include	"../includes/hardware-z180.inc"

		.area	MOS_CODE (REL, CON)


int0_handle::
		ei
		reti


		.end