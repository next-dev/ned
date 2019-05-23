NAME=ned

DEBUGFLAGS := --list --c-code-in-asm

CC=zcc

BUILDFLAGS=
INCFLAGS=
LDFLAGS=
CCFLAGS=+zxn -vn -O3 -startup=31 -clib=new

CCLINKFLAGS=$(CCFLAGS)

CCC1=$(CC) $(CCFLAGS) $(DEBUG) $(INCFLAGS)
CCC2=$(CC) $(CCLINKFLAGS) $(DEBUG) $(LDFLAGS) $(BUILDFLAGS) -Cz"--clean --fullsize --main-fence 0xc000"

OBJ=ned.o video.o keyboard.o

%.o: src/%.c
	$(CCC1) -c -o$@ $<

ned.nex: $(OBJ)
	$(CCC2) $^ -o $@ -subtype=nex -create-app

clean:
	rm -f *.o *.bin *.nex zcc_opt.def



