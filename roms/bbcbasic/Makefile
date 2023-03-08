AS=asz80
ASFLAGS=-ols
LD=aslink
LDFLAGS=
BUILD=./build/
TARGETS=bbc-basic.rom
HOSTFS=~/hostfs/romsz80
SSD=$(BUILD)/romsz80.ssd
OBJS=main.rel cmos.rel eval.rel exec.rel fpp.rel patch.rel sorry.rel ram.rel 
OBJS2=$(addprefix $(BUILD),$(OBJS))

DEPS=

X:=$(shell mkdir -p $(BUILD))

all:: $(addprefix $(BUILD),$(TARGETS))

ssd:: all
	dfs form -80 $(SSD)
	dfs title $(SSD) "romsz80"
	dfs add $(SSD) $(BUILD)*.inf
	dfs opt4 -3 $(SSD)

hostfs:: ssd
	dfs read -i -d $(HOSTFS) $(SSD)


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $@ $<

$(BUILD)bbc-basic.ihx: $(OBJS2) bbc-basic.lnk
	$(LD) $(LDFLAGS) -f $(basename bbc-basic)

$(BUILD)bbc-basic.rom: $(BUILD)bbc-basic.ihx
	hex2bin 0x8000 $< $@
	echo -en "R.BASIZ80 FF8000 FF8000\\r" > $(BUILD)/bbc-basic.rom.inf


clean:
	-rm $(BUILD)*.s19
	-rm $(BUILD)*.ihx
	-rm $(BUILD)*.lst
	-rm $(BUILD)*.rel
	-rm $(BUILD)*.sym
	-rm $(BUILD)*.noi
	-rm $(BUILD)*.bin
	-rm $(BUILD)*.rom
	-rm $(BUILD)*.map
	-rm $(BUILD)*.hlr

.PHONY: all clean
	

