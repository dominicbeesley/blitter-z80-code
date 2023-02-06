
;****** 16 COLOUR MODE BYTE MASK LOOK UP TABLE******

_COL16_MASK_TAB:	
		.db	0b00000000
		.db	0b00010001
		.db	0b00100010
		.db	0b00110011
		.db	0b01000100
		.db	0b01010101
		.db	0b01100110
		.db	0b01110111
		.db	0b10001000
		.db	0b10011001
		.db	0b10101010
		.db	0b10111011
		.db	0b11001100
		.db	0b11011101
		.db	0b11101110
		.db	0b11111111

;****** 4 COLOUR MODE BYTE MASK LOOK UP TABLE******

_COL4_MASK_TAB:	.db	0b00000000
		.db	0b01010101
		.db	0b10101010
		.db	0b11111111

_VDU_TABLE:	.dw	_VDU_0
		.dw	_VDU_1
		.dw	_VDU_2
		.dw	_VDU_3
		.dw	_VDU_4
		.dw	_VDU_5
		.dw	_VDU_6
		.dw	_VDU_7
		.dw	_VDU_8
		.dw	_VDU_9
		.dw	_VDU_10
		.dw	_VDU_11
		.dw	_VDU_12
		.dw	_VDU_13
		.dw	_VDU_14
		.dw	_VDU_15
		.dw	_VDU_16
		.dw	_VDU_17
		.dw	_VDU_18
		.dw	_VDU_19
		.dw	_VDU_20
		.dw	_VDU_21
		.dw	_VDU_22
		.dw	_VDU_23
		.dw	_VDU_24
		.dw	_VDU_25
		.dw	_VDU_26
		.dw	_VDU_27
		.dw	_VDU_28
		.dw	_VDU_29
		.dw	_VDU_30
		.dw	_VDU_31
		.dw	_VDU_127


;****** 640 MULTIPLICATION TABLE  40COL, 80COL MODES  HIBYTE, LOBYTE ******

_MUL640_TABLE:		.dw	640 *  0
			.dw	640 *  1
			.dw	640 *  2
			.dw	640 *  3
			.dw	640 *  4
			.dw	640 *  5
			.dw	640 *  6
			.dw	640 *  7
			.dw	640 *  8
			.dw	640 *  9
			.dw	640 * 10
			.dw	640 * 11
			.dw	640 * 12
			.dw	640 * 13
			.dw	640 * 14
			.dw	640 * 15
			.dw	640 * 16
			.dw	640 * 17
			.dw	640 * 18
			.dw	640 * 19
			.dw	640 * 20
			.dw	640 * 21
			.dw	640 * 22
			.dw	640 * 23
			.dw	640 * 24
			.dw	640 * 25
			.dw	640 * 26
			.dw	640 * 27
			.dw	640 * 28
			.dw	640 * 29
			.dw	640 * 30
			.dw	640 * 31

;****** *40 MULTIPLICATION TABLE  TELETEXT  MODE   HIBYTE, LOBYTE  ******

_MUL40_TABLE:		.dw	40 *  0
			.dw	40 *  1
			.dw	40 *  2
			.dw	40 *  3
			.dw	40 *  4
			.dw	40 *  5
			.dw	40 *  6
			.dw	40 *  7
			.dw	40 *  8
			.dw	40 *  9
			.dw	40 * 10
			.dw	40 * 11
			.dw	40 * 12
			.dw	40 * 13
			.dw	40 * 14
			.dw	40 * 15
			.dw	40 * 16
			.dw	40 * 17
			.dw	40 * 18
			.dw	40 * 19
			.dw	40 * 20
			.dw	40 * 21
			.dw	40 * 22
			.dw	40 * 23
			.dw	40 * 24


;****** TEXT WINDOW -BOTTOM ROW LOOK UP TABLE ******

_TEXT_ROW_TABLE:	.db	0x1f				; MODE 0 - 32 ROWS
			.db	0x1f				; MODE 1 - 32 ROWS
			.db	0x1f				; MODE 2 - 32 ROWS
			.db	0x18				; MODE 3 - 25 ROWS
			.db	0x1f				; MODE 4 - 32 ROWS
			.db	0x1f				; MODE 5 - 32 ROWS
			.db	0x18				; MODE 6 - 25 ROWS
			.db	0x18				; MODE 7 - 25 ROWS


;****** TEXT WINDOW -RIGHT HAND COLUMN LOOK UP TABLE ******

_TEXT_COL_TABLE:	.db	0x4f				; MODE 0 - 80 COLUMNS
			.db	0x27				; MODE 1 - 40 COLUMNS
			.db	0x13				; MODE 2 - 20 COLUMNS
			.db	0x4f				; MODE 3 - 80 COLUMNS
			.db	0x27				; MODE 4 - 40 COLUMNS
			.db	0x13				; MODE 5 - 20 COLUMNS
			.db	0x27				; MODE 6 - 40 COLUMNS
			.db	0x27				; MODE 7 - 40 COLUMNS


;*************************************************************************
;*									 *
;*	 SEVERAL OF THE FOLLOWING TABLES OVERLAP EACH OTHER		 *
;*	 SOME ARE DUAL PURPOSE						 *
;*									 *
;*************************************************************************

;************** VIDEO ULA CONTROL REGISTER SETTINGS ***********************

_ULA_SETTINGS:		.db	0x9c				; 10011100
			.db	0xd8				; 11011000
			.db	0xf4				; 11110100
			.db	0x9c				; 10011100
			.db	0x88				; 10001000
			.db	0xc4				; 11000100
			.db	0x88				; 10001000
			.db	0x4b				; 01001011


;******** NUMBER OF BYTES PER CHARACTER FOR EACH DISPLAY MODE ************

_TXT_BPC_TABLE:		.db	0x08				; 00001000
			.db	0x10				; 00010000
			.db	0x20				; 00100000
			.db	0x08				; 00001000
			.db	0x08				; 00001000
			.db	0x10				; 00010000
			.db	0x08				; 00001000
_TAB_VDU_MASK_R:	.db	0x01				; 00000001
	; _TAB_VDU_MASK_R is used to make a right most pixel mask by taking the
	; number of pixels per byte-1 (7,3,1)*2 as an index (0x01,0x11,0x55)

;******************* MASK TABLE FOR  2 COLOUR MODES **********************

_COL2_MASK_TAB:		.db	0xaa				; 10101010
			.db	0x55				; 01010101


;****************** MASK TABLE FOR  4 COLOUR MODES ***********************

			.db	0x88				; 10001000
			.db	0x44				; 01000100
			.db	0x22				; 00100010
			.db	0x11				; 00010001


;********** MASK TABLE FOR  4 COLOUR MODES FONT FLAG MASK TABLE **********

_LC40D:			.db	0x80				; 10000000
			.db	0x40				; 01000000
			.db	0x20				; 00100000
			.db	0x10				; 00010000
			.db	0x08				; 00001000
			.db	0x04				; 00000100
			.db	0x02				; 00000010  -  NEXT BYTE IN FOLLOWING TABLE


;********* NUMBER OF TEXT COLOURS -1 FOR EACH MODE ************************

_TBL_MODE_COLOURS:	.db	0x01				; MODE 0 - 2 COLOURS
			.db	0x03				; MODE 1 - 4 COLOURS
			.db	0x0f				; MODE 2 - 16 COLOURS
			.db	0x01				; MODE 3 - 2 COLOURS
			.db	0x01				; MODE 4 - 2 COLOURS
			.db	0x03				; MODE 5 - 4 COLOURS
			.db	0x01				; MODE 6 - 2 COLOURS
_LC41B:			.db	0x00				; MODE 7 - 1 'COLOUR'


;************** GCOL PLOT OPTIONS PROCESSING LOOK UP TABLE ***************

_LC41C:			.db	0xff				; 11111111
_LC41D:			.db	0x00				; 00000000
			.db	0x00				; 00000000
			.db	0xff				; 11111111
_LC420:			.db	0xff				; 11111111
			.db	0xff				; 11111111
			.db	0xff				; 11111111
_LC423:			.db	0x00				; 00000000


;********** 2 COLOUR MODES PARAMETER LOOK UP TABLE WITHIN TABLE **********

			.db	0x00				; 00000000
			.db	0xff				; 11111111


;*************** 4 COLOUR MODES PARAMETER LOOK UP TABLE ******************

			.db	0x00				; 00000000
			.db	0x0f				; 00001111
			.db	0xf0				; 11110000
			.db	0xff				; 11111111


;***************16 COLOUR MODES PARAMETER LOOK UP TABLE ******************

			.db	0x00				; 00000000
			.db	0x03				; 00000011
			.db	0x0c				; 00001100
			.db	0x0f				; 00001111
			.db	0x30				; 00110000
			.db	0x33				; 00110011
			.db	0x3c				; 00111100
			.db	0x3f				; 00111111
			.db	0xc0				; 11000000
			.db	0xc3				; 11000011
			.db	0xcc				; 11001100
			.db	0xcf				; 11001111
			.db	0xf0				; 11110000
			.db	0xf3				; 11110011
			.db	0xfc				; 11111100
			.db	0xff				; 11111111


;********** DISPLAY MODE PIXELS/BYTE-1 TABLE *********************

_TBL_VDU_PIXPB:		.db	0x07				; MODE 0 - 8 PIXELS/BYTE
			.db	0x03				; MODE 1 - 4 PIXELS/BYTE
			.db	0x01				; MODE 2 - 2 PIXELS/BYTE
_LC43D:			.db	0x00				; MODE 3 - 1 PIXEL/BYTE (NON-GRAPHICS)
			.db	0x07				; MODE 4 - 8 PIXELS/BYTE
			.db	0x03				; MODE 5 - 4 PIXELS/BYTE

;********* SCREEN DISPLAY MEMORY TYPE TABLE OVERLAPS ************

; _TAB_MAP_TYPE - indexed by mode, type of mode (0=20K, 1=16K, 2=10k, 3=8K, 4=1K)
_TAB_MAP_TYPE:		.db	0x00				; MODE 6 - 1 PIXEL/BYTE	 //  MODE 0 - TYPE 0

;***** SOUND PITCH OFFSET BY CHANNEL TABLE WITHIN TABLE **********

			.db	0x00				; MODE 7 - 1 PIXEL/BYTE	 //  MODE 1 - TYPE 0  //  CHANNEL 0
			.db	0x00				; //  MODE 2 - TYPE 0  //  CHANNEL 1
			.db	0x01				; //  MODE 3 - TYPE 1  //  CHANNEL 2
			.db	0x02				; //  MODE 4 - TYPE 2  //  CHANNEL 3

;**** REST OF DISPLAY MEMORY TYPE TABLE ****

			.db	0x02				; //  MODE 5 - TYPE 2
			.db	0x03				; //  MODE 6 - TYPE 3

;***************** VDU SECTION CONTROL NUMBERS ***************************

_LC447:			.db	0x04				; 00000100		  //  MODE 7 - TYPE 4
			.db	0x00				; 00000000
			.db	0x06				; 00000110
			.db	0x02				; 00000010

;*********** CRTC SETUP PARAMETERS TABLE 1 WITHIN TABLE ******************

; value to write to 8 bit latch bit 4 indexed by mode size type (see _TAB_MAP_TYPE)
_TAB_LAT4_MOSZ:		.db	0x0d				; 00001101
			.db	0x05				; 00000101
			.db	0x0d				; 00001101
			.db	0x05				; 00000101

;*********** CRTC SETUP PARAMETERS TABLE 2 WITHIN TABLE *****************

; value to write to 8 bit latch bit 4 indexed by mode size type (see _TAB_MAP_TYPE)
_TAB_LAT5_MOSZ:		.db	0x04				; 00000100
			.db	0x04				; 00000100
			.db	0x0c				; 00001100
			.db	0x0c				; 00001100
			.db	0x04				; 00000100

;;#;;;**** REST OF VDU SECTION CONTROL NUMBERS ****
;;#;;
;;#;;_TAB_CLS_ENTER:		.db	<_VDU_CLEAR_20K
;;#;;			.db	<_VDU_CLEAR_16K
;;#;;			.db	<_VDU_CLEAR_10K
;;#;;			.db	<_VDU_CLEAR_8K
;;#;;			.db	<_VDU_CLEAR_1K


;************** MSB OF MEMORY OCCUPIED BY SCREEN BUFFER	 *****************

_VDU_MEMSZ_TAB:		.db	0x50				; Type 0: &5000 - 20K
			.db	0x40				; Type 1: &4000 - 16K
			.db	0x28				; Type 2: &2800 - 10K
			.db	0x20				; Type 3: &2000 - 8K
			.db	0x04				; Type 4: &0400 - 1K


;************ MSB OF FIRST LOCATION OCCUPIED BY SCREEN BUFFER ************

_VDU_MEMLOC_TAB:	.db	0x30				; Type 0: &3000
			.db	0x40				; Type 1: &4000
			.db	0x58				; Type 2: &5800
			.db	0x60				; Type 3: &6000
			.db	0x7c				; Type 4: &7C00


;***************** NUMBER OF BYTES PER ROW *******************************

_TAB_BPR:		.db	0x28				; 00101000
			.db	0x40				; 01000000
			.db	0x80				; 10000000


;******** ROW MULTIPLIACTION TABLE POINTER TO LOOK UP TABLE **************

;;TODO: not sure of this ;;; _TAB_MULTBL_LKUP:	.db	<_MUL40_TABLE			; 10110101
;;TODO: not sure of this ;;; 			.db	<_MUL640_TABLE			; 01110101
;;TODO: not sure of this ;;; 			.db	<_MUL640_TABLE			; 01110101
;;TODO: not sure of this ;;; 

;********** CRTC CURSOR END REGISTER SETTING LOOK UP TABLE ***************

; CRTC last register to program by mode size
_TAB_CRTCBYMOSZ:	.db	0x0b				; 20k mode 0,1,2
			.db	0x17				; 16k mode 3
			.db	0x23				; 10k mode 4,5
			.db	0x2f				; 8k mode 6
			.db	0x3b				; 1k mode 7


;************* 6845 REGISTERS 0-11 FOR SCREEN TYPE 0 - MODES 0-2 *********

_CRTC_REG_TAB:		.db	0x7f				; 0 Horizontal Total	 =128
			.db	0x50				; 1 Horizontal Displayed =80
			.db	0x62				; 2 Horizontal Sync	 =&62
			.db	0x28				; 3 HSync Width+VSync	 =&28  VSync=2, HSync Width=8
			.db	0x26				; 4 Vertical Total	 =38
			.db	0x00				; 5 Vertial Adjust	 =0
			.db	0x20				; 6 Vertical Displayed	 =32
			.db	0x22				; 7 VSync Position	 =&22
			.db	0x01				; 8 Interlace+Cursor	 =&01  Cursor=0, Display=0, Interlace=Sync
			.db	0x07				; 9 Scan Lines/Character =8
			.db	0x67				; 10 Cursor Start Line	  =&67	Blink=On, Speed=1/32, Line=7
			.db	0x08				; 11 Cursor End Line	  =8


;************* 6845 REGISTERS 0-11 FOR SCREEN TYPE 1 - MODE 3 ************

			.db	0x7f				; 0 Horizontal Total	 =128
			.db	0x50				; 1 Horizontal Displayed =80
			.db	0x62				; 2 Horizontal Sync	 =&62
			.db	0x28				; 3 HSync Width+VSync	 =&28  VSync=2, HSync=8
			.db	0x1e				; 4 Vertical Total	 =30
			.db	0x02				; 5 Vertical Adjust	 =2
			.db	0x19				; 6 Vertical Displayed	 =25
			.db	0x1b				; 7 VSync Position	 =&1B
			.db	0x01				; 8 Interlace+Cursor	 =&01  Cursor=0, Display=0, Interlace=Sync
			.db	0x09				; 9 Scan Lines/Character =10
			.db	0x67				; 10 Cursor Start Line	  =&67	Blink=On, Speed=1/32, Line=7
			.db	0x09				; 11 Cursor End Line	  =9


;************ 6845 REGISTERS 0-11 FOR SCREEN TYPE 2 - MODES 4-5 **********

			.db	0x3f				; 0 Horizontal Total	 =64
			.db	0x28				; 1 Horizontal Displayed =40
			.db	0x31				; 2 Horizontal Sync	 =&31
			.db	0x24				; 3 HSync Width+VSync	 =&24  VSync=2, HSync=4
			.db	0x26				; 4 Vertical Total	 =38
			.db	0x00				; 5 Vertical Adjust	 =0
			.db	0x20				; 6 Vertical Displayed	 =32
			.db	0x22				; 7 VSync Position	 =&22
			.db	0x01				; 8 Interlace+Cursor	 =&01  Cursor=0, Display=0, Interlace=Sync
			.db	0x07				; 9 Scan Lines/Character =8
			.db	0x67				; 10 Cursor Start Line	  =&67	Blink=On, Speed=1/32, Line=7
			.db	0x08				; 11 Cursor End Line	  =8


;********** 6845 REGISTERS 0-11 FOR SCREEN TYPE 3 - MODE 6 ***************

			.db	0x3f				; 0 Horizontal Total	 =64
			.db	0x28				; 1 Horizontal Displayed =40
			.db	0x31				; 2 Horizontal Sync	 =&31
			.db	0x24				; 3 HSync Width+VSync	 =&24  VSync=2, HSync=4
			.db	0x1e				; 4 Vertical Total	 =30
			.db	0x02				; 5 Vertical Adjust	 =0
			.db	0x19				; 6 Vertical Displayed	 =25
			.db	0x1b				; 7 VSync Position	 =&1B
			.db	0x01				; 8 Interlace+Cursor	 =&01  Cursor=0, Display=0, Interlace=Sync
			.db	0x09				; 9 Scan Lines/Character =10
			.db	0x67				; 10 Cursor Start Line	  =&67	Blink=On, Speed=1/32, Line=7
			.db	0x09				; 11 Cursor End Line	  =9


;********* 6845 REGISTERS 0-11 FOR SCREEN TYPE 4 - MODE 7 ****************

			.db	0x3f				; 0 Horizontal Total	 =64
			.db	0x28				; 1 Horizontal Displayed =40
			.db	0x33				; 2 Horizontal Sync	 =&33  Note: &31 is a better value
			.db	0x24				; 3 HSync Width+VSync	 =&24  VSync=2, HSync=4
			.db	0x1e				; 4 Vertical Total	 =30
			.db	0x02				; 5 Vertical Adjust	 =2
			.db	0x19				; 6 Vertical Displayed	 =25
			.db	0x1b				; 7 VSync Position	 =&1B
			.db	0x93				; 8 Interlace+Cursor	 =&93  Cursor=2, Display=1, Interlace=Sync+Video
			.db	0x12				; 9 Scan Lines/Character =19
			.db	0x72				; 10 Cursor Start Line	  =&72	Blink=On, Speed=1/32, Line=18
			.db	0x13				; 11 Cursor End Line	  =19

