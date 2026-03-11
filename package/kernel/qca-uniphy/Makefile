include $(TOPDIR)/rules.mk

PKG_NAME:=qca-uniphy
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/openwrt/qca-uniphy.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2026-06-05
PKG_SOURCE_VERSION:=e91b4f0db2e7a55f091b7f281569d7314d7e6c76
PKG_MIRROR_HASH:=a30b9c534015502769ce5825cf915404f23cef7eae2e9239ce954a830d601beb

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
