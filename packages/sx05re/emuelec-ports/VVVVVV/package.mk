# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="VVVVVV"
PKG_VERSION="6fffa5c11d006fbdd0154dc3b8c19045dcae916c"
PKG_SHA256="df712b9c0b8ad97a03cf7371c77227edf2221131bdfbd946f8dcf470f4639036"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="CUSTOM"
PKG_SITE="https://github.com/TerryCavanagh/VVVVVV"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_mixer"
PKG_SHORTDESC="VVVVVV License: https://github.com/TerryCavanagh/VVVVVV/blob/master/LICENSE.md"
PKG_LONGDESC="VVVVVV is a platform game all about exploring one simple mechanical idea - what if you reversed gravity instead of jumping?"
PKG_TOOLCHAIN="cmake"

if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
PKG_PATCH_DIRS="OdroidGoAdvance"
fi

PKG_CMAKE_OPTS_TARGET=" desktop_version"

pre_configure_target() {
sed -i "s/fullscreen = false/fullscreen = true/" "$PKG_BUILD/desktop_version/src/Screen.cpp"
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp VVVVVV $INSTALL/usr/bin
}
