AS=asz80
ASFLAGS=-ols
LD=aslink
LDFLAGS=
BUILD=./build/
TARGETS=test-mos.bin
HOSTFS=~/hostfs/testz180
SSD=$(BUILD)/z180first.ssd
OBJS=test-mos.rel font_data.rel z180logo.mo7.rel
OBJS2=$(addprefix $(BUILD),$(OBJS))

DEPS=../../includes/hardware.inc ../includes/hardware.inc

X:=$(shell mkdir -p $(BUILD))

all:: $(addprefix $(BUILD),$(TARGETS))

ssd:: all
	dfs form -80 $(SSD)
	dfs title $(SSD) "z180first"
	dfs add $(SSD) $(BUILD)*.inf
	dfs opt4 -3 $(SSD)

hostfs:: ssd
	mkdir -p $(HOSTFS)
	dfs read -i -d $(HOSTFS) $(SSD)


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $@ $<

$(BUILD)test-mos.ihx: $(OBJS2) test-mos.lnk
	$(LD) $(LDFLAGS) -f $(basename test-mos)

$(BUILD)test-mos.bin: $(BUILD)test-mos.ihx
	hex2bin 0xC000 $< $@
	/bin/echo -e -n "M.TEST FFC000 FFC000\\r" > $(BUILD)/test-mos.bin.inf
	/bin/echo -e -n "$.!BOOT 000000 000000\\r" > $(BUILD)/_21BOOT.txt.inf
	/bin/echo -e -n "OSCLI(\"EXEC\"):OSCLI(\"BLLOAD M.TEST #D1 7D0000\"):PRINT \"PRESS BREAK\"\\r" > $(BUILD)/_21BOOT.txt


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
	

