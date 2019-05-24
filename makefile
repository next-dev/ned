NAME=ned

DEBUGFLAGS := --list --c-code-in-asm

# Compiler set up

CC=zcc

BUILDFLAGS=
INCFLAGS=
LDFLAGS=
CCFLAGS=+zxn -vn -O3 -clib=new -Isrc

CCLINKFLAGS=$(CCFLAGS) -startup=31

CCC1=$(CC) $(CCFLAGS) $(DEBUGFLAGS) $(INCFLAGS)
CCC2=$(CC) $(CCLINKFLAGS) $(DEBUGFLAGS) $(LDFLAGS) $(BUILDFLAGS) -Cz"--clean --fullsize --main-fence 0xc000"

# Source set up

ODIR = obj

_DEPS = ned.h
_OBJ = ned.o video.o keyboard.o

DEPS = $(patsubst %,src/%,$(_DEPS))
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

ned.nex: $(OBJ)
	$(CCC2) $^ -o ned -pragma-include:src/zpragma.inc -subtype=nex -create-app

$(ODIR):
	mkdir $(ODIR)

$(ODIR)/%.o: src/%.c $(DEPS) $(ODIR)
	$(CCC1) -c -o $@ $<

$(ODIR)/%.o: src/%.asm $(ODIR)
	$(CCC1) -c -o $@ $<

.PHONY: clean

clean:
	rm -f *.o *.bin *.nex zcc_opt.def *.lis src/*.lis
	rm -rf $(ODIR)


