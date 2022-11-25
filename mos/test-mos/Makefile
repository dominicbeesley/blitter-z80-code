AS=asz80
ASFLAGS=-ols
LD=aslink
LDFLAGS=
BUILD=./build/
TARGETS=test-mos.bin
HOSTFS=~/hostfs/testz80
SSD=$(BUILD)/z80first.ssd
OBJS=test-mos.rel font_data.rel z80logo.mo7.rel
OBJS2=$(addprefix $(BUILD),$(OBJS))

DEPS=../../includes/hardware.inc

X:=$(shell mkdir -p $(BUILD))

all:: $(addprefix $(BUILD),$(TARGETS))

ssd:: all
	dfs form -80 $(SSD)
	dfs title $(SSD) "z80first"
	dfs add $(SSD) $(BUILD)*.inf
	dfs opt4 -3 $(SSD)

hostfs:: ssd
	dfs read -i -d $(HOSTFS) $(SSD)


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $@ $<

$(BUILD)test-mos.ihx: $(OBJS2) test-mos.lnk
	$(LD) $(LDFLAGS) -f $(basename test-mos)

$(BUILD)test-mos.bin: $(BUILD)test-mos.ihx
	hex2bin 0xC000 $< $@
	echo -en "M.TEST FFC000 FFC000\\r" > $(BUILD)/test-mos.bin.inf
	echo -en "$.!BOOT 000000 000000\\r" > $(BUILD)/_21BOOT.txt.inf
	echo -en "OSCLI(\"EXEC\"):OSCLI(\"BLLOAD M.TEST #D1 7D0000\"):PRINT \"PRESS BREAK\"\\r" > $(BUILD)/_21BOOT.txt


z80logo.mo7.asm:  z80logo.mo7

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

.PHONY: all clean
	

