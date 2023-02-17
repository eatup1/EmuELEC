# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="devilutionX"
PKG_VERSION="98294e0ad57865331202b916e2f71cd7fa6c82ae"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="unlicense"
PKG_SITE="https://github.com/diasurgical/devilutionX"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_mixer SDL2_image"
PKG_LONGDESC="Diablo build for modern operating systems "
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET=" -DCMAKE_BUILD_TYPE="Release" -DDEVILUTIONX_STATIC_CXX_STDLIB=OFF -DDISABLE_ZERO_TIER=ON -DBUILD_TESTING=OFF -DBUILD_ASSETS_MPQ=ON -DDEBUG=OFF -DPREFILL_PLAYER_NAME=ON -DDEVILUTIONX_SYSTEM_LIBSODIUM=OFF"

# Remove ja zh due to font size 
sed -i "s|ja ko pl pt_BR ro ru uk sv zh_CN zh_TW)|ko pl pt_BR ro ru uk sv)|" $PKG_BUILD/CMake/Assets.cmake
}

makeinstall_target() { 
mkdir -p $INSTALL/usr/bin
cp -rf $PKG_BUILD/.$TARGET_NAME/devilutionx $INSTALL/usr/bin
cp -rf $PKG_DIR/scripts/* $INSTALL/usr/bin

mkdir -p ${INSTALL}/usr/local/share/diasurgical/devilutionx/
cp $PKG_BUILD/.$TARGET_NAME/devilutionx.mpq ${INSTALL}/usr/local/share/diasurgical/devilutionx/
cp $PKG_DIR/fonts/fonts.mpq ${INSTALL}/usr/local/share/diasurgical/devilutionx/
 
}
