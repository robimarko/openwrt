include $(TOPDIR)/rules.mk

PKG_NAME:=qca-uniphy
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/openwrt/qca-uniphy.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2026-06-06
PKG_SOURCE_VERSION:=c8502826d7f452a76a5d139cbe96b9c6340d5b0c
PKG_MIRROR_HASH:=cb01ac46dd9d5fadb7ae4f41bc1adbf87780d3fa0fc369c0528d44a38773b4f5

PKG_BUILD_PARALLEL:=1
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/qca-uniphy
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Network Devices
  TITLE:=Qualcomm 802.11ax UNIPHY PCS driver
  DEPENDS:=@TARGET_qualcommax
  KCONFIG:=CONFIG_FWNODE_PCS=y
  FILES:=$(PKG_BUILD_DIR)/qca_uniphy.ko
  AUTOLOAD:=$(call AutoLoad,31,qca_uniphy)
endef

define KernelPackage/qca-uniphy/Description
  PCS driver for the UNIPHY SerDes blocks in Qualcomm 802.11ax SoCs.
  Provides PSGMII and SGMII interface modes and registers the UNIPHY
  PLL clock providers needed for port clock muxing.
endef

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		-C "$(LINUX_DIR)" \
		M="$(PKG_BUILD_DIR)" \
		modules
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/qca_uniphy.h $(1)/usr/include/
endef

$(eval $(call KernelPackage,qca-uniphy))
