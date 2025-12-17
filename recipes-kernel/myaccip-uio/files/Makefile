obj-m += uio_myaccip_noirq.o

KDIR ?= $(KERNEL_SRC)
PWD  := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
modules_install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
