			.include "../../includes/hardware.inc"

		.ifndef Z180_INTERNAL_BASE
Z180_INTERNAL_BASE = 0 ; override externally if required
		.endif

CNTLA0	= Z180_INTERNAL_BASE + 0x00	; ASCI control A 		ch.0 
CNTLA1	= Z180_INTERNAL_BASE + 0x01	; ASCI control A 		ch.1 
CNTLB0	= Z180_INTERNAL_BASE + 0x02	; ASCI control B 		ch.0 
CNTLB1	= Z180_INTERNAL_BASE + 0x03	; ASCI control B 		ch.1 
STAT0	= Z180_INTERNAL_BASE + 0x04	; ASCI status    		ch.0 
STAT1	= Z180_INTERNAL_BASE + 0x05	; ASCI status    		ch.1 
TDR0	= Z180_INTERNAL_BASE + 0x06	; ASCI transmit data 		ch.0 
TDR1	= Z180_INTERNAL_BASE + 0x07	; ASCI transmit data 		ch.1 
RDR0	= Z180_INTERNAL_BASE + 0x08	; ASCI receive data	  	ch.0 
RDR1	= Z180_INTERNAL_BASE + 0x09	; ASCI receive data	  	ch.1 
CNTR	= Z180_INTERNAL_BASE + 0x0A	; CSI/0 control  
TRDR	= Z180_INTERNAL_BASE + 0x0B	; CSI/0 transmit/receive data

TMDR0L	= Z180_INTERNAL_BASE + 0x0C	; Timer data			ch.0L
TMDR0H	= Z180_INTERNAL_BASE + 0x0D	; Timer data			ch.0H
RLDR0L	= Z180_INTERNAL_BASE + 0x0E	; Timer reload			ch.0L
RLDR0H	= Z180_INTERNAL_BASE + 0x0F	; Timer reload			ch.0H
TCR	= Z180_INTERNAL_BASE + 0x10	; Timer control 

ASEXT0	= Z180_INTERNAL_BASE + 0x12	; ASCI extension ctl		ch.0
ASEXT1	= Z180_INTERNAL_BASE + 0x13	; ASCI extension ctl		ch.1

TMDR1L	= Z180_INTERNAL_BASE + 0x14	; Timer data			ch.1L
TMDR1H	= Z180_INTERNAL_BASE + 0x15	; Timer data			ch.1H
RLDR1L	= Z180_INTERNAL_BASE + 0x16	; Timer reload			ch.1L
RLDR1H	= Z180_INTERNAL_BASE + 0x17	; Timer reload			ch.1H
FRC	= Z180_INTERNAL_BASE + 0x18	; Timer free run counter

TC0L	= Z180_INTERNAL_BASE + 0x1A	; BRG time constant L		ch.0L
TC0H	= Z180_INTERNAL_BASE + 0x1B	; BRG time constant H		ch.0H
TC1L	= Z180_INTERNAL_BASE + 0x1C	; BRG time constant L		ch.1H
TC1H	= Z180_INTERNAL_BASE + 0x1D	; BRG time constant H		ch.1H

CMR	= Z180_INTERNAL_BASE + 0x1E	; Clock multiplier
CCR	= Z180_INTERNAL_BASE + 0x1F	; CPU Control

SAR0L  	= Z180_INTERNAL_BASE + 0x20	; DMA source address 		ch.0L
SAR0H  	= Z180_INTERNAL_BASE + 0x21	; DMA source address 		ch.0H
SAR0B  	= Z180_INTERNAL_BASE + 0x22	; DMA source address 		ch.0B
DAR0L  	= Z180_INTERNAL_BASE + 0x23	; DMA dest address   		ch.0L
DAR0H  	= Z180_INTERNAL_BASE + 0x24	; DMA dest address   		ch.0H
DAR0B  	= Z180_INTERNAL_BASE + 0x25	; DMA dest address   		ch.0B
BCR0L  	= Z180_INTERNAL_BASE + 0x26	; DMA byte count     		ch.0L
BCR0H  	= Z180_INTERNAL_BASE + 0x27	; DMA byte count     		ch.0H
MAR1L  	= Z180_INTERNAL_BASE + 0x28	; DMA memory address 		ch.1L
MAR1H  	= Z180_INTERNAL_BASE + 0x29	; DMA memory address 		ch.1H
MAR1B  	= Z180_INTERNAL_BASE + 0x2A	; DMA memory address 		ch.1B
IAR1L  	= Z180_INTERNAL_BASE + 0x2B	; DMA I/O address    		ch.1L
IAR1H  	= Z180_INTERNAL_BASE + 0x2C	; DMA I/O address    		ch.1H
BCR1L  	= Z180_INTERNAL_BASE + 0x2E	; DMA byte count     		ch.1L
BCR1H  	= Z180_INTERNAL_BASE + 0x2F	; DMA byte count     		ch.1H
DSTAT  	= Z180_INTERNAL_BASE + 0x30	; DMA status
DMODE  	= Z180_INTERNAL_BASE + 0x31	; DMA mode
DCNTL  	= Z180_INTERNAL_BASE + 0x32	; DMA/WAIT control

IL	= Z180_INTERNAL_BASE + 0x33	; Interrupt vector low
ITC	= Z180_INTERNAL_BASE + 0x34	; INT/TRAP control

RCR	= Z180_INTERNAL_BASE + 0x36	; Refresh control

CBR	= Z180_INTERNAL_BASE + 0x38 	; MMU common base
BBR	= Z180_INTERNAL_BASE + 0x39 	; MMU bank base
CBAR	= Z180_INTERNAL_BASE + 0x3A 	; MMU common/bank area
OMCR	= Z180_INTERNAL_BASE + 0x3E   	; Operation mode control

ICR	= 0x3F 				; I/O base control - does not move