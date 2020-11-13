#
# Copyright (C) 2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ath11k-firmware
PKG_SOURCE_DATE:=2020-11-11
PKG_SOURCE_VERSION:=45a6c45a19799d3b06fc2287d5ba44e19ee0aa00
PKG_MIRROR_HASH:=eec4edf31619f4a35e3d7e4a6c237ebed22af3f8c31221760b3a7220c7c9b0e7
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/kvalo/ath11k-firmware.git

PKG_MAINTAINER:=Robert Marko <robert.marko@sartura.hr>

include $(INCLUDE_DIR)/package.mk

define Package/ath11k-firmware-default
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=$(PKG_SOURCE_URL)
  DEPENDS:=
endef

define Package/ath11k-firmware-ipq6018
$(Package/ath11k-firmware-default)
  TITLE:=ath11k firmware for IPQ6018 devices
  SECTION:=firmware
  CATEGORY:=Firmware
endef

define Package/ath11k-firmware-ipq8074
$(Package/ath11k-firmware-default)
  TITLE:=ath11k firmware for IPQ8074 devices
  SECTION:=firmware
  CATEGORY:=Firmware
endef

define Package/ath11k-firmware-qca6390
$(Package/ath11k-firmware-default)
  TITLE:=ath11k firmware for QCA6390 devices
  SECTION:=firmware
  CATEGORY:=Firmware
endef

define Package/ath11k-firmware-qcn9074
$(Package/ath11k-firmware-default)
  TITLE:=ath11k firmware for QCN9074 devices
  SECTION:=firmware
  CATEGORY:=Firmware
endef

define Build/Compile

endef

define Package/ath11k-firmware-ipq6018/install
	$(INSTALL_DIR) $(1)/lib/firmware/IPQ6018
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/IPQ6018/hw1.0/board-2.bin \
		$(1)/lib/firmware/IPQ6018/
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/IPQ6018/hw1.0/testing/2.4.0.1.r1/WLAN.HK.2.4.0.1.r1-00019-QCAHKSWPL_SILICONZ-1/* \
		$(1)/lib/firmware/IPQ6018
endef

define Package/ath11k-firmware-ipq8074/install
	$(INSTALL_DIR) $(1)/lib/firmware/IPQ8074
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/IPQ8074/hw2.0/board-2.bin \
		$(1)/lib/firmware/IPQ8074/
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/IPQ8074/hw2.0/testing/2.5.0.1.r1/WLAN.HK.2.5.0.1.r1-00004-QCAHKSWPL_SILICONZ-1/* \
		$(1)/lib/firmware/IPQ8074
endef

define Package/ath11k-firmware-qca6390/install
	$(INSTALL_DIR) $(1)/lib/firmware/QCA6390
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/QCA6390/hw2.0/board-2.bin \
		$(1)/lib/firmware/QCA6390/
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/QCA6390/hw2.0/1.0.1/WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1/* \
		$(1)/lib/firmware/QCA6390
endef

define Package/ath11k-firmware-qcn9074/install
	$(INSTALL_DIR) $(1)/lib/firmware/QCN9074
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/QCN9074/hw1.0/testing/2.4.0.1.r1/WLAN.HK.2.4.0.1.r1-00034-QCAHKSWPL_SILICONZ-1/* \
		$(1)/lib/firmware/QCN9074
endef

$(eval $(call BuildPackage,ath11k-firmware-ipq6018))
$(eval $(call BuildPackage,ath11k-firmware-ipq8074))
$(eval $(call BuildPackage,ath11k-firmware-qca6390))
$(eval $(call BuildPackage,ath11k-firmware-qcn9074))
