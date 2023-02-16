;;?;; TODOmos_MACHINE_TYPE_BYTE	=	0x63

FSCV_CODE_OSCLI_UK	=	0x03

;TODO there is no zero page on the z80 - interpose these between vectors?
;;TODO;;zp_lang				=	0x0000

zp_base				=	0x0090

zpIY_eco			= 	0x00
zpIY_nmi			= 	0x10
zpIY_A9				= 	0x19
zpIY_fs_s			= 	0x20
zpIY_fs_w			= 	0x30
zpIY_vdu_status			= 	0x30	; VDU Status as read by OSBYTE &75

VDUSTAT0_printen		= 	0	;printer enable
VDUSTAT1_scrolldis		= 	1	;scrolling disabled
VDUSTAT2_paged			= 	2	;paged scrolling selected
VDUSTAT3_softscroll		= 	3	;software scrolling (text window)
VDUSTAT4_uk			= 	4	;not used
VDUSTAT5_vdu5			= 	5	;graphics cursor enabled (VDU 5)
VDUSTAT6_cursor_edit		= 	6	;separated cursors
VDUSTAT7_vdudis			= 	7	;VDU disabled

zpIY_vdu_grpixmask		= 	0x31	; Graphics pixel mask
zpIY_vdu_txtcolourOR		= 	0x32	; Text colour OR mask
zpIY_vdu_txtcolourEOR		= 	0x33	; Text colour EOR mask
zpIY_vdu_gracolourOR		= 	0x34	; Graphics colour OR mask
zpIY_vdu_gracolourEOR		= 	0x35	; Graphics colour EOR mask
zpIY_vdu_gra_char_cell		= 	0x36	; Graphics character cell
zpIY_vdu_top_scanline		= 	0x38	; Top scan line
zpIY_vdu_wksp			= 	0x3A	; Temporary workspace
zpIY_vdu_row_mul		= 	0x50	; BBC, Electron: Row multiplication
zpIY_cfs_w			= 	0x52
zpIY_opt_val			= 	0x53	; DB? check
zpIY_mos_GSREAD_quoteflag	= 	0x54	; GSREAD quote flag
zpIY_mos_GSREAD_characc		= 	0x55	; GSREAD character accumulator
zpIY_mos_OS_wksp		= 	0x56	; General OS workspace
zpIY_mos_autorep_countdown	= 	0x57	; Auto repeat countdown timer
zpIY_mos_input_buf		= 	0x58	; Input buffer pointer for OSWORD 0
zpIY_mos_rs423timeout		= 	0x5A	; RS423 timeout counter, unused if no RS423
zpIY_mos_cfs_critical		= 	0x5B	; CFS/RFS 'critical' flag
zpIY_mos_keynumlast		= 	0x5C	; Internal key number (last)
zpIY_mos_keynumfirst		= 	0x5D	; Internal key number (first)
zpIY_mos_jimdevsave		= 	0x5E	; Internal key number of character to be ignored by OSBYTE &79, also the 1MHz bus paging register
zpIY_mos_OSBW_A			= 	0x5F	; OSBYTE/OSWORD A reg value
zpIY_mos_OSBW_X			= 	0x60	; OSBYTE/OSWORD Y reg value
zpIY_mos_OSBW_Y			= 	0x61	; OSBYTE/OSWORD X reg value
zpIY_mos_txtptr			= 	0x62	; OS Text pointer (eg star commands and filenames)
zpIY_mos_curROM			= 	0x64	; Currently selected ROM
zpIY_mos_curPHROM		= 	0x65	; Current PHROM or RFS ROM number or OSRDSC/OSWRSC number
zpIY_mos_genPTR			= 	0x66	; PHROM/RFSROM/OSRDSC/OSWRSC pointer
zpIY_mos_X			= 	0x68	; BBC, Electron: Unused, Master: Soft key expansion pointer
zpIY_mos_OS_wksp2		= 	0x6A	; General OS workspace, used by buffer access code in interrupts
zpIY_mos_INT_A			= 	0x6C	; Interrupt Temp A reg store
zpIY_mos_error_ptr		= 	0x6D	; Error message pointer, initially set to language version string
zpIY_mos_ESC_flag		= 	0x6F	; Escape flag (bit 7)

zp_eco				= zp_base + zpIY_eco
zp_nmi				= zp_base + zpIY_nmi
zp_A9				= zp_base + zpIY_A9
zp_fs_s				= zp_base + zpIY_fs_s
zp_fs_w				= zp_base + zpIY_fs_w
zp_vdu_status			= zp_base + zpIY_vdu_status
zp_vdu_grpixmask		= zp_base + zpIY_vdu_grpixmask
zp_vdu_txtcolourOR		= zp_base + zpIY_vdu_txtcolourOR
zp_vdu_txtcolourEOR		= zp_base + zpIY_vdu_txtcolourEOR
zp_vdu_gracolourOR		= zp_base + zpIY_vdu_gracolourOR
zp_vdu_gracolourEOR		= zp_base + zpIY_vdu_gracolourEOR
zp_vdu_gra_char_cell		= zp_base + zpIY_vdu_gra_char_cell
zp_vdu_top_scanline		= zp_base + zpIY_vdu_top_scanline
zp_vdu_wksp			= zp_base + zpIY_vdu_wksp
zp_vdu_row_mul			= zp_base + zpIY_vdu_row_mul
zp_cfs_w			= zp_base + zpIY_cfs_w
zp_opt_val			= zp_base + zpIY_opt_val
zp_mos_GSREAD_quoteflag		= zp_base + zpIY_mos_GSREAD_quoteflag
zp_mos_GSREAD_characc		= zp_base + zpIY_mos_GSREAD_characc
zp_mos_OS_wksp			= zp_base + zpIY_mos_OS_wksp
zp_mos_autorep_countdown	= zp_base + zpIY_mos_autorep_countdown
zp_mos_input_buf		= zp_base + zpIY_mos_input_buf
zp_mos_rs423timeout		= zp_base + zpIY_mos_rs423timeout
zp_mos_cfs_critical		= zp_base + zpIY_mos_cfs_critical
zp_mos_keynumlast		= zp_base + zpIY_mos_keynumlast
zp_mos_keynumfirst		= zp_base + zpIY_mos_keynumfirst
zp_mos_jimdevsave		= zp_base + zpIY_mos_jimdevsave
zp_mos_OSBW_A			= zp_base + zpIY_mos_OSBW_A
zp_mos_OSBW_X			= zp_base + zpIY_mos_OSBW_X
zp_mos_OSBW_Y			= zp_base + zpIY_mos_OSBW_Y
zp_mos_txtptr			= zp_base + zpIY_mos_txtptr
zp_mos_curROM			= zp_base + zpIY_mos_curROM
zp_mos_curPHROM			= zp_base + zpIY_mos_curPHROM
zp_mos_genPTR			= zp_base + zpIY_mos_genPTR
zp_mos_X			= zp_base + zpIY_mos_X
zp_mos_OS_wksp2			= zp_base + zpIY_mos_OS_wksp2
zp_mos_INT_A			= zp_base + zpIY_mos_INT_A
zp_mos_error_ptr		= zp_base + zpIY_mos_error_ptr
zp_mos_ESC_flag			= zp_base + zpIY_mos_ESC_flag


stack				=	0x0100
STACKTOP			=	0x0200

sysvar_OSVARADDR		=	0x0236	; fx166/7 &A6/7 Address of OS variables
sysvar_ROMPTRTAB		=	0x0238	; fx168/9 &A8/9 Address of ROM pointer table
sysvar_ROMINFOTAB		=	0x023A	; fx170/1 &AA/B Address of ROM info table
sysvar_KEYB_ADDRTRANS		=	0x023C	; fx172/3 &AC/D Address of key translation table
sysvar_ADDRVDUVARS		=	0x023E	; fx174/5 &AE/F Address of VDU variables
sysvar_CFSTOCTR			=	0x0240	; fx176	  &B0	CFS timeout counter, decremented every frame flyback
sysvar_CURINSTREAM		=	0x0241	; fx177	  &B1	Currently selected input stream set with FX2
sysvar_KEYB_SEMAPHORE		=	0x0242	; fx178	  &B2	BBC, Master: Keyboard semaphore
sysvar_PRI_OSHWM		=	0x0243	; fx179	  &B3	Primary OSHWM
sysvar_CUR_OSHWM		=	0x0244	; fx180	  &B4	Current OSHWM
sysvar_RS423_MODE		=	0x0245	; fx181	  &B5	RS423 mode
sysvar_EXPLODESTATUS		=	0x0246	; fx182	  &B6	BBC, Electron: Character definition explosion status
sysvar_CFSRFS_SWITCH		=	0x0247	; fx183	  &B7	CFS/RFS switch
sysvar_VIDPROC_CTL_COPY		=	0x0248	; fx184	  &B8	BBC, Master: RAM copy of VIDPROC control register
sysvar_VIDPROC_PAL_COPY		=	0x0249	; fx185	  &B9	BBC, Master: RAM copy of VIDPROC palette register
sysvar_ROMNO_ATBREAK		=	0x024A	; fx186	  &BA	ROM active last BRK
sysvar_ROMNO_BASIC		=	0x024B	; fx187	  &BB	BASIC ROM number
sysvar_ADC_CUR			=	0x024C	; fx188	  &BC	Current ADC Channel
sysvar_ADC_MAX			=	0x024D	; fx189	  &BD	Maximum ADC Channel number
sysvar_ADC_ACCURACY		=	0x024E	; fx190	  &BE	ADC conversion type/accuracy
sysvar_RS423_USEFLAG		=	0x024F	; fx191	  &BF	RS423 use flag
sysvar_RS423_CTL_COPY		=	0x0250	; fx192	  &C0	RAM copy of RS423 control register
sysvar_FLASH_CTDOWN		=	0x0251	; fx193	  &C1	Flashing colour countdown timer
sysvar_FLASH_SPACE_PERIOD	=	0x0252	; fx194	  &C2	Flashing colour space period count set by FX9
sysvar_FLASH_MARK_PERIOD	=	0x0253	; fx195	  &C3	Flashing colour mark period count set by FX10
sysvar_KEYB_AUTOREP_DELAY	=	0x0254	; fx196	  &C4	Keyboard auto-repeat delay set by FX11
sysvar_KEYB_AUTOREP_PERIOD	=	0x0255	; fx197	  &C5	Keyboard auto-repeat period set by FX12
sysvar_EXEC_FILE		=	0x0256	; fx198	  &C6	*EXEC file
sysvar_SPOOL_FILE		=	0x0257	; fx199	  &C7	*SPOOL file handle
sysvar_BREAK_EFFECT		=	0x0258	; fx200	  &C8	ESCAPE, BREAK effect
sysvar_KEYB_DISABLE		=	0x0259	; fx201	  &C9	Keyboard disable
sysvar_KEYB_STATUS		=	0x025A	; fx202	  &CA	Keyboard status byte
							;Bit 7  =1 shift enabled   
							;Bit 6  =1 control pressed 
							;bit 5  =0 shift lock      
							;Bit 4  =0 Caps lock       
							;Bit 3  =1 shift pressed   
sysvar_RS423_BUF_EXT		=	0x025B	; fx203	  &CB	BBC, Master: Serial input buffer extent
sysvar_RS423_SUPPRESS		=	0x025C	; fx204	  &CC	BBC, Master: Serial input supression flag
sysvar_RS423CASS_SELECT		=	0x025D	; fx205	  &CD	BBC, Master: Serial/cassette selection flag
sysvar_ECO_OSBW_INTERCEPT	=	0x025E	; fx206	  &CE	Econet OSBYTE/OSWORD intercept flag
sysvar_ECO_OSRDCH_INTERCEPT	=	0x025F	; fx207	  &CF	Econet OSRDCH intercept flag
sysvar_ECO_OSWRCH_INTERCEPT	=	0x0260	; fx208	  &D0	Econet OSWRCH intercept flag
sysvar_SPEECH_SUPPRESS		=	0x0261	; fx209	  &D1	Speech suppression status
sysvar_SOUND_SUPPRESS		=	0x0262	; fx210	  &D2	Sound suppression status
sysvar_BELL_CH			=	0x0263	; fx211	  &D3	BELL channel number
sysvar_BELL_ENV			=	0x0264	; fx212	  &D4	BELL envelope number/amplitude
sysvar_BELL_FREQ		=	0x0265	; fx213	  &D5	BELL fr	=	ency
sysvar_BELL_DUR			=	0x0266	; fx214	  &D6	BELL duration
sysvar_STARTUP_DISPOPT		=	0x0267	; fx215	  &D7	Startup display and BOOT error options
sysvar_KEYB_SOFTKEY_LENGTH	=	0x0268	; fx216	  &D8	Soft key string length
sysvar_SCREENLINES_SINCE_PAGE	=	0x0269	; fx217	  &D9	Screen lines since last page
sysvar_VDU_Q_LEN		=	0x026A	; fx218	  &DA	256-number of items in VDU queue
sysvar_KEYB_TAB_CHAR		=	0x026B	; fx219	  &DB	BBC, Master: TAB key character
sysvar_KEYB_ESC_CHAR		=	0x026C	; fx220	  &DC	ESCAPE character
sysvar_KEYB_C0CF_INSERT_INT	=	0x026D	; fx221	  &DD	Char &C0-&CF buffer insert interpretation
sysvar_KEYB_D0DF_INSERT_INT	=	0x026E	; fx222	  &DE	Char &D0-&DF buffer insert interpretation
sysvar_KEYB_E0EF_INSERT_INT	=	0x026F	; fx223	  &DF	Char &E0-&EF buffer insert interpretation
sysvar_KEYB_F0FF_INSERT_INT	=	0x0270	; fx224	  &E0	Char &F0-&FF buffer insert interpretation
sysvar_KEYB_808F_INSERT_INT	=	0x0271	; fx225	  &E1	Char &80-&8F buffer insert interpretation (FKey)
sysvar_KEYB_909F_INSERT_INT	=	0x0272	; fx226	  &E2	Char &90-&9F buffer insert interpretation (Sh+FKey)
sysvar_KEYB_A0AF_INSERT_INT	=	0x0273	; fx227	  &E3	Char &A0-&AF buffer insert interpretation (Ct+FKey)
sysvar_KEYB_B0BF_INSERT_INT	=	0x0274	; fx228	  &E4	Char &B0-&BF buffer insert interpretation (Ct+Sh+FKey)
sysvar_KEYB_ESC_ACTION		=	0x0275	; fx229	  &E5	ESCAPE key action
sysvar_KEYB_ESC_EFFECT		=	0x0276	; fx230	  &E6	ESCAPE effects
sysvar_USERVIA_IRQ_MASK_CPY	=	0x0277	; fx231	  &E7	User 6522 VIA IRQ mask
sysvar_ACIA_IRQ_MASK_CPY	=	0x0278	; fx232	  &E8	6850 ACIA IRQ bit mask
sysvar_SYSVIA_IRQ_MASK_CPY	=	0x0279	; fx233	  &E9	System 6522 VIA IRQ mask
sysvar_TUBE_PRESENT		=	0x027A	; fx234	  &EA	Tube presence flag
sysvar_SPEECH_PRESENT		=	0x027B	; fx235	  &EB	Speech processor presence flag
sysvar_OUTSTREAM_DEST		=	0x027C	; fx236	  &EC	Output stream character destination, set with FX3
sysvar_KEY_CURSORSTAT		=	0x027D	; fx237	  &ED	Cursor key status, set with FX4
sysvar_FX238			=	0x027E	; fx238	  &EE	BBC, Electron: unused
sysvar_FX239			=	0x027F	; fx239	  &EF	unused
sysvar_COUNTRY			=	0x0280	; fx240	  &F0	Country code
sysvar_USERFLAG			=	0x0281	; fx241	  &F1	User flag location, set with FX1
sysvar_SERPROC_CTL_CPY		=	0x0282	; fx242	  &F2	BBC, Master: RAM copy of SERPROC control register
sysvar_TIMER_SWITCH		=	0x0283	; fx243	  &F3	Timer switch state
sysvar_KEYB_SOFT_CONSISTANCY	=	0x0284	; fx244	  &F4	Soft key consistancy flag
sysvar_PRINT_DEST		=	0x0285	; fx245	  &F5	Printer destination, set with FX5
sysvar_PRINT_IGNORE		=	0x0286	; fx246	  &F6	Printer ignore character, set with FX6
sysvar_BREAK_VECTOR_JMP		=	0x0287	; fx247	  &F7	Break Intercept Vector JMP
sysvar_BREAK_VECTOR_LOW		=	0x0288	; fx248	  &F8	Break Intercept Vector address low byte
sysvar_BREAK_VECTOR_HIGH	=	0x0289	; fx249	  &F9	Break Intercept Vector address high byte
sysvar_SHADOW1			=	0x028A	; fx250	  &FA	BBC, Electron: unused, unless shadow screen present
sysvar_SHADOW2			=	0x028B	; fx251	  &FB	BBC, Electron: unused, unless shadow screen present
sysvar_CUR_LANG			=	0x028C	; fx252	  &FC	Current language ROM
sysvar_BREAK_LAST_TYPE		=	0x028D	; fx253	  &FD	Last BREAK type
sysvar_RAM_AVAIL		=	0x028E	; fx254	  &FE	BBC: Available RAM
sysvar_STARTUP_OPT		=	0x028F	; fx255	  &FF	Startup options
oswksp_VDU_VERTADJ		=	0x0290	; VDU vertical adjust, *TV first parameter
oswksp_VDU_INTERLACE		=	0x0291	; Interlace toggle flag, *TV second parameter
oswksp_TIME			=	0x0292	; TIME value 1, high byte...low byte
oswksp_TIME2			=	0x0297	; TIME value 2, high byte...low byte
oswksp_OSWORD3_CTDOWN		=	0x029C	; OSWORD 3/4 Countdown interval timer value
oswksp_ROMTYPE_TAB		=	0x02A1	; Paged ROM type table
oswksp_INKEY_CTDOWN		=	0x02B1	; INKEY countdown timer
oswksp_OSWORD0_LINE_LEN		=	0x02B3	; OSWORD 0 maximum line length
oswksp_OSWORD0_MIN_CH		=	0x02B4	; OSWORD 0 minimum character
oswksp_OSWORD0_MAX_CH		=	0x02B5	; OSWORD 0 maximum character
adc_CH1_LOW			=	0x02B6	; Channel 1 ADC value low
adc_CH2_LOW			=	0x02B7	; Channel 2 ADC value low
adc_CH3_LOW			=	0x02B8	; Channel 3 ADC value low
adc_CH4_LOW			=	0x02B9	; Channel 4 ADC value low
adc_CH1_HI			=	0x02BA	; Channel 1 ADC value high
adc_CH2_HI			=	0x02BB	; Channel 2 ADC value high
adc_CH3_HI			=	0x02BC	; Channel 3 ADC value high
adc_CH4_HI			=	0x02BD	; Channel 4 ADC value high
adc_CH_LAST			=	0x02BE	; Last ADC channel converted
mosvar_EVENT_ENABLE		=	0x02BF	; MOS Event enable flags
mosvar_SOFTKEY_PTR		=	0x02C9	; Soft key expansion pointer
mosvar_KEYB_AUTOREPEAT_COUNT	=	0x02CA	; First auto repeat count
mosvar_KEYB_TWOKEY_ROLLOVER	=	0x02CB	; Two key rollover workspace
mosvar_SOUND_SEMAPHORE		=	0x02CE	; Sound semaphore
mosbuf_buf_busy			=	0x02CF	; Buffer busy flags	      
mosbuf_buf_start		=	0x02D8	; Buffer start indexes	      
mosbuf_buf_end			=	0x02E1	; Buffer end indexes	      
cfsrfs_BLK_SIZE			=	0x02EA	; Block size
cfsrfs_BLK_FLAG			=	0x02EC	; Block flag
cfsrfs_LAST_CHA			=	0x02ED	; Last input character
osfile_ctlblk			=	0x02EE	; OSFILE control blocks for *LOAD, *SAVE, *CREATE and *DELETE.


vduvars_start			=	0x0300

; unlike 6502/6809 these are specified as an offset from IX register in VDU drivers, 
; in user code use vduvars_start + vduIX, or better still the relevant API call

vduIX_GRA_WINDOW		=	0x00				
vduIX_GRA_WINDOW_LEFT		=	0x00	; Current graphics window left column in pixels
vduIX_GRA_WINDOW_BOTTOM		=	0x02	; Current graphics window bottom row in pixels
vduIX_GRA_WINDOW_RIGHT		=	0x04	; Current graphics window right column in pixels
vduIX_GRA_WINDOW_TOP		=	0x06	; Current graphics window top row in pixels
vduIX_TXT_WINDOW_LEFT		=	0x08	; Current text window left hand column
vduIX_TXT_WINDOW_BOTTOM		=	0x09	; Current text window bottom row
vduIX_TXT_WINDOW_RIGHT		=	0x0A	; Current text window right hand column
vduIX_TXT_WINDOW_TOP		=	0x0B	; Current text window top column
vduIX_GRA_ORG_EXT		=	0x0C	; Current graphics origin in external coordinates
vduIX_GRA_CUR_EXT		=	0x10	; Current graphics cursor in external coordinates
vduIX_GRA_CUR_INT_OLD		=	0x14	; Old graphics cursor in external coordinates
vduIX_TXT_CUR_X			=	0x18	; Current text cursor X
vduIX_TXT_CUR_Y			=	0x19	; Current text cursor Y
vduIX_GRA_CUR_CELL_LINE		=	0x1A	; Line within current graphics cell of graphics cursor
vduIX_VDU_Q_START		=	0x1B
vduIX_VDU_Q_END			=	0x24	; end of VDU Q (well 1 after!)
vduIX_GRA_CUR_INT		=	0x24	; Current graphics cursor in internal coordinates
vduIX_TEMP_8			=	0x28	; Bitmap read from screen by OSBYTE 135, various coordinate routines
vduIX_GRA_WKSP			=	0x30	; Graphics workspace
vduIX_6845_CURSOR_ADDR		=	0x4A	; Text cursor address for 6845
vduIX_TXT_WINDOW_WIDTH_BYTES	=	0x4C	; Text window width in bytes
vduIX_SCREEN_BOTTOM_HIGH	=	0x4E	; High byte of bottom of screen memory
vduIX_BYTES_PER_CHAR		=	0x4F	; Bytes per character for current mode
vduIX_6845_SCREEN_START		=	0x50	; Screen display start address for 6845
vduIX_BYTES_PER_ROW		=	0x52	; Bytes per screen row
vduIX_SCREEN_SIZE_HIGH		=	0x54	; Screen memory size high byte
vduIX_MODE			=	0x55	; Current screen mode
vduIX_MODE_SIZE			=	0x56	; Memory map type: 0 - 20K, 1 - 16K, 2 - 10K, 3 - 8K, 4 - 1K
vduIX_TXT_FORE			=	0x57	; Foreground text colour
vduIX_TXT_BACK			=	0x58	; Background text colour
vduIX_GRA_FORE			=	0x59	; Foreground graphics colour
vduIX_GRA_BACK			=	0x5A	; Background graphics colour
vduIX_GRA_PLOT_FORE		=	0x5B	; Foreground plot mode
vduIX_GRA_PLOT_BACK		=	0x5C	; Background plot mode
vduIX_VDU_VEC_JMP		=	0x5D	; General VDU jump vector
vduIX_CUR_START_PREV		=	0x5F	; Cursor start register previous setting
vduIX_COL_COUNT_MINUS1		=	0x60	; Number logical colours -1
vduIX_PIXELS_PER_BYTE_MINUS1	=	0x61	; Pixels per byte -1 (zero if text only mode)
vduIX_LEFTMOST_PIX_MASK		=	0x62	; Leftmost pixel colour mask
vduIX_RIGHTMOST_PIX_MASK	=	0x63	; Rightmost pixel colour mask
vduIX_TEXT_IN_CUR_X		=	0x64	; Text input cursor X
vduIX_TEXT_IN_CUR_Y		=	0x65	; Text input cursor Y
vduIX_MO7_CUR_CHAR		=	0x66	; Teletext output cursor character
vduIX_EXPLODE_FLAGS		=	0x67	; Font explosion flags, b1=224-255 in RAM, b7=32-63 in RAM
vduIX_FONT_LOC32_63		=	0x68	; Font location, characters 32-63
vduIX_FONT_LOC64_95		=	0x69	; Font location, characters 64-95 
vduIX_FONT_LOC96_127		=	0x6A	; Font location, characters 96-127
vduIX_FONT_LOC128_159		=	0x6B	; Font location, characters 128-159
vduIX_FONT_LOC160_191		=	0x6C	; Font location, characters 160-191
vduIX_FONT_LOC192_223		=	0x6D	; Font location, characters 192-223
vduIX_FONT_LOC224_255		=	0x6E	; Font location, characters 224-255
vduIX_PALLETTE			=	0x6F	; Palette for colours 0 to 15

vduvar_GRA_WINDOW		= vduvars_start + vduIX_GRA_WINDOW
vduvar_GRA_WINDOW_LEFT		= vduvars_start + vduIX_GRA_WINDOW_LEFT
vduvar_GRA_WINDOW_BOTTOM	= vduvars_start + vduIX_GRA_WINDOW_BOTTOM
vduvar_GRA_WINDOW_RIGHT		= vduvars_start + vduIX_GRA_WINDOW_RIGHT
vduvar_GRA_WINDOW_TOP		= vduvars_start + vduIX_GRA_WINDOW_TOP
vduvar_TXT_WINDOW_LEFT		= vduvars_start + vduIX_TXT_WINDOW_LEFT
vduvar_TXT_WINDOW_BOTTOM	= vduvars_start + vduIX_TXT_WINDOW_BOTTOM
vduvar_TXT_WINDOW_RIGHT		= vduvars_start + vduIX_TXT_WINDOW_RIGHT
vduvar_TXT_WINDOW_TOP		= vduvars_start + vduIX_TXT_WINDOW_TOP
vduvar_GRA_ORG_EXT		= vduvars_start + vduIX_GRA_ORG_EXT
vduvar_GRA_CUR_EXT		= vduvars_start + vduIX_GRA_CUR_EXT
vduvar_GRA_CUR_INT_OLD		= vduvars_start + vduIX_GRA_CUR_INT_OLD
vduvar_TXT_CUR_X		= vduvars_start + vduIX_TXT_CUR_X
vduvar_TXT_CUR_Y		= vduvars_start + vduIX_TXT_CUR_Y
vduvar_GRA_CUR_CELL_LINE	= vduvars_start + vduIX_GRA_CUR_CELL_LINE
vduvar_VDU_Q_START		= vduvars_start + vduIX_VDU_Q_START
vduvar_VDU_Q_END		= vduvars_start + vduIX_VDU_Q_END
vduvar_GRA_CUR_INT		= vduvars_start + vduIX_GRA_CUR_INT
vduvar_TEMP_8			= vduvars_start + vduIX_TEMP_8
vduvar_GRA_WKSP			= vduvars_start + vduIX_GRA_WKSP
vduvar_6845_CURSOR_ADDR		= vduvars_start + vduIX_6845_CURSOR_ADDR
vduvar_TXT_WINDOW_WIDTH_BYTES	= vduvars_start + vduIX_TXT_WINDOW_WIDTH_BYTES
vduvar_SCREEN_BOTTOM_HIGH	= vduvars_start + vduIX_SCREEN_BOTTOM_HIGH
vduvar_BYTES_PER_CHAR		= vduvars_start + vduIX_BYTES_PER_CHAR
vduvar_6845_SCREEN_START	= vduvars_start + vduIX_6845_SCREEN_START
vduvar_BYTES_PER_ROW		= vduvars_start + vduIX_BYTES_PER_ROW
vduvar_SCREEN_SIZE_HIGH		= vduvars_start + vduIX_SCREEN_SIZE_HIGH
vduvar_MODE			= vduvars_start + vduIX_MODE
vduvar_MODE_SIZE		= vduvars_start + vduIX_MODE_SIZE
vduvar_TXT_FORE			= vduvars_start + vduIX_TXT_FORE
vduvar_TXT_BACK			= vduvars_start + vduIX_TXT_BACK
vduvar_GRA_FORE			= vduvars_start + vduIX_GRA_FORE
vduvar_GRA_BACK			= vduvars_start + vduIX_GRA_BACK
vduvar_GRA_PLOT_FORE		= vduvars_start + vduIX_GRA_PLOT_FORE
vduvar_GRA_PLOT_BACK		= vduvars_start + vduIX_GRA_PLOT_BACK
vduvar_VDU_VEC_JMP		= vduvars_start + vduIX_VDU_VEC_JMP
vduvar_CUR_START_PREV		= vduvars_start + vduIX_CUR_START_PREV
vduvar_COL_COUNT_MINUS1		= vduvars_start + vduIX_COL_COUNT_MINUS1
vduvar_PIXELS_PER_BYTE_MINUS1	= vduvars_start + vduIX_PIXELS_PER_BYTE_MINUS1
vduvar_LEFTMOST_PIX_MASK	= vduvars_start + vduIX_LEFTMOST_PIX_MASK
vduvar_RIGHTMOST_PIX_MASK	= vduvars_start + vduIX_RIGHTMOST_PIX_MASK
vduvar_TEXT_IN_CUR_X		= vduvars_start + vduIX_TEXT_IN_CUR_X
vduvar_TEXT_IN_CUR_Y		= vduvars_start + vduIX_TEXT_IN_CUR_Y
vduvar_MO7_CUR_CHAR		= vduvars_start + vduIX_MO7_CUR_CHAR
vduvar_EXPLODE_FLAGS		= vduvars_start + vduIX_EXPLODE_FLAGS
vduvar_FONT_LOC32_63		= vduvars_start + vduIX_FONT_LOC32_63
vduvar_FONT_LOC64_95		= vduvars_start + vduIX_FONT_LOC64_95
vduvar_FONT_LOC96_127		= vduvars_start + vduIX_FONT_LOC96_127
vduvar_FONT_LOC128_159		= vduvars_start + vduIX_FONT_LOC128_159
vduvar_FONT_LOC160_191		= vduvars_start + vduIX_FONT_LOC160_191
vduvar_FONT_LOC192_223		= vduvars_start + vduIX_FONT_LOC192_223
vduvar_FONT_LOC224_255		= vduvars_start + vduIX_FONT_LOC224_255
vduvar_PALLETTE			= vduvars_start + vduIX_PALLETTE



fsvar_seq_block_gap		=	0x03D1

; ********************************************************
; *           B U F F E R   A D D R E S S E S            *
; ********************************************************

BUFFER_KEYB_START	=	0x03E0
BUFFER_KEYB_END		=	0x03FF
BUFFER_SERI_START	=	0x0A00
BUFFER_SERI_END		=	0x0AFF
BUFFER_SERO_START	=	0x0900
BUFFER_SERO_END		=	0x09BF
BUFFER_LPT_START	=	0x0880
BUFFER_LPT_END		=	0x08BF
BUFFER_SND0_START	=	0x0840
BUFFER_SND0_END		=	0x084F
BUFFER_SND1_START	=	0x0850
BUFFER_SND1_END		=	0x085F
BUFFER_SND2_START	=	0x0860
BUFFER_SND2_END		=	0x086F
BUFFER_SND3_START	=	0x0870
BUFFER_SND3_END		=	0x087F
BUFFER_SPCH_START	=	0x09C0
BUFFER_SPCH_END		=	0x09FF


;; move these into buffer.asm ;; BUFFER_PTR_ADDR		MACRO ; 1=START, 2=END
;; move these into buffer.asm ;; 			FDB (\2+1)-0x100
;; move these into buffer.asm ;; 			ENDM
;; move these into buffer.asm ;; 
;; move these into buffer.asm ;; BUFFER_ACC_OFF		MACRO ; 1=START, 2=END
;; move these into buffer.asm ;; 			FCB \1-(\2+1)-0x100		; i.e. 0x100 - len!
;; move these into buffer.asm ;; 			ENDM




snd_unused1	=	0x800	; Unused
snd_q_occupied	=	0x804	; Sound queue occupancy flag
snd_amplitude	=	0x808	; Current amplitude
snd_amplitude_phase_count	=	0x80C	; Number of amplitude phases processed
snd_abs_pitch	=	0x810	; Absolute pitch value
snd_pitch_phase_count	=	0x814	; Number of pitch phases processed
snd_steps_left	=	0x818	; Number of steps to process
snd_duration_ctr	=	0x81C	; Duration
snd_duration_mul	=	0x820	; Interval multiplier
snd_env_no	=	0x824	; Envelope number/auto repeat parameter
snd_length_left	=	0x828	; Length of remaining note interval
snd_sync_hold_parm	=	0x82C	; Sync hold parameter
snd_chip_pitch	=	0x830	; Sound chip current pitch setting
snd_pitch_deviation	=	0x834	; Pitch deviation
snd_num_chans_sync	=	0x838	; Number of channels r	=	ired for sync
snd_cur_amp_step	=	0x839	; Current amplitude step
snd_cur_target_amplitude	=	0x83A	; Current target amplitude
snd_num_chans_hold_sync	=	0x83B	; Number of channels on hold for sync

snd_parm_wksp	=	0x83C	; Sound parameter calculation workspace
snd_low_parm	=	0x83D	; Low order fr	=	ency parameter as sent to the sound generator
snd_high_parm	=	0x83E	; High order fr	=	ency parameter as sent to the sound generator
snd_tempx	=	0x83F

snd_envelope_defs	=	0x8C0

soft_keys_start	=	0xB00
soft_keys_ptrs	=	soft_keys_start
soft_keys_end_ptr	=	soft_keys_ptrs+0x10
soft_keys_defs	=	soft_keys_start+0x11

vec_nmi	=	0x0D00

swrom_wksp_tab	=	0x0DF0

; REMAPPED HARDWARE VECTOS

HWVEC_DIV0	=	0xF7F0
HWVEC_SWI3V	=	0xF7F2
HWVEC_SWI2V	=	0xF7F4
HWVEC_FIRQV	=	0xF7F6
HWVEC_IRQV	=	0xF7F8
HWVEC_SWIV	=	0xF7FA
HWVEC_NMIV	=	0xF7FC
HWVEC_RESETV	=	0xF7FE