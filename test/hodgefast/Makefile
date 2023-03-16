AS=asz80
ASFLAGS=-ols
LD=aslink
LDFLAGS=-u
BUILD=./build/
TARGETS=hodgefast.ihx
OBJS=hodgefast.rel
OBJS2=$(addprefix $(BUILD),$(OBJS))

DEPS=

X:=$(shell mkdir -p $(BUILD))

all:: $(addprefix $(BUILD),$(TARGETS))


$(BUILD)%.rel: %.asm $(DEPS)
	$(AS) $(ASFLAGS) $@ $<

$(BUILD)%.ihx: $(OBJS2) %.lnk
	$(LD) $(LDFLAGS) -f $(basename $(notdir $@))

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
	

