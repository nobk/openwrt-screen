#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=screen-git
PKG_SOURCE_DATE:=2025-05-12
PKG_RELEASE:=3

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.savannah.gnu.org/git/screen.git
PKG_SOURCE_VERSION:=v.5.0.1
PKG_MIRROR_HASH:=e25039a2e5dd67fef30a4cc320088e12c04c68993f6fd82568317ec8b25304a8

PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)/src
PKG_BUILD_PARALLEL:=1

PKG_FIXUP:=autoreconf

PKG_LICENSE:=GPL-3.0+
PKG_LICENSE_FILES:=

include $(INCLUDE_DIR)/package.mk

define Package/screen-git
  SECTION:=utils
  CATEGORY:=Utilities
  SUBMENU:=Terminal
  DEPENDS:=+libncurses
  TITLE:=Full-screen terminal window manager
  URL:=http://www.gnu.org/software/screen/
  MAINTAINER:=Etienne CHAMPETIER <champetier.etienne@gmail.com>
endef

define Package/screen-git/description
	Screen is a full-screen window manager that multiplexes a physical
	terminal between several processes, typically interactive shells.
	screen-git add true color support.
endef

define Build/Prepare
        (cd $(BUILD_DIR) && tar -xf $(DL_DIR)/$(PKG_SOURCE))
endef

define Build/Configure
	( cd $(PKG_BUILD_DIR); ./autogen.sh )
	$(call Build/Configure/Default,\
		--with-sys-screenrc=/etc/screenrc \
		--disable-pam \
	)
	# XXX: memmove() works well with overlapped memory areas
	echo "#define USEMEMMOVE 1" >>$(PKG_BUILD_DIR)/config.h
endef

define Package/screen-git/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/screen $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/etc/screenrc $(1)/etc/screenrc
endef

define Package/screen-git/conffiles
/etc/screenrc
endef

$(eval $(call BuildPackage,screen-git))
