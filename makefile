NAME=ned

DEBUGFLAGS := --list --c-code-in-asm

# Compiler set up

CC=zcc

BUILDFLAGS=
INCFLAGS=-Isrc
LDFLAGS=

# SCCZ80 compiler
#CCFLAGS=+zxn -vn -O3 -clib=new

# ZSDCC compiler (optimising one)
CCFLAGS=+zxn -vn -clib=sdcc_iy -SO3 --opt-code-size --max-allocs-per-node200000

CCLINKFLAGS=$(CCFLAGS) -startup=31

CCC1=$(CC) $(CCFLAGS) $(DEBUGFLAGS) $(INCFLAGS)
CCC2=$(CC) $(CCLINKFLAGS) $(DEBUGFLAGS) $(LDFLAGS) $(BUILDFLAGS) -Cz"--clean --fullsize"

# Source set up

ODIR = obj

_DEPS = ned.h
_OBJ = ned.o video.o keyboard.o font.o display.o data.o memory.o

DEPS = $(patsubst %,src/%,$(_DEPS))
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

ned.nex: $(ODIR) $(OBJ)
	$(CCC2) $(OBJ) -o ned -pragma-include:src/zpragma.inc -subtype=nex -create-app
	bin/hdfmonkey put \sdcard\cspect-next-2gb.img ned.nex

$(ODIR)/%.o: src/%.c $(DEPS)
	$(CCC1) -c -o $@ $<

$(ODIR)/%.o: src/%.asm
	$(CCC1) -c -o $@ $<

.PHONY: clean

clean:
	rm -f *.o *.bin *.nex zcc_opt.def *.lis src/*.lis
	rm -rf $(ODIR)

$(ODIR):
	mkdir $(ODIR)


