# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="evtest"
PKG_VERSION="1.34"
PKG_SHA256="4c24427792393d6b68fe4010513c6dbb606dd6eb3cea5c2b8c9eb705551cb50a"
PKG_LICENSE="GPL"
PKG_SITE="http://cgit.freedesktop.org/evtest/"
PKG_URL="https://gitlab.freedesktop.org/libevdev/evtest/-/archive/master/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libxml2"
PKG_LONGDESC="A simple tool for input event debugging."
PKG_TOOLCHAIN="autotools"

#makeinstall_target() {
#  : # nop
#}
