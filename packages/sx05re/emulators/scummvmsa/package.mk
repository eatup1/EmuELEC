# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="scummvmsa"
PKG_VERSION="c1482136c6bb6ce5dd76aa7deffd791134d1b125"
PKG_SHA256="f5d4797072219c47b4ac36dafbbff399d4f5f7f464915219666d057b6bd6b089"
PKG_REV="1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/scummvm/scummvm"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_net freetype fluidsynth-git libmad"
PKG_SHORTDESC="Script Creation Utility for Maniac Mansion Virtual Machine"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

pre_configure_target() { 
TARGET_CONFIGURE_OPTS="--host=${TARGET_NAME} --backend=sdl --enable-vkeybd --enable-optimizations --opengl-mode=gles2 --with-sdl-prefix=${SYSROOT_PREFIX}/usr/bin"

# copy korean translation
#cp -rf $PKG_DIR/po/ko.po $PKG_BUILD/po/ko.po
}

post_makeinstall_target() {
mkdir -p $INSTALL/usr/config/scummvm
	cp -rf $PKG_DIR/config/* $INSTALL/usr/config/scummvm/

mv $INSTALL/usr/local/bin $INSTALL/usr/
	cp -rf $PKG_DIR/bin/* $INSTALL/usr/bin
	
for i in appdata applications doc icons man; do
    rm -rf "$INSTALL/usr/local/share/$i"
  done

 
}

