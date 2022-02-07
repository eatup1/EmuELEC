# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="devilutionX"
PKG_VERSION="32d39c65246b17fbf6b89d4a914beb04f02ee7e8"
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
PKG_CMAKE_OPTS_TARGET=" -DBINARY_RELEASE=1 -DCMAKE_BUILD_TYPE="Release" -DDEBUG=OFF -DPREFILL_PLAYER_NAME=ON -DDEVILUTIONX_SYSTEM_LIBSODIUM=OFF -DDISABLE_ZERO_TIER=ON"
sed -i "s|;-static-libstdc++>|;-lstdc++>|" $PKG_BUILD/CMake/functions/devilutionx_library.cmake

# Remove ja zh due to font size 
sed -i "s|ja ko_KR pl pt_BR ro_RO ru uk sv zh_CN zh_TW)|ko_KR pl pt_BR ro_RO ru uk sv)|" $PKG_BUILD/CMakeLists.txt

# copy korean translation
cp -rf $PKG_DIR/Translations/ko.po $PKG_BUILD/Translations/ko.po
}

makeinstall_target() { 
mkdir -p $INSTALL/usr/bin
cp -rf $PKG_BUILD/.$TARGET_NAME/devilutionx $INSTALL/usr/bin
cp -rf $PKG_DIR/scripts/* $INSTALL/usr/bin

mkdir -p ${INSTALL}/usr/local/share/diasurgical/devilutionx/
cp $PKG_BUILD/.$TARGET_NAME/devilutionx.mpq ${INSTALL}/usr/local/share/diasurgical/devilutionx/
cp $PKG_DIR/fonts/fonts.mpq ${INSTALL}/usr/local/share/diasurgical/devilutionx/
 
}
