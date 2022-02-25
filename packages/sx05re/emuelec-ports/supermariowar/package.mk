# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="supermariowar"
PKG_VERSION="ce6a45acb99d72856a7cd37e07f67a0d81dc0fee"
PKG_ARCH="any"
PKG_SITE="https://github.com/mmatyas/supermariowar"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_image SDL2_mixer"
PKG_SHORTDESC="A fan-made multiplayer Super Mario Bros. style deathmatch game "
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET=" -DUSE_PNG_SAVE=ON"

makeinstall_target() {
mkdir -p $INSTALL/usr/bin
cp $PKG_BUILD/.${TARGET_NAME}/Binaries/Release/* $INSTALL/usr/bin
cp $PKG_DIR/scripts/* $INSTALL/usr/bin
mkdir -p $INSTALL/usr/config/emuelec/configs/smw
cp $PKG_DIR/config/* $INSTALL/usr/config/emuelec/configs/smw
if [ "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ]; then
    cp $PKG_DIR/config/controls.sdl2.rg351 $INSTALL/usr/config/emuelec/configs/smw/controls.sdl2.bin
    rm -rf $INSTALL/usr/config/emuelec/configs/smw/controls.sdl2.rg351
fi
} 
