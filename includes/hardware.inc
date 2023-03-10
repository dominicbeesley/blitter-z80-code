
SHEILA				= 0hFE00

sheila_MEM_CTL			= 0hFE31
BITS_MEM_CTL_SWMOS		= 0h01
BITS_MEM_CTL_SWMOS_DEBUG	= 0h04
BITS_MEM_CTL_SWMOS_DEBUG_EN	= 0h08
BITS_MEM_CTL_FLEX		= 0h10
BITS_MEM_CTL_SWMOS_DEBUG_5C	= 0h40
BITS_MEM_CTL_SWMOS_DEBUG_ACT	= 0h80
sheila_MEM_DEBUG_SAVE		= 0hFE32

sheila_MEM_TURBO2		= 0hFE36
BITS_MEM_TURBO2_THROTTLE	= 0h80

sheila_MEM_LOMEMTURBO		= 0hFE37


sheila_ACIA_CTL		=	0hFE08
ACIA_RDRF		=	0h01
ACIA_TDRE		=	0h02

sheila_ACIA_DATA	=	0hFE09
sheila_SERIAL_ULA	=	0hFE10


; BLTCON is written in two passes with top bit clear i.e. not BLTCON_ACT_ACT
; the exec flags are first set
; then with top bit set the active flag, bit mode and cell flags are set
; BLTCON/ACT byte flags

BLITCON_ACT_ACT			=	0h80		; always set when setting act constants/execing  
BLITCON_ACT_CELL		=	0h40		; cell addressing used i.e. move one byte left adds 8 to address
							; moving one line down either adds 1 byte or STRIDE depending on whether 
							; line crosses an 8 line boundary
BLITCON_ACT_MODE_1BBP		=	0h00		; 1 bit per pixel mapping 2 colours
BLITCON_ACT_MODE_2BBP		=	0h10		; 2 bit per pixel mapping 4 colours
BLITCON_ACT_MODE_4BBP		=	0h20		; 4 bit per pixel mapping 16 colours
BLITCON_ACT_MODE_8BBP		=	0h30		; 8 bit per pixel mapping 256 colours
BLITCON_ACT_LINE		=	0h08		; draw a line
BLITCON_ACT_COLLISION		=	0h04		; gets reset for any non-zero D data (even in EXEC_D is clear)
BLITCON_ACT_WRAP		=	0h02		; wrap C/D addresses to fit between min/max

BLITCON_LINE_MAJOR_UPnRIGHT	=	0h10		; line draw major axis is up
BLITCON_LINE_MINOR_CCW		=	0h20		; minor axis is CCW to MAJOR i.e.:
							;  - left when maj up, up when maj right
							;  - otherwise, right when maj up, down when maj right

BLITCON_EXEC_A			=	0h01
BLITCON_EXEC_B			=	0h02
BLITCON_EXEC_C			=	0h04
BLITCON_EXEC_D			=	0h08
BLITCON_EXEC_E			=	0h10

AERIS_CTL_ACT			=	0h80

; DMA controller control flags
DMACTL_ACT			=	0h80		; always set to initiate a transfer

DMACTL_EXTEND			=	0h20		; use extended functions from control2
DMACTL_HALT			=	0h10		; halt cpu during transfer
DMACTL_STEP_DEST_NONE		=	0h00		; do not step destination address
DMACTL_STEP_DEST_UP		=	0h04		; step destination up after transfer
DMACTL_STEP_DEST_DOWN		=	0h08		; step destination down after transfer
DMACTL_STEP_DEST_NOP		=	0h0C		; skip writes, do not increment address
DMACTL_STEP_SRC_NONE		=	0h00		; do not step destination address
DMACTL_STEP_SRC_UP		=	0h01		; step destination up after transfer
DMACTL_STEP_SRC_DOWN		=	0h02		; step destination down after transfer
DMACTL_STEP_SRC_NOP		=	0h03		; skip reads, do not incrememnt address

DMACTL2_IF			=	0h80		; interrupt occurred
DMACTL2_IE			=	0h02		; interrupt enable, interrupt after transfer
DMACTL2_SZ_BYTE			=	0h00
DMACTL2_SZ_WORD			=	0h04
DMACTL2_SZ_WORDSWAPDEST		=	0h08
DMACTL2_SZ_WORDSWAPSRC		=	0h0C
DMACTL2_PAUSE			=	0h01

; Sound Status / control bits
SND_CTL_ACT			=	0h80
SND_CTL_REPEAT			=	0h01


DMAC_BLITCON_offs		=	0
DMAC_FUNCGEN_offs		=	0h1
DMAC_WIDTH_offs			=	0h2
DMAC_HEIGHT_offs		=	0h3
DMAC_SHIFT_offs			=	0h4
DMAC_MASK_FIRST_offs		=	0h5
DMAC_MASK_LAST_offs		=	0h6
DMAC_DATA_A_offs		=	0h7
DMAC_ADDR_A_offs		=	0h8
DMAC_DATA_B_offs		=	0hB
DMAC_ADDR_B_offs		=	0hC
DMAC_ADDR_C_offs		=	0hF
DMAC_ADDR_D_offs		=	0h12
DMAC_ADDR_E_offs		=	0h15
DMAC_STRIDE_A_offs		=	0h18
DMAC_STRIDE_B_offs		=	0h1A
DMAC_STRIDE_C_offs		=	0h1C
DMAC_STRIDE_D_offs		=	0h1E

DMAC_BLIT_EXT_offs		=	0h40
DMAC_ADDR_D_MIN_offs		=	DMAC_BLIT_EXT_offs
DMAC_ADDR_D_MAX_offs		=	DMAC_BLIT_EXT_offs+3



DMAC_SND_DATA_offs		=	0h20
DMAC_SND_ADDR_offs		=	0h21
DMAC_SND_PERIOD_offs		=	0h24
DMAC_SND_LEN_offs		=	0h26
DMAC_SND_STATUS_offs		=	0h28
DMAC_SND_VOL_offs		=	0h29
DMAC_SND_REPOFF_offs		=	0h2A
DMAC_SND_PEAK_offs		=	0h2C

DMAC_SND_MA_VOL_offs		=	0h2E
DMAC_SND_SEL_offs		=	0h2F

DMAC_DMA_CTL_offs		=	0h30
DMAC_DMA_SRC_ADDR_offs		=	0h31
DMAC_DMA_DEST_ADDR_offs		=	0h34
DMAC_DMA_COUNT_offs		=	0h37
DMAC_DMA_DATA_offs		=	0h39
DMAC_DMA_CTL2_offs		=	0h3A
DMAC_DMA_PAUSE_VAL_offs		=	0h3B
DMAC_DMA_SEL_offs		=	0h3F



DMAC_AERIS_CTL_offs		=	0h50
DMAC_AERIS_PROGBASE_offs	=	0h51


DMAC_I2C_offs		=	0h70

jim_page_DMAC			=	0hFEFC

jim_page_VERSION		=	0hFC00

jim_offs_VERSION_API_level	=	0h80
jim_offs_VERSION_Board_level	=	0h81
jim_offs_VERSION_API_sublevel	=	0h82
jim_offs_VERSION_cfg_bits	=	0h84
jim_offs_VERSION_cap_bits	=	0h88

; Mk.2/1 option switches - note in API level >1 the sense of these is reversed!
BLT_MK2_CFG0_T65		=	0h01
BLT_MK2_CFG0_CPU_6502A_2M	=	0h00
BLT_MK2_CFG0_CPU_65C02_4M	=	0h02
BLT_MK2_CFG0_CPU_65C02_8M	=	0h04
BLT_MK2_CFG0_CPU_6x09_2M	=	0h08
BLT_MK2_CFG0_CPU_6309_4M	=	0h0A
BLT_MK2_CFG0_CPU_Z80_8M		=	0h0C
BLT_MK2_CFG0_CPU_68008		=	0h0E
BLT_MK2_CFG0_SWROMX		=	0h10
BLT_MK2_CFG0_BUGBTN		=	0h80

BLT_MK2_CFG1_MEMI		=	0h01
BLT_MK2_CFG1_BUGOUT		=	0h02

; Mk.3 switches from PORTF/G
BLT_MK3_CFG0_T65		=	0h08
BLT_MK3_CFG0_SWROMX		=	0h10
BLT_MK3_CFG0_MEMI		=	0h40



jim_DMAC			=	0hFD60
jim_DMAC_BLITCON		=	jim_DMAC + DMAC_BLITCON_offs
jim_DMAC_FUNCGEN		=	jim_DMAC + DMAC_FUNCGEN_offs
jim_DMAC_WIDTH			=	jim_DMAC + DMAC_WIDTH_offs
jim_DMAC_HEIGHT			=	jim_DMAC + DMAC_HEIGHT_offs
jim_DMAC_SHIFT			=	jim_DMAC + DMAC_SHIFT_offs
jim_DMAC_MASK_FIRST		=	jim_DMAC + DMAC_MASK_FIRST_offs
jim_DMAC_MASK_LAST		=	jim_DMAC + DMAC_MASK_LAST_offs
jim_DMAC_DATA_A			=	jim_DMAC + DMAC_DATA_A_offs
jim_DMAC_ADDR_A			=	jim_DMAC + DMAC_ADDR_A_offs
jim_DMAC_DATA_B			=	jim_DMAC + DMAC_DATA_B_offs
jim_DMAC_ADDR_B			=	jim_DMAC + DMAC_ADDR_B_offs
jim_DMAC_ADDR_C			=	jim_DMAC + DMAC_ADDR_C_offs
jim_DMAC_ADDR_D			=	jim_DMAC + DMAC_ADDR_D_offs
jim_DMAC_ADDR_E			=	jim_DMAC + DMAC_ADDR_E_offs
jim_DMAC_STRIDE_A		=	jim_DMAC + DMAC_STRIDE_A_offs
jim_DMAC_STRIDE_B		=	jim_DMAC + DMAC_STRIDE_B_offs
jim_DMAC_STRIDE_C		=	jim_DMAC + DMAC_STRIDE_C_offs
jim_DMAC_STRIDE_D		=	jim_DMAC + DMAC_STRIDE_D_offs
jim_DMAC_ADDR_D_MIN		=	jim_DMAC + DMAC_ADDR_D_MIN_offs
jim_DMAC_ADDR_D_MAX		=	jim_DMAC + DMAC_ADDR_D_MAX_offs




jim_DMAC_SND_DATA		= 	jim_DMAC + DMAC_SND_DATA_offs
jim_DMAC_SND_ADDR		= 	jim_DMAC + DMAC_SND_ADDR_offs
jim_DMAC_SND_PERIOD		= 	jim_DMAC + DMAC_SND_PERIOD_offs
jim_DMAC_SND_LEN		= 	jim_DMAC + DMAC_SND_LEN_offs
jim_DMAC_SND_STATUS		= 	jim_DMAC + DMAC_SND_STATUS_offs
jim_DMAC_SND_VOL		= 	jim_DMAC + DMAC_SND_VOL_offs
jim_DMAC_SND_REPOFF		= 	jim_DMAC + DMAC_SND_REPOFF_offs
jim_DMAC_SND_PEAK		= 	jim_DMAC + DMAC_SND_PEAK_offs

jim_DMAC_SND_SEL		= 	jim_DMAC + DMAC_SND_SEL_offs
jim_DMAC_SND_MA_VOL		= 	jim_DMAC + DMAC_SND_MA_VOL_offs

jim_DMAC_DMA_CTL		=	jim_DMAC + DMAC_DMA_CTL_offs
jim_DMAC_DMA_SRC_ADDR		=	jim_DMAC + DMAC_DMA_SRC_ADDR_offs
jim_DMAC_DMA_DEST_ADDR		=	jim_DMAC + DMAC_DMA_DEST_ADDR_offs
jim_DMAC_DMA_COUNT		=	jim_DMAC + DMAC_DMA_COUNT_offs
jim_DMAC_DMA_DATA		=	jim_DMAC + DMAC_DMA_DATA_offs
jim_DMAC_DMA_CTL2		=	jim_DMAC + DMAC_DMA_CTL2_offs
jim_DMAC_DMA_PAUSE_VAL		=	jim_DMAC + DMAC_DMA_PAUSE_VAL_offs
jim_DMAC_DMA_SEL		=	jim_DMAC + DMAC_DMA_SEL_offs

jim_DMAC_AERIS_CTL		=	jim_DMAC + DMAC_AERIS_CTL_offs
jim_DMAC_AERIS_PROGBASE		=	jim_DMAC + DMAC_AERIS_PROGBASE_offs


jim_I2C_BASE			= 	jim_DMAC + DMAC_I2C_offs
jim_I2C_STAT			= 	jim_I2C_BASE
jim_I2C_DATA			= 	jim_I2C_BASE + 1

I2C_BUSY	= 0h80
I2C_NACK	= 0h40
I2C_STOP	= 0h04
I2C_START	= 0h02
I2C_RNW		= 0h01

sheila_sim_control		=	0hFEFF
sheila_reg_debug		=	0hFEFF

fred_JIM_PAGE_HI2		=	0hFCFC		; note ignored Blitter/Paula
fred_JIM_PAGE_HI		=	0hFCFD
fred_JIM_PAGE_LO		=	0hFCFE
fred_JIM_DEVNO			=	0hFCFF

jim_base			=	0hFD00
JIM				=	jim_base

SHEILA_ROMCTL_SWR	=	0hFE30
SHEILA_ROMCTL_MOS	=	0hFE31

SHEILA_ROMCTL_SWR_ELK	=	0hFE05


ROMCTL_BITS_FLEX	=	0h10

ROMCTL_MOS_JIMEN	=	0h02
ROMCTL_MOS_SWMOS	=	0h01

sheila_CRTC_reg		=	0hFE00
sheila_CRTC_rw		=	0hFE01
	
sheila_VIDULA_ctl	=	0hFE20
sheila_VIDULA_pal	=	0hFE21
sheila_NULA_ctlaux	=	0hFE22
sheila_NULA_palaux	=	0hFE23

SHEILA_DEBUG		=	0hFEFF


;***********************************************************************
;* System VIA                                                          *
;***********************************************************************
sheila_SYSVIA_orb			= 0hFE40
sheila_SYSVIA_ora			= 0hFE41
sheila_SYSVIA_ddrb			= 0hFE42
sheila_SYSVIA_ddra			= 0hFE43
sheila_SYSVIA_t1cl			= 0hFE44
sheila_SYSVIA_t1ch			= 0hFE45
sheila_SYSVIA_t1ll			= 0hFE46
sheila_SYSVIA_t1lh			= 0hFE47
sheila_SYSVIA_t2cl			= 0hFE48
sheila_SYSVIA_t2ch			= 0hFE49
sheila_SYSVIA_sr			= 0hFE4A
sheila_SYSVIA_acr			= 0hFE4B
sheila_SYSVIA_pcr			= 0hFE4C
sheila_SYSVIA_ifr			= 0hFE4D
sheila_SYSVIA_ier			= 0hFE4E
sheila_SYSVIA_ora_nh			= 0hFE4F

;***********************************************************************
;* SYS VIA - slow data bus RTC                                         *
;***********************************************************************

	.IFDEF MACH_CHIPKIT
BITS_RTC_AS_ON	=		0h88			; PB7
BITS_RTC_AS_OFF =		0h08			;
BITS_RTC_CS	=		0h04			; latch
BITS_RTC_DS	=		0h02			; latch
BITS_RTC_RnW	=		0h01			; latch
BITS_LAT_ON	=		0h08			; latch

RTC_REG_SECONDS	=		0h0
RTC_REG_MINUTES	=		0h2
RTC_REG_HOURS	=		0h4
RTC_REG_DOW	=		0h6
RTC_REG_DAY	=		0h7
RTC_REG_MONTH	=		0h8
RTC_REG_YEAR	=		0h9
	.ENDIF


;***********************************************************************
;* User VIA                                                            *
;***********************************************************************
sheila_USRVIA_orb			= 0hFE60
sheila_USRVIA_ora			= 0hFE61
sheila_USRVIA_ddrb			= 0hFE62
sheila_USRVIA_ddra			= 0hFE63
sheila_USRVIA_t1cl			= 0hFE64
sheila_USRVIA_t1ch			= 0hFE65
sheila_USRVIA_t1ll			= 0hFE66
sheila_USRVIA_t1lh			= 0hFE67
sheila_USRVIA_t2cl			= 0hFE68
sheila_USRVIA_t2ch			= 0hFE69
sheila_USRVIA_sr			= 0hFE6A
sheila_USRVIA_acr			= 0hFE6B
sheila_USRVIA_pcr			= 0hFE6C
sheila_USRVIA_ifr			= 0hFE6D
sheila_USRVIA_ier			= 0hFE6E
sheila_USRVIA_ora_nh			= 0hFE6F

;***********************************************************************
;*  VIA constants                                                      *
;***********************************************************************

VIA_IFR_BIT_ANY				= 0h80
VIA_IFR_BIT_T1				= 0h40
VIA_IFR_BIT_T2				= 0h20
VIA_IFR_BIT_CB1				= 0h10
VIA_IFR_BIT_CB2				= 0h08
VIA_IFR_BIT_SR				= 0h04
VIA_IFR_BIT_CA1				= 0h02
VIA_IFR_BIT_CA2				= 0h01

VIA_ACR_SHIFTMODE_0			= 0h00
VIA_ACR_SHIFTMODE_1			= 0h04
VIA_ACR_SHIFTMODE_2			= 0h08
VIA_ACR_SHIFTMODE_3			= 0h0C
VIA_ACR_SHIFTMODE_4			= 0h10
VIA_ACR_SHIFTMODE_5			= 0h14
VIA_ACR_SHIFTMODE_6			= 0h18
VIA_ACR_SHIFTMODE_7			= 0h1C

VIA_ACR_T1_MASK				= 0hC0
VIA_ACR_T1_CONT				= 0h40


;***********************************************************************
;* BBC B/B+ WD177x                                                     *
;***********************************************************************

sheila_1770_dcontrol			=	0hFE80
sheila_1770_wdc_cmd			=	0hFE84
sheila_1770_wdc_trk			=	0hFE85
sheila_1770_wdc_sec			=	0hFE86
sheila_1770_wdc_dat			=	0hFE87

W1770_DRVSEL_BIT_SEL0			= 0h01
W1770_DRVSEL_BIT_SEL1			= 0h02
W1770_DRVSEL_BIT_SIDE1			= 0h04
W1770_DRVSEL_BIT_nDDEN			= 0h08
W1770_DRVSEL_BIT_nMR			= 0h20


;***********************************************************************
;* NEW API JIM DEVICE NOs                                              *
;***********************************************************************


JIM_DEVNO_HOG1MPAULA			= 0hD0
JIM_DEVNO_BLITTER			= 0hD1
