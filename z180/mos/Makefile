AS=asz80
ASFLAGS=-olsvb -i 'Z180_INTERNAL_BASE = 0' -i 'NOICE_INITSTACK = 0x8000' -i 'NOICE_COMBUF_SIZE = 0x80' 
LD=aslink
LDFLAGS=-m1 -j -u
BUILD=./build/
TARGETS=mos-z180.bin
OBJS=mos-z180.rel noice-z180.rel font_data.rel hw_z180_init.rel z180_boot.rel vdu.rel debug.rel mos_calls.rel
OBJS2=$(addprefix $(BUILD),$(OBJS))

DEPS=../../includes/hardware.inc ../includes/hardware-z180.inc config.inc debug.inc ../../includes/mosrom.inc ./oscalls.inc

X:=$(shell mkdir -p $(BUILD))

#asz80 is an ashat and creates a file when there's an error and pisses around
#with the filename so you can't bloody rename it easily
.DELETE_ON_ERROR:

all:: $(addprefix $(BUILD),$(TARGETS))


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $(basename $@) $<

$(BUILD)mos-z180.ihx: $(OBJS2) mos-z180.lnk
	$(LD) $(LDFLAGS) -f $(basename mos-z180)

	#fix up the bad lines in the .noi file made by aslink
	sed -i.bak -e 's/^.*\._.*//' -e 's/^LOAD.*//' $(BUILD)/mos-z180.noi


$(BUILD)mos-z180.bin: $(BUILD)mos-z180.ihx
	hex2bin 0xC000 $< $@
	/bin/echo -e -n "M.MOSZ180 FFC000 FFC000\\r" > $@.inf
	/bin/echo -e -n "$.!BOOT 000000 000000\\r" > $(BUILD)/_21BOOT.txt.inf
	/bin/echo -e -n "OSCLI(\"EXEC\"):OSCLI(\"BLLOAD M.MOSZ180 #D1 7D0000\"):PRINT \"PRESS BREAK\"\\r" > $(BUILD)/_21BOOT.txt


clean:
	-rm $(BUILD)*.s19
	-rm $(BUILD)*.ihx
	-rm $(BUILD)*.lst
	-rm $(BUILD)*.rel
	-rm $(BUILD)*.sym
	-rm $(BUILD)*.noi
	-rm $(BUILD)*.bin
	-rm $(BUILD)*.map
	-rm $(BUILD)*.hlr
	-rm $(BUILD)*.inf
	-rm $(BUILD)*.rst

.PHONY: all clean
	

