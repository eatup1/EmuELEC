# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="rs97-commander-sdl2-ogs"
PKG_VERSION="30a9f6a588d220ac233b4c02c8c55fb1e24aeeeb"
PKG_SHA256="441aa06ca35ac0e56cfbfa45522832f50794f2f95475305ce3dddc6100e6693d"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/EmuELEC/rs97-commander-sdl2"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2_image SDL2_gfx"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Two-pane commander for RetroFW and RG-350 (fork of Dingux Commander)"

pre_configure_target() {
sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|" Makefile
sed -i "s|CC=g++|CC=${CXX}|" Makefile

# change for korean font
sed -i "s|SCREENW := 480|SCREENW := 854|" Makefile
sed -i "s|SCREENH := 320|SCREENH := 480|" Makefile
sed -i "s|FONTSIZE := 8|FONTSIZE := 12|" Makefile
sed -i "s|HEADERH := 17|HEADERH := 21|" Makefile
sed -i "s|FOOTERH := 13|FOOTERH := 17|" Makefile
sed -i "s|LINEH := 15|LINEH := 19|" Makefile
sed -i "s|VIEWER_LINE_H := 13|VIEWER_LINE_H := 17|" Makefile
sed -i "s|Fiery_Turk.ttf|NanumGothic.ttf|" Makefile

OGA=0

if [[ "$DEVICE" == "OdroidGoAdvance" || "$DEVICE" == "RG351P" || "$DEVICE" == "GameForce" ]]; then
	OGA=1
fi

PKG_MAKE_OPTS_TARGET=" ODROIDGO=${OGA} CC=$CXX"
	
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp DinguxCommander $INSTALL/usr/bin/DinguxCommander.ogs
}
