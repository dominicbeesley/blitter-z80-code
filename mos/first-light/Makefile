AS=asz80
ASFLAGS=-ols
LD=aslink
LDFLAGS=
BUILD=./build/
TARGETS=first-light.bin
HOSTFS=~/hostfs/testz80
SSD=$(BUILD)/z80first.ssd

DEPS=../../includes/hardware.inc

X:=$(shell mkdir -p $(BUILD))

all:: $(addprefix $(BUILD),$(TARGETS))

ssd:: all
	dfs form -80 $(SSD)
	dfs title $(SSD) "z80first"
	dfs add $(SSD) $(BUILD)/*.inf

hostfs:: ssd
	dfs read -i -d $(HOSTFS) $(SSD)


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $@ $<

$(BUILD)first-light.ihx: $(BUILD)first-light.rel $(BUILD)font_data.rel first-light.lnk
	$(LD) $(LDFLAGS) -f $(basename first-light)

$(BUILD)first-light.bin: $(BUILD)first-light.ihx
	hex2bin 0xC000 $< $@
	echo M.FIRSTL FFC000 FFC000 > $(BUILD)/first-light.bin.inf
	echo $.\!FIRST 000000 000000 > $(BUILD)/_21FIRST.txt.inf
	echo "*BLLOAD M.FIRSTL #D1 7D0000" > $(BUILD)/_21FIRST.txt


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
	

