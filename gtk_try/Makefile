CC = gcc
LD = gcc
NASM = nasm 

CFLAGS =  -c `pkg-config --cflags --libs gtk+-2.0`
LFLAGS = `pkg-config --cflags --libs gtk+-2.0`
NASMFLAGS = -f elf64

C_PROG = image_viewer
ASM_PROG = fun

OBJS = $(C_PROG).o $(ASM_PROG).o


default: $(C_PROG)

$(C_PROG): $(OBJS) 
	$(LD) $(OBJS) $(LFLAGS) -o $(C_PROG)

$(ASM_PROG).o: $(ASM_PROG).asm
	$(NASM) $(NASMFLAGS) $(ASM_PROG).asm

$(C_PROG).o: $(C_PROG).c 
	$(CC) $(CFLAGS) $(C_PROG).c

clean:
	rm -rf *.o *~

real_clean:
	 rm -rf *.o $(C_PROG) *~