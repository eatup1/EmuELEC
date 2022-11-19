# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="fheroes2"
<<<<<<< HEAD
PKG_VERSION="27ec7781805b21b632c47c74466e134eee8126b7"	#v0.9.20
=======
PKG_VERSION="c6dcaafea2e5194aa327a3314b9a5f9f7fe25fa7"
>>>>>>> 3efb27cbb9feccb536f4dfd3fc10cc6df09141de
PKG_ARCH="any"
PKG_SITE="https://github.com/ihhub/fheroes2"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_SHORTDESC="Free Heroes of Might and Magic II (fheroes2) is a recreation of HoMM2 game engine."
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET=" -DUSE_SDL_VERSION=SDL2 -DENABLE_IMAGE=ON -DCMAKE_BUILD_TYPE=Release"

makeinstall_target() {
mkdir -p ${INSTALL}/usr/share/fheroes2/files/data
mkdir -p ${INSTALL}/usr/bin
mkdir -p ${INSTALL}/usr/config/fheroes2

cp ${PKG_BUILD}/files/data/resurrection.h2d ${INSTALL}/usr/share/fheroes2/files/data 
cp ${PKG_BUILD}/.${TARGET_NAME}/fheroes2 ${INSTALL}/usr/bin
cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
cp ${PKG_DIR}/config/* ${INSTALL}/usr/config/fheroes2

}
