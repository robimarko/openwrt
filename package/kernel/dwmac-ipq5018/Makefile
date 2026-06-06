include $(TOPDIR)/rules.mk

PKG_NAME:=dwmac-ipq5018
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/openwrt/dwmac-ipq5018.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2026-06-06
PKG_SOURCE_VERSION:=a8b2e0e7883812c0959bd7ac45193c9d53d9b7a6
PKG_MIRROR_HASH:=8cf208378925af6d0c48332fccb8010b550f54f300630b7686518158dd4d27df

PKG_BUILD_PARALLEL:=1
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/dwmac-ipq5018
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Network Devices
  TITLE:=Qualcomm IPQ5018 DWMAC driver
  DEPENDS:=@TARGET_qualcommax_ipq50xx +kmod-stmmac-core +kmod-qca-uniphy
  FILES:=$(PKG_BUILD_DIR)/dwmac-ipq5018.ko
  AUTOLOAD:=$(call AutoLoad,34,dwmac-ipq5018)
endef

EXTRA_CFLAGS:= \
  -I$(LINUX_DIR)/drivers/net/ethernet/stmicro/stmmac

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		-C "$(LINUX_DIR)" \
		M="$(PKG_BUILD_DIR)" \
    ccflags-y="$(EXTRA_CFLAGS)" \
		modules
endef

$(eval $(call KernelPackage,dwmac-ipq5018))
