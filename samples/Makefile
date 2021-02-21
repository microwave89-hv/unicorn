# Unicorn Engine
# By Nguyen Anh Quynh <aquynh@gmail.com>, 2015
# Edit by microwave89-hv, 2/2021

CFLAGS += -Wall -Werror -I../include
LDFLAGS += -lunicorn -lpthread -lm

.PHONY: all clean

SOURCES =
SOURCES += sample_x86.c
SOURCES += shellcode.c
SOURCES += mem_apis.c
SOURCES += sample_x86_32_gdt_and_seg_regs.c
SOURCES += sample_batch_reg.c

BINS = $(SOURCES:.c=$(BIN_EXT))
OBJS = $(SOURCES:.c=.o)

all: $(BINS)

$(BINS): $(OBJS)

clean:		
	rm -rf *.o $(BINS)

% : %.o
	$(CC) $< ${CFLAGS} $(LDFLAGS) -o $@

%.o: %.c
	${CC} ${CFLAGS} -c $< -o $@
