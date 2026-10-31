
TOOLCHAIN := $(OO_PS4_TOOLCHAIN)

TITLE := MATRIX ORDER
TITLE_ID := MTRX00001
VERSION := 01.00

CC := clang++
LD := ld.lld

CXXFLAGS := --target=x86_64-pc-freebsd12-elf -fPIC -funwind-tables \
	-isysroot $(TOOLCHAIN) \
	-isystem $(TOOLCHAIN)/include \
	-isystem $(TOOLCHAIN)/include/c++/v1

LDFLAGS := -m elf_x86_64 -pie \
	--script $(TOOLCHAIN)/link.x \
	--eh-frame-hdr \
	-L$(TOOLCHAIN)/lib \
	-lc -lkernel -lc++ -lSceLibcInternal \
	$(TOOLCHAIN)/lib/crt1.o

all: eboot.bin

main.o: src/main.cpp
	$(CC) $(CXXFLAGS) -c $&lt; -o $@

eboot.bin: main.o
	$(LD) $&lt; -o MATRIX_ORDER.elf $(LDFLAGS)
	$(TOOLCHAIN)/bin/linux/create-fself -in=MATRIX_ORDER.elf -out=MATRIX_ORDER.oelf --eboot eboot.bin --paid 0x3100000000000001

clean:
	rm -f main.o MATRIX_ORDER.elf MATRIX_ORDER.oelf eboot.bin

.PHONY: all clean
