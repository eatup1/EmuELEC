# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="rs97-commander-sdl2"
PKG_VERSION="d100ad79ee9e2f5cfb0735f9bb2ccff5a6a3314c"
PKG_SHA256="9f088c70c4ad8c6f48aa76de130ce04c0168c9299f43d1c55bad03791a64a934"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/EmuELEC/rs97-commander-sdl2"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2_image SDL2_gfx SDL2_ttf"
PKG_PRIORITY="optional"
PKG_SECTION="tools"
PKG_SHORTDESC="Two-pane commander for RetroFW and RG-350 (fork of Dingux Commander)"

pre_configure_target() {
sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|" Makefile
sed -i "s|CC=g++|CC=${CXX}|" Makefile

# change for korean font
sed -i "s|FONTSIZE := 8|FONTSIZE := 10|" Makefile
sed -i "s|FOOTERH := 13|FOOTERH := 15|" Makefile
sed -i "s|LINEH := 15|LINEH := 17|" Makefile
sed -i "s|VIEWER_LINE_H := 13|VIEWER_LINE_H := 15|" Makefile
sed -i "s|Fiery_Turk.ttf|NanumGothic.ttf|" Makefile

OGA=0

if [[ "$DEVICE" == "OdroidGoAdvance" || "$DEVICE" == "RG351P" || "$DEVICE" == "GameForce" ]]; then
	OGA=1
fi

PKG_MAKE_OPTS_TARGET=" ODROIDGO=${OGA} CC=$CXX"
	
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/emuelec/configs/fm
  cp DinguxCommander $INSTALL/usr/bin/
  cp -rf res $INSTALL/usr/config/emuelec/configs/fm/

  # Copy korean font
  cp -r $PKG_DIR/res/NanumGothic.ttf $INSTALL/usr/config/emuelec/configs/fm/res/
}
