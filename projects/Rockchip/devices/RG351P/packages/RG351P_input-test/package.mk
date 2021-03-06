# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2020 british-choi (https://github.com/british-choi)

PKG_NAME="RG351P_input-test"
PKG_VERSION="7ab819f1e7a3013fc0529fb79cea04923f2713dc"
PKG_SHA256="85631208ac5068dbd12e0ea2e7c4c3fc0b07328c4bd4c270255dfececb906546"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/lualiliu/RG351P_input-test"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2-git SDL2_ttf"
PKG_LONGDESC="Anbernic RG351P Input Tester"
PKG_TOOLCHAIN="make"

pre_configure_target() {
    sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|" Makefile
}

makeinstall_target() {
    mkdir -p $INSTALL/usr/bin
    cp -rf input-test-sdl-2 $INSTALL/usr/bin
}

