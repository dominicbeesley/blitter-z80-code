		.area	CODE_BOOT (CON, REL)

		.hd64

		.include	"../../includes/hardware.inc"
		.include	"../includes/hardware-z180.inc"

		.globl	mos_handle_res

;===========================================================================
; The blitter forces all memory reads to come from F FFxx at boot time which
; will map to the "MOS" ROM i.e. here
; we need to quickly initialise the NMI handler and the disable boot mode
; and jump to the real MOS address i.e. F C000 - F F000
; 
; We can be sure this is a "real" reset i.e. not a RST0 or TRAP 
;

RESET_0_0000:		  
		di

		; setup a catch-all NMI to just do RETN - a real one will be
		; set up in the main code
		ld	bc,0x45ED
		ld	(0x66),bc

; at this point the CPU thinks it is running at 0 0000 do a jump to get the PC
; correct
		jp	RESET_0_FFxx

RESET_0_FFxx:

;===========================================================================
; we now need to set the MMU to how we want it:
; on the z180 we need to map the MOS ROM into the top bank

; first set banking boundaries, for this test we'll map: 
; ChipRAM			0..2FFF (Common Area 0)
; SysRAM/screen			3000..C000 (Banked Area)
; the MOS ROM at		C000 (Common Area 1)

		ld	a,0xC3
		out0	(Z180_CBAR),a

; and we'll map CAR0 => 0 0000
;		BAR  => F xxxx
;		CAR1 => F xxxx

		ld	a,0xF0
		out0	(Z180_BBR),a

		ld	a,0xF0
		out0	(Z180_CBR),a

		im	2
		ld	a,0
		ld	i,a

		ld	a,0x40
		out0	(Z180_IL),a


; now disable Blitter's "boot mode" and start executing from MOS rom as mapped 
; above

; we are now running in ROM and can disable the boot mapping by writing to FCFF

		ld	a,JIM_DEVNO_BLITTER
		ld	bc,fred_JIM_DEVNO
		out	(c),a

		jp	mos_handle_res


