			;.include "../../includes/hardware.inc"

		.ifndef Z180_INTERNAL_BASE
Z180_INTERNAL_BASE = 0 ; override externally if required
		.endif

Z180_CNTLA0	= Z180_INTERNAL_BASE + 0x00	; ASCI control A 		ch.0 
Z180_CNTLA1	= Z180_INTERNAL_BASE + 0x01	; ASCI control A 		ch.1 
Z180_CNTLB0	= Z180_INTERNAL_BASE + 0x02	; ASCI control B 		ch.0 
Z180_CNTLB1	= Z180_INTERNAL_BASE + 0x03	; ASCI control B 		ch.1 
Z180_STAT0	= Z180_INTERNAL_BASE + 0x04	; ASCI status    		ch.0 
Z180_STAT1	= Z180_INTERNAL_BASE + 0x05	; ASCI status    		ch.1 

Z180bit_STATx_RDRF		= 0
Z180bit_STATx_OVRN		= 1
Z180bit_STATx_PE		= 2
Z180bit_STATx_FE		= 3
Z180bit_STATx_RIE		= 4
Z180bit_STATx_TDRE		= 6
Z180bit_STATx_TIE		= 7

Z180bit_STAT0_DCD0		= 5
Z180bit_STAT1_CTS1E		= 5

Z180_TDR0	= Z180_INTERNAL_BASE + 0x06	; ASCI transmit data 		ch.0 
Z180_TDR1	= Z180_INTERNAL_BASE + 0x07	; ASCI transmit data 		ch.1 
Z180_RDR0	= Z180_INTERNAL_BASE + 0x08	; ASCI receive data	  	ch.0 
Z180_RDR1	= Z180_INTERNAL_BASE + 0x09	; ASCI receive data	  	ch.1 
Z180_CNTR	= Z180_INTERNAL_BASE + 0x0A	; CSI/0 control  
Z180_TRDR	= Z180_INTERNAL_BASE + 0x0B	; CSI/0 transmit/receive data
Z180_TMDR0L	= Z180_INTERNAL_BASE + 0x0C	; Timer data			ch.0L
Z180_TMDR0H	= Z180_INTERNAL_BASE + 0x0D	; Timer data			ch.0H
Z180_RLDR0L	= Z180_INTERNAL_BASE + 0x0E	; Timer reload			ch.0L
Z180_RLDR0H	= Z180_INTERNAL_BASE + 0x0F	; Timer reload			ch.0H
Z180_TCR	= Z180_INTERNAL_BASE + 0x10	; Timer control 
Z180_ASEXT0	= Z180_INTERNAL_BASE + 0x12	; ASCI extension ctl		ch.0
Z180_ASEXT1	= Z180_INTERNAL_BASE + 0x13	; ASCI extension ctl		ch.1
Z180_TMDR1L	= Z180_INTERNAL_BASE + 0x14	; Timer data			ch.1L
Z180_TMDR1H	= Z180_INTERNAL_BASE + 0x15	; Timer data			ch.1H
Z180_RLDR1L	= Z180_INTERNAL_BASE + 0x16	; Timer reload			ch.1L
Z180_RLDR1H	= Z180_INTERNAL_BASE + 0x17	; Timer reload			ch.1H
Z180_FRC	= Z180_INTERNAL_BASE + 0x18	; Timer free run counter
Z180_TC0L	= Z180_INTERNAL_BASE + 0x1A	; BRG time constant L		ch.0L
Z180_TC0H	= Z180_INTERNAL_BASE + 0x1B	; BRG time constant H		ch.0H
Z180_TC1L	= Z180_INTERNAL_BASE + 0x1C	; BRG time constant L		ch.1H
Z180_TC1H	= Z180_INTERNAL_BASE + 0x1D	; BRG time constant H		ch.1H
Z180_CMR	= Z180_INTERNAL_BASE + 0x1E	; Clock multiplier
Z180_CCR	= Z180_INTERNAL_BASE + 0x1F	; CPU Control
Z180_SAR0L  	= Z180_INTERNAL_BASE + 0x20	; DMA source address 		ch.0L
Z180_SAR0H  	= Z180_INTERNAL_BASE + 0x21	; DMA source address 		ch.0H
Z180_SAR0B  	= Z180_INTERNAL_BASE + 0x22	; DMA source address 		ch.0B
Z180_DAR0L  	= Z180_INTERNAL_BASE + 0x23	; DMA dest address   		ch.0L
Z180_DAR0H  	= Z180_INTERNAL_BASE + 0x24	; DMA dest address   		ch.0H
Z180_DAR0B  	= Z180_INTERNAL_BASE + 0x25	; DMA dest address   		ch.0B
Z180_BCR0L  	= Z180_INTERNAL_BASE + 0x26	; DMA byte count     		ch.0L
Z180_BCR0H  	= Z180_INTERNAL_BASE + 0x27	; DMA byte count     		ch.0H
Z180_MAR1L  	= Z180_INTERNAL_BASE + 0x28	; DMA memory address 		ch.1L
Z180_MAR1H  	= Z180_INTERNAL_BASE + 0x29	; DMA memory address 		ch.1H
Z180_MAR1B  	= Z180_INTERNAL_BASE + 0x2A	; DMA memory address 		ch.1B
Z180_IAR1L  	= Z180_INTERNAL_BASE + 0x2B	; DMA I/O address    		ch.1L
Z180_IAR1H  	= Z180_INTERNAL_BASE + 0x2C	; DMA I/O address    		ch.1H
Z180_BCR1L  	= Z180_INTERNAL_BASE + 0x2E	; DMA byte count     		ch.1L
Z180_BCR1H  	= Z180_INTERNAL_BASE + 0x2F	; DMA byte count     		ch.1H
Z180_DSTAT  	= Z180_INTERNAL_BASE + 0x30	; DMA status
Z180_DMODE  	= Z180_INTERNAL_BASE + 0x31	; DMA mode
Z180_DCNTL  	= Z180_INTERNAL_BASE + 0x32	; DMA/WAIT control
Z180_IL		= Z180_INTERNAL_BASE + 0x33	; Interrupt vector low
Z180_ITC	= Z180_INTERNAL_BASE + 0x34	; INT/TRAP control
Z180_RCR	= Z180_INTERNAL_BASE + 0x36	; Refresh control
Z180_CBR	= Z180_INTERNAL_BASE + 0x38 	; MMU common base
Z180_BBR	= Z180_INTERNAL_BASE + 0x39 	; MMU bank base
Z180_CBAR	= Z180_INTERNAL_BASE + 0x3A 	; MMU common/bank area
Z180_OMCR	= Z180_INTERNAL_BASE + 0x3E   	; Operation mode control
Z180_ICR	= 0x3F 				; I/O base control - does not move