# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="351Files"
PKG_VERSION="08e82877655a231f5fefc3f7aa15a640b58a7ceb"
PKG_SHA256="cffc55ebeddb35f7f5b17f175e8191cb7ea8f29a63626b242949deeb98c50af7"
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
