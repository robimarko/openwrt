include $(TOPDIR)/rules.mk

PKG_NAME:=qca-edma
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/openwrt/qca-edma.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2026-05-17
PKG_SOURCE_VERSION:=c2071ae5682271ada0a7f025679edac9c67050b7
PKG_MIRROR_HASH:=bab18f1226edaa6ab10bb04eff0d805e4b74776234ff85d85a38a347bc3b3c9a

PKG_BUILD_PARALLEL:=1
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/qca-edma
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Network Devices
  DEPENDS:=@TARGET_qualcommax +kmod-qca-ppe +kmod-qca-uniphy
  TITLE:=Qualcom NSS dataplane ethernet driver
  FILES:=$(PKG_BUILD_DIR)/qca_edma.ko
  AUTOLOAD:=$(call AutoLoad,31,qca_edma)
endef

define KernelPackage/qca-edma/Description
  NSS dataplane ethernet driver for Qualcom SoCs.
endef

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		-C "$(LINUX_DIR)" \
		M="$(PKG_BUILD_DIR)" \
		modules
endef

$(eval $(call KernelPackage,qca-edma))
