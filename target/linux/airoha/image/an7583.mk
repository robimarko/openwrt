define Build/an7583-preloader
  $(STAGING_DIR_HOST)/bin/fiptool create \
		--tb-fw $(STAGING_DIR_IMAGE)/an7583-bl2.bin \
		$(STAGING_DIR_IMAGE)/an7583_$1-bl2.fip
  cat $(STAGING_DIR_IMAGE)/an7583_$1-bl2.fip >> $@
endef

define Build/an7583-bl31-uboot
  $(STAGING_DIR_HOST)/bin/fiptool create \
		--soc-fw $(STAGING_DIR_IMAGE)/an7583-bl31.lzma \
		--nt-fw $(STAGING_DIR_IMAGE)/an7583_$1-u-boot.lzma \
		$(STAGING_DIR_IMAGE)/an7583_$1-bl31-u-boot.fip
  cat $(STAGING_DIR_IMAGE)/an7583_$1-bl31-u-boot.fip >> $@
endef

define Build/an7583-gpt-emmc
	ptgen -g -o $@.tmp -e 576k -u 2k -D -l 1024 \
			-t 0x83 -N bl2    -r  -p 126k@2k \
			-t 0x83 -N bl31  	-r  -p 368k@128k \
			-t 0x83 -N ubootenv -r -p 64k@496k \
			-t 0x2e -N production -p $(CONFIG_TARGET_ROOTFS_PARTSIZE)M@1M
	dd if=$@.tmp of=$@ bs=512 count=2 conv=notrunc
	dd if=$@.tmp of=$@ bs=512 skip=1152 seek=1152 count=32 conv=notrunc
	rm $@.tmp
endef

define Device/FitImageLzma
  KERNEL_SUFFIX := -uImage.itb
  KERNEL = kernel-bin | lzma | \
	fit lzma $$(KDIR)/image-$$(DEVICE_DTS).dtb
  KERNEL_NAME := Image
endef

define Device/airoha_an7583-evb
  $(call Device/FitImageLzma)
  DEVICE_VENDOR := Airoha
  DEVICE_MODEL := AN7583 Evaluation Board (SNAND)
  DEVICE_PACKAGES := aeonsemi-as21xxx-firmware kmod-leds-pwm \
	kmod-pwm-airoha kmod-input-gpio-keys-polled
  DEVICE_DTS := an7583-evb
  DEVICE_DTS_CONFIG := config@1
  IMAGE/sysupgrade.bin := append-kernel | pad-to 128k | append-rootfs | \
	pad-rootfs | append-metadata
  ARTIFACT/preloader.bin := an7583-preloader rfb
  ARTIFACT/bl31-uboot.fip := an7583-bl31-uboot rfb
  ARTIFACTS := preloader.bin bl31-uboot.fip
endef
TARGET_DEVICES += airoha_an7583-evb

define Device/airoha_an7583-evb-emmc
  DEVICE_VENDOR := Airoha
  DEVICE_MODEL := AN7583 Evaluation Board (EMMC)
  DEVICE_DTS := an7583-evb-emmc
  DEVICE_PACKAGES := kmod-phy-airoha-en8811h
  ARTIFACT/preloader.bin := an7583-preloader rfb
  ARTIFACT/bl31-uboot.fip := an7583-bl31-uboot rfb
  ARTIFACTS := preloader.bin bl31-uboot.fip
endef
TARGET_DEVICES += airoha_an7583-evb-emmc

define Device/datamate_nanoDPU
  DEVICE_VENDOR := Datamate
  DEVICE_MODEL := NanoDPU
  DEVICE_DTS := an7583-nanoDPU
  DEVICE_PACKAGES := fitblk e2fsprogs kmod-hwmon-lm75 kmod-sfp
  KERNEL := kernel-bin | gzip
  KERNEL_INITRAMFS := kernel-bin | lzma | \
	fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd
ifeq ($(DUMP),)
  IMAGE_SIZE := $$(shell expr 1 + $$(CONFIG_TARGET_ROOTFS_PARTSIZE))m
endif
  ARTIFACT/preloader.bin := an7583-preloader rfb
  ARTIFACT/bl31-uboot.fip := an7583-bl31-uboot datamate_nanoDPU
  ARTIFACTS := preloader.bin bl31-uboot.fip emmc-factory.img
  IMAGES := sysupgrade.itb
  IMAGE/sysupgrade.itb := append-kernel | \
	fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb \
		external-static-with-rootfs | \
	pad-rootfs | append-metadata
  ARTIFACT/emmc-factory.img := pad-extra 2k | an7583-preloader rfb |\
		pad-to 128k | an7583-bl31-uboot datamate_nanoDPU |\
		an7583-gpt-emmc | pad-to 1M |\
		append-image squashfs-sysupgrade.itb | check-size
endef
TARGET_DEVICES += datamate_nanoDPU

define Device/nokia_xg-040g-mf-common
  $(call Device/FitImageLzma)
  DEVICE_VENDOR := Nokia
  DEVICE_MODEL := XG-040G-MF
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  UBINIZE_OPTS := -E 5
  DEVICE_PACKAGES := kmod-phy-airoha-en8811h \
	kmod-regulator-userspace-consumer kmod-usb-ledtrig-usbport
endef

define Device/nokia_xg-040g-mf
  $(call Device/nokia_xg-040g-mf-common)
  DEVICE_DTS := an7583-nokia_xg-040g-mf
  DEVICE_DTS_CONFIG := config@1
  IMAGE_SIZE := 131968k
  KERNEL_SIZE := 8192k
  IMAGES += factory-kernel.bin factory-rootfs.bin
  IMAGE/factory-kernel.bin := append-kernel
  IMAGE/factory-rootfs.bin := append-ubi | check-size
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += nokia_xg-040g-mf

define Device/nokia_xg-040g-mf-ubi
  $(call Device/nokia_xg-040g-mf-common)
  DEVICE_VARIANT := (UBI)
  DEVICE_DTS := an7583-nokia_xg-040g-mf-ubi
  UBOOTENV_IN_UBI := 1
  KERNEL_IN_UBI := 1
  KERNEL := kernel-bin | gzip
  KERNEL_INITRAMFS := kernel-bin | lzma | \
	fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd | pad-to 128k
  KERNEL_INITRAMFS_SUFFIX := -recovery.itb
  IMAGES := sysupgrade.itb
  IMAGE/sysupgrade.itb := append-kernel | \
	fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb external-static-with-rootfs | \
	append-metadata
  DEVICE_PACKAGES += fitblk
  ARTIFACT/bl31-uboot.fip := an7583-bl31-uboot nokia_xg-040g-mf
  ARTIFACT/preloader.bin := an7583-preloader nokia_xg-040g-mf
  ARTIFACTS := bl31-uboot.fip preloader.bin
endef
TARGET_DEVICES += nokia_xg-040g-mf-ubi
