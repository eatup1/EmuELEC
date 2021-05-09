# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="evtest"
PKG_VERSION="1.34"
PKG_SHA256="f8a2a790e0116979e6fd64d933e20ab067bc48aa70f2416834e05cfe11ed5a32"
PKG_LICENSE="GPL"
PKG_SITE="http://cgit.freedesktop.org/evtest/"
PKG_URL="https://gitlab.freedesktop.org/libevdev/evtest/-/archive/master/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxml2"
PKG_LONGDESC="A simple tool for input event debugging."
PKG_TOOLCHAIN="autotools"

#makeinstall_target() {
#  : # nop
#}
