# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="devilutionX"
PKG_VERSION="7ea712428ebf3df5da58e107cc40e8db3825bebc"
PKG_GIT_CLONE_BRANCH="1.5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="unlicense"
PKG_SITE="https://github.com/diasurgical/devilutionX"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_mixer SDL2_image"
PKG_LONGDESC="Diablo build for modern operating systems "
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET=" -DCMAKE_BUILD_TYPE="Release" -DDEVILUTIONX_STATIC_CXX_STDLIB=OFF -DDISABLE_ZERO_TIER=ON -DBUILD_TESTING=OFF -DBUILD_ASSETS_MPQ=ON -DDEBUG=OFF -DPREFILL_PLAYER_NAME=ON -DDEVILUTIONX_SYSTEM_LIBSODIUM=OFF"

sed -i "s|\"assets\"\ DIRECTORY_SEPARATOR_STR|\"assets_dvx\"\ DIRECTORY_SEPARATOR_STR|" ${PKG_BUILD}/Source/utils/paths.cpp

# Remove ja zh due to font size 
sed -i "s|ja ko pl pt_BR ro ru uk sv zh_CN zh_TW)|ko pl pt_BR ro ru uk sv)|" $PKG_BUILD/CMake/Assets.cmake
}

makeinstall_target() { 
mkdir -p ${INSTALL}/usr/bin/assets_dvx
cp -rf ${PKG_BUILD}/.${TARGET_NAME}/devilutionx ${INSTALL}/usr/bin
cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
cp -rf ${PKG_BUILD}/.${TARGET_NAME}/assets/* ${INSTALL}/usr/bin/assets_dvx/

mkdir -p ${INSTALL}/usr/config/emuelec/configs/devilution/langs
mv ${INSTALL}/usr/bin/assets_dvx/*.gmo ${INSTALL}/usr/config/emuelec/configs/devilution/langs

mkdir -p ${INSTALL}/usr/local/share/diasurgical/devilutionx/
cp $PKG_BUILD/.$TARGET_NAME/devilutionx.mpq ${INSTALL}/usr/local/share/diasurgical/devilutionx/
cp $PKG_DIR/fonts/fonts.mpq ${INSTALL}/usr/local/share/diasurgical/devilutionx/
}
