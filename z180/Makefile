BUILD=./build
HOSTFS=~/hostfs/romsz180
SSD=$(BUILD)/z180first.ssd

X:=$(shell mkdir -p $(BUILD))

#asz80 is an ashat and creates a file when there's an error and pisses around
#with the filename so you can't bloody rename it easily
.DELETE_ON_ERROR:

all:: 
	make -C mos all

ssd:: all
	dfs form -80 $(SSD)
	dfs title $(SSD) "romsz180"
	dfs add $(SSD) mos/build/*.inf
	dfs opt4 -3 $(SSD)

hostfs:: ssd
	mkdir -p $(HOSTFS)
	dfs read -i -d $(HOSTFS) $(SSD)

