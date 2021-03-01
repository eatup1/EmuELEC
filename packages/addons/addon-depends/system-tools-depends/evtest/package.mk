# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="evtest"
PKG_VERSION="1.34"
PKG_SHA256="abc8439f41a73b09543fe2474a78a819a386d92d9aabf33b67ccbad8a8b09fd4"
PKG_LICENSE="GPL"
PKG_SITE="http://cgit.freedesktop.org/evtest/"
PKG_URL="https://gitlab.freedesktop.org/libevdev/evtest/-/archive/master/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxml2"
PKG_LONGDESC="A simple tool for input event debugging."
PKG_TOOLCHAIN="autotools"

#makeinstall_target() {
#  : # nop
#}
