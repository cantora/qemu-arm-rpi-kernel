
KDIR	= linux
KFLAGS	= ARCH=arm

kernel-qemu-arm.gz: kernel-config $(KDIR)/Makefile
	cp kernel-config $(KDIR)/.config
	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS)
#	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS) INSTALL_MOD_PATH=../modules modules_install
	cp linux/arch/arm/boot/zImage $@

kernel-config: $(KDIR)/.versatile_defconfig
	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS) menuconfig
	mv $(KDIR)/.config $@

$(KDIR)/.versatile_defconfig: $(KDIR)/.patch1
	$(MAKE) $(MFLAGS) -C $(KDIR) $(KFLAGS) versatile_defconfig
	touch $@

$(KDIR)/.patch1: $(KDIR)/Makefile
	patch -p1 -d $(KDIR)/ < linux-arm.patch
	touch $@

$(KDIR)/Makefile:
	git clone https://github.com/raspberrypi/linux.git