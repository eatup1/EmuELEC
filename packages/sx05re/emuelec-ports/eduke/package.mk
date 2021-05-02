# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="eduke"
PKG_VERSION="7225643e3646b3781bc8c1030310f6761dda67d7"
PKG_ARCH="any"
PKG_LICENSE="GPL2 + BUILDLIC"
PKG_SITE="https://eduke32.com"
PKG_URL="https://voidpoint.io/terminx/eduke32.git"
PKG_DEPENDS_TARGET="toolchain SDL2-git SDL2_mixer timidity flac"
PKG_LONGDESC="EDuke32 is an awesome, free homebrew game engine and source port of the classic PC first person shooter Duke Nukem 3D"
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="make"

pre_configure_target() {
if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" ]; then
sed -i "s|# define MINXDIM 640|# define MINXDIM 480|" ./source/build/include/build.h
sed -i "s|# define MINYDIM 480|# define MINYDIM 320|" ./source/build/include/build.h
fi
sed -i "s|sdl2-config|$SYSROOT_PREFIX/usr/bin/sdl2-config|" Common.mak
sed -i "s|-latomic|#|" Common.mak
PKG_MAKE_OPTS_TARGET=" duke3d LTO=1 SDL_TARGET=2 NOASM=1 HAVE_GTK2=0 POLYMER=1 USE_OPENGL=0 RELEASE=1 OPTLEVEL=3"
}

makeinstall_target() {
mkdir -p $INSTALL/usr/bin
cp -rf eduke32 $INSTALL/usr/bin
cp $PKG_DIR/scripts/eduke.sh $INSTALL/usr/bin
}
