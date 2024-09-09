#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=screen-git
PKG_SOURCE_DATE:=2024-08-28
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.savannah.gnu.org/git/screen.git
PKG_SOURCE_VERSION:=9d8b0ff3901bdcb8d3bc05d94fce2ef987562768
PKG_MIRROR_HASH:=39510b743c02571413a1138d2fd0c4cfff1093aeb68badd7f54814cde9073444

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
