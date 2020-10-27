# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Youngjun, Choi (https://github.com/british-choi)

PKG_NAME="hangul-fonts-ttf"
PKG_VERSION=""
PKG_LICENSE="OFL1_1"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"

makeinstall_target() {

  mkdir -p $INSTALL/usr/share/fonts/hangul
    cp *.ttf $INSTALL/usr/share/fonts/hangul

}
