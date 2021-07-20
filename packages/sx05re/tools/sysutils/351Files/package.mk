# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="351Files"
PKG_VERSION="1ee7591c591ae18e6a2d2e19d96cf996f71bf712"
PKG_SHA256="a88e6c02b4f8412bb004b251f6a0f8219c45f35dfaab47cde82eda28cbfc0eda"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Tardigrade-nx/351Files"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2-git SDL2_image SDL2_gfx SDL2_ttf freetype file"
PKG_LONGDESC="File Manager"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  sed -i "s|ifeq (\$(DEVICE),PC)||g" Makefile
  sed -i "s|endif||g" Makefile
  sed -i "s|START_PATH = \$(PWD)||g" Makefile
  sed -i "s|sdl2-config|$SYSROOT_PREFIX/usr/bin/sdl2-config|g" Makefile
  sed -i "s|g++|\$(CXX)|g" Makefile

	EEDV="PC"

if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
	EEDV="EE_HH"
fi

  PKG_MAKE_OPTS_TARGET=" START_PATH="/storage" DEVICE=${EEDV} RES_PATH="/emuelec/configs/fm/res""
}



makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  mkdir -p $INSTALL/usr/config/emuelec/configs/fm
  cp 351Files $INSTALL/usr/bin/
  cp -rf res $INSTALL/usr/config/emuelec/configs/fm/
  
  cp -rf ${PKG_DIR}/config/* $INSTALL/usr/config/emuelec/configs/
  
  # Copy korean font
  cp -rf ${PKG_DIR}/res/*.ttf $INSTALL/usr/config/emuelec/configs/fm/res/
  
}
