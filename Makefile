# Unicorn Emulator Engine
# By Dang Hoang Vu <dang.hvu -at- gmail.com>, 2015
# Edit by microwave89-hv, 2/2021

.PHONY: full clean all validate

LIBNAME = unicorn

UC_GET_OBJ = $(shell for i in \
    $$(grep '$(1)' $(2) | \
    grep '\.o' | cut -d '=' -f 2); do \
    echo $$i | grep '\.o' > /dev/null 2>&1; \
    if [ $$? = 0 ]; then \
    echo '$(3)'$$i; \
    fi; done; echo)

# This has effect when linking, w/o these there's undefined symbols.
UC_TARGET_OBJ = $(filter-out qemu/../%,$(call UC_GET_OBJ,obj-,qemu/Makefile.objs, qemu/))
UC_TARGET_OBJ += $(call UC_GET_OBJ,obj-,qemu/hw/core/Makefile.objs, qemu/hw/core/)
UC_TARGET_OBJ += $(call UC_GET_OBJ,obj-,qemu/qapi/Makefile.objs, qemu/qapi/)
UC_TARGET_OBJ += $(call UC_GET_OBJ,obj-,qemu/qobject/Makefile.objs, qemu/qobject/)
UC_TARGET_OBJ += $(call UC_GET_OBJ,obj-,qemu/qom/Makefile.objs, qemu/qom/)
UC_TARGET_OBJ += $(call UC_GET_OBJ,obj-y,qemu/util/Makefile.objs, qemu/util/)
UC_TARGET_OBJ += $(call UC_GET_OBJ,obj-$$(CONFIG_POSIX),qemu/util/Makefile.objs, qemu/util/)

UC_TARGET_OBJ_X86 = $(call UC_GET_OBJ,obj-,qemu/Makefile.target, qemu/x86_64-softmmu/)
UC_TARGET_OBJ_X86 += $(call UC_GET_OBJ,obj-,qemu/hw/i386/Makefile.objs, qemu/x86_64-softmmu/hw/i386/)
UC_TARGET_OBJ_X86 += $(call UC_GET_OBJ,obj-,qemu/hw/intc/Makefile.objs, qemu/x86_64-softmmu/hw/intc/)
UC_TARGET_OBJ_X86 += $(call UC_GET_OBJ,obj-,qemu/target-i386/Makefile.objs, qemu/x86_64-softmmu/target-i386/)

UC_TARGET_OBJ += $(UC_TARGET_OBJ_X86)
UC_OBJ_ALL = $(UC_TARGET_OBJ) list.o uc.o

# Apple
LIBRARY = lib$(LIBNAME).dylib
LIBDIR = /usr/local/lib
$(LIBNAME)_LDFLAGS += -dynamiclib -install_name @rpath/$(LIBRARY) -lm

uc.o: qemu/config-host.mak
	$(MAKE) -C qemu -j4

$(UC_TARGET_OBJ) list.o: uc.o
	@echo "--- $^ $@" > /dev/null

$(LIBRARY): $(UC_OBJ_ALL)
	$(CC) -g -shared $(UC_OBJ_ALL) -o $(LIBRARY) $($(LIBNAME)_LDFLAGS)

full: clean all validate

clean:
	find . -type f -name '*.o' -print -delete
	find . -type f -name '*.dylib' -print -delete
	rm -rf $(LIBDIR)/lib$(LIBNAME).*

all: $(LIBRARY)
	install -m0755 $(LIBRARY) $(LIBDIR)
	
validate:
	$(MAKE) -C samples
	find . -type f -name '*.dylib' -print -delete # Force it use the official lib in $(LIBDIR)
	./samples/sample_all.sh
