AS=asz80
ASFLAGS=-ols
LD=aslink
LDFLAGS=-m1 -j -u
BUILD=./build/
TARGETS=test-im1-int0.bin
HOSTFS=~/hostfs/noice-z180
SSD=$(BUILD)/z180first.ssd
OBJS=test-im1-int0.rel
OBJS2=$(addprefix $(BUILD),$(OBJS))

DEPS=../../../includes/hardware.inc ../../includes/hardware-z180.inc

X:=$(shell mkdir -p $(BUILD))

#asz80 is an ashat and creates a file when there's an error and pisses around
#with the filename so you can't bloody rename it easily
.DELETE_ON_ERROR:

all:: $(addprefix $(BUILD),$(TARGETS))


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $(basename $@) $<

$(BUILD)test-im1-int0.ihx: $(OBJS2) test-im1-int0.lnk
	$(LD) $(LDFLAGS) -f $(basename test-im1-int0)

$(BUILD)test-im1-int0.bin: $(BUILD)test-im1-int0.ihx
	hex2bin 0x400 $< $@

clean:
	-rm $(BUILD)*.s19
	-rm $(BUILD)*.ihx
	-rm $(BUILD)*.lst
	-rm $(BUILD)*.rst
	-rm $(BUILD)*.rel
	-rm $(BUILD)*.sym
	-rm $(BUILD)*.noi
	-rm $(BUILD)*.bin
	-rm $(BUILD)*.map
	-rm $(BUILD)*.hlr
	-rm $(BUILD)*.inf

.PHONY: all clean
	

