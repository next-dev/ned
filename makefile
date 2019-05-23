NAME=ned

DEBUGFLAGS := --list --c-code-in-asm

CC=zcc

BUILDFLAGS=
INCFLAGS=
LDFLAGS=
CCFLAGS=+zxn -O3 -clib=new

CCLINKFLAGS=$(CCFLAGS) -startup=31

CCC1=$(CC) $(CCFLAGS) $(DEBUGFLAGS) $(INCFLAGS)
CCC2=$(CC) $(CCLINKFLAGS) $(DEBUGFLAGS) $(LDFLAGS) $(BUILDFLAGS) -Cz"--clean --fullsize --main-fence 0xc000"

OBJ=ned.o video.o keyboard.o

%.o: src/%.c
	$(CCC1) -c -o $@ $< -subtype=nex

ned.nex: $(OBJ)
	$(CCC2) $^ -o $@ -subtype=nex -create-app

clean:
	rm -f *.o *.bin *.nex zcc_opt.def *.lis src/*.lis



