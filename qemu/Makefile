# Makefile for QEMU - modified for Unicorn engine.

# Always point to the root of the build tree (needs GNU make).
BUILD_DIR=$(CURDIR)

# Put the all: rule here so that config-host.mak can contain dependencies.
all:
extra_cflags=-m64 -DUNICORN_HAS_X86 -fPIC -fvisibility=hidden
extra_ldflags=
ARCH=x86_64
STRIP=strip
CONFIG_POSIX=y
SRC_PATH=.
TARGET_DIRS=x86_64-softmmu
CONFIG_BSD=y
CONFIG_CPUID_H=y
CONFIG_INT128=y
MAKE=make
CC=cc
CC_I386=$(CC) -m32
HOST_CC=cc
OBJCC=clang
AR=ar
ARFLAGS=rv
AS=as
CPP=cc -E
OBJCOPY=objcopy
LD=ld
NM=nm
CFLAGS=-g 
CFLAGS_NOPIE=
QEMU_CFLAGS=-m64 -DOS_OBJECT_USE_OBJC=0 -arch x86_64 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wall -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -DUNICORN_HAS_X86 -fPIC -fvisibility=hidden  -Wno-string-plus-int -Wno-initializer-overrides -Wendif-labels -Wmissing-include-dirs -Wempty-body -Wnested-externs -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wold-style-definition -Wtype-limits -fstack-protector-strong
QEMU_INCLUDES=-I$(SRC_PATH)/tcg -I$(SRC_PATH)/tcg/i386 -I. -I$(SRC_PATH) -I$(SRC_PATH)/include
LDFLAGS=-m64 -arch x86_64 -g 
LDFLAGS_NOPIE=
LIBS+=
EXESUF=
DSOSUF=.so
LDFLAGS_SHARED=-bundle -undefined dynamic_lookup
TRANSLATE_OPT_CFLAGS=

CONFIG_SOFTMMU := $(if $(filter %-softmmu,$(TARGET_DIRS)),y)
-include config-all-devices.mak

include $(SRC_PATH)/rules.mak

GENERATED_HEADERS = config-host.h

# Don't try to regenerate Makefile or configure
# We don't generate any of them
Makefile: ;
configure: ;

.PHONY: all clean distclean recurse-all

$(call set-vpath, $(SRC_PATH))

SUBDIR_MAKEFLAGS=$(if $(V),,--no-print-directory) BUILD_DIR=$(BUILD_DIR)
SUBDIR_DEVICES_MAK=$(patsubst %, %/config-devices.mak, $(TARGET_DIRS))
SUBDIR_DEVICES_MAK_DEP=$(patsubst %, %-config-devices.mak.d, $(TARGET_DIRS))

-include $(SUBDIR_DEVICES_MAK_DEP)

%/config-devices.mak: default-configs/%.mak
	$(call quiet-command, cp $< $@, "  GEN   $@")

ifneq ($(wildcard config-host.mak),)
include $(SRC_PATH)/Makefile.objs
endif

dummy := $(call unnest-vars,,util-obj-y common-obj-y)

all: recurse-all

config-host.h: config-host.h-timestamp
config-host.h-timestamp: config-host.mak

SUBDIR_RULES=$(patsubst %,subdir-%, $(TARGET_DIRS))
SOFTMMU_SUBDIR_RULES=$(filter %-softmmu,$(SUBDIR_RULES))

$(SOFTMMU_SUBDIR_RULES): config-all-devices.mak

subdir-%:
	$(call quiet-command,$(MAKE) $(SUBDIR_MAKEFLAGS) -C $* V="$(V)" TARGET_DIR="$*/" all,)

$(SUBDIR_RULES): qapi-types.c qapi-types.h qapi-visit.c qapi-visit.h $(common-obj-y) $(util-obj-y)

recurse-all: $(SUBDIR_RULES)

######################################################################

clean:
	find . \( -name '*.l[oa]' -o -name '*.so' -o -name '*.dll' -o -name '*.mo' -o -name '*.[oda]' \) -type f -exec rm {} +
	rm -f TAGS *~ */*~
	@# May not be present in GENERATED_HEADERS
	rm -f $(foreach f,$(GENERATED_HEADERS),$(f) $(f)-timestamp)
	for d in $(TARGET_DIRS); do \
	if test -d $$d; then $(MAKE) -C $$d $@ || exit 1; fi; \
        done

distclean: clean
	rm -f config-host.mak config-host.h*
	rm -f config-all-devices.mak
	rm -f config.log config.status
	for d in $(TARGET_DIRS); do \
	rm -rf $$d || exit 1 ; \
        done


# Add a dependency on the generated files, so that they are always
# rebuilt before other object files
ifneq ($(filter-out %clean,$(MAKECMDGOALS)),$(if $(MAKECMDGOALS),,fail))
Makefile: $(GENERATED_HEADERS)
endif

