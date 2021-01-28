# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="TvTextViewer"
PKG_VERSION="7ec1a186d46e0c596594c420fae1b52f456ded69"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/lethal-guitar/TvTextViewer"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_SHORTDESC="Full-screen text viewer tool with gamepad controls"
PKG_TOOLCHAIN="make"

pre_configure_target() {
sed -i "s|sdl2-config|$SYSROOT_PREFIX/usr/bin/sdl2-config|g" Makefile
}

makeinstall_target(){
mkdir -p $INSTALL/usr/bin
cp text_viewer $INSTALL/usr/bin
}
