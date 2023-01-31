AS=asz80
ASFLAGS=-ols
LD=aslink
LDFLAGS=
BUILD=./build/
TARGETS=mon-z180.bin
HOSTFS=~/hostfs/noice-z180
SSD=$(BUILD)/z180first.ssd
OBJS=mon-z180.rel
OBJS2=$(addprefix $(BUILD),$(OBJS))

DEPS=../../../includes/hardware.inc ../../includes/hardware-z180.inc

X:=$(shell mkdir -p $(BUILD))

#asz80 is an ashat and creates a file when there's an error and pisses around
#with the filename so you can't bloody rename it easily
.DELETE_ON_ERROR:

all:: $(addprefix $(BUILD),$(TARGETS))

ssd:: all
	dfs form -80 $(SSD)
	dfs title $(SSD) "noiceZ180"
	dfs add $(SSD) $(BUILD)*.inf
	dfs opt4 -3 $(SSD)

hostfs:: ssd
	mkdir -p $(HOSTFS)
	dfs read -i -d $(HOSTFS) $(SSD)


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $(basename $@) $<

$(BUILD)mon-z180.ihx: $(OBJS2) mon-z180.lnk
	$(LD) $(LDFLAGS) -f $(basename mon-z180)

$(BUILD)mon-z180.bin: $(BUILD)mon-z180.ihx
	hex2bin 0xC000 $< $@
	/bin/echo -e -n "M.NOIZ180 FFC000 FFC000\\r" > $(BUILD)/mon-z180.bin.inf
	/bin/echo -e -n "$.!BOOT 000000 000000\\r" > $(BUILD)/_21BOOT.txt.inf
	/bin/echo -e -n "OSCLI(\"EXEC\"):OSCLI(\"BLLOAD M.NOIZ180 #D1 7D0000\"):PRINT \"PRESS BREAK\"\\r" > $(BUILD)/_21BOOT.txt


$(BUILD)z180logo.mo7.rel:  z180logo.mo7

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

.PHONY: all clean
	

