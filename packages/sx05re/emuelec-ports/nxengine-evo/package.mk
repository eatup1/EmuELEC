# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Young-jun Choi (https://github.com/british.choi)

PKG_NAME="nxengine-evo"
PKG_VERSION="ff0a01672c82f593163ac5b4b35f6c46c6ef6802"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/nxengine/nxengine-evo"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_mixer SDL2_ttf SDL2_image libpng libjpeg-turbo"
PKG_LONGDESC="A somewhat upgraded/refactored version of NXEngine by Caitlin Shaw."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET=" -DCMAKE_BUILD_TYPE=Release -DPORTABLE=OFF -DCMAKE_INSTALL_FULL_DATADIR=\"/storage/roms/ports\""

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp "${PKG_DIR}/scripts/nxengine-evo.sh" $INSTALL/usr/bin
  rm -rf $INSTALL/usr/share/applications/
  rm -rf $INSTALL/usr/share/icons/
  rm -rf $INSTALL/usr/share/metainfo/

  mkdir -p $INSTALL/usr/config/emuelec/configs
  cp -rf ${PKG_DIR}/config/* $INSTALL/usr/config/emuelec/configs/
}
