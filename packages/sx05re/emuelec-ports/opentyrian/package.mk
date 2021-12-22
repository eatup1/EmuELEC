# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="opentyrian"
PKG_VERSION="717e5b4984a01a432f7d75330d5ae459e0c53b51"
PKG_SHA256="94c6399f372ef51d659ff6b027d4b993dd6b7e8099909c46ab49ffc09bf71900"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/opentyrian/opentyrian"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_LONGDESC="An open-source port of the DOS shoot-em-up Tyrian."
PKG_TOOLCHAIN="make"

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp opentyrian $INSTALL/usr/bin
  
  mkdir -p $INSTALL/usr/config/opentyrian
  cp -r $PKG_DIR/config/* $INSTALL/usr/config/opentyrian
}
