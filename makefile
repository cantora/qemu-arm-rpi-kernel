
KDIR	= linux
KFLAGS	= ARCH=arm

kernel-qemu-arm.gz: kernel-config $(KDIR)/.patch1
	cp kernel-config $(KDIR)/.config
	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS)
#	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS) INSTALL_MOD_PATH=../modules modules_install
	cp linux/arch/arm/boot/zImage $@

new-kernel-config: $(KDIR)/.versatile_defconfig
	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS) menuconfig

$(KDIR)/.versatile_defconfig: $(KDIR)/.patch1
	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS) versatile_defconfig
	touch $@

$(KDIR)/.patch1: $(KDIR)/Makefile
	patch -p1 -d $(KDIR)/ < linux-arm.patch
	touch $@

$(KDIR)/Makefile:
	git clone https://github.com/raspberrypi/linux.git

.PHONY: install
install: kernel-qemu-arm.gz
	cp -fsv $(CURDIR)/$< $(HOME)/qemu/kernels/qemu-rpi.gz

clean:
	rm -f kernel-qemu-arm.gz
	rm -rf ./modules/lib
	rm -rf ./linux

