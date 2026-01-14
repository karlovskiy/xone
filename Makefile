KERNEL_DIR ?= /lib/modules/$(shell uname -r)/build
ifeq ($(findstring j,$(MAKEFLAGS)),)
	MAKEFLAGS += -j$(shell nproc)
endif

default: clean
	$(MAKE) -C $(KERNEL_DIR) M=$$PWD

debug: clean
	$(MAKE) -C $(KERNEL_DIR) M=$$PWD ccflags-y="-Og -g3 -DDEBUG"

clean:
	$(MAKE) -C $(KERNEL_DIR) M=$$PWD clean

unload:
	./modules_load.sh unload

load: unload
	./modules_load.sh

test:
	$(MAKE) debug &&\
		$(MAKE) load
	$(MAKE) clean

remove: clean
	./uninstall.sh

install: clean
	./install.sh
	./install/firmware.sh --skip-disclaimer

install-debug: clean
	./install.sh --debug
	./install/firmware.sh --skip-disclaimer
