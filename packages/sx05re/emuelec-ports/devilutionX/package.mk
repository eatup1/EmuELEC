# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="devilutionX"
PKG_VERSION="c5236ee80f64cdf0c7be2993f35d121ee7eb1f22"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="unlicense"
PKG_SITE="https://github.com/diasurgical/devilutionX"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2-git SDL2_mixer SDL2_ttf"
PKG_LONGDESC="Diablo build for modern operating systems "
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="-lto"

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET=" -DBINARY_RELEASE=1 -DCMAKE_BUILD_TYPE="Release" -DDEBUG=OFF -DPREFILL_PLAYER_NAME=ON -DDEVILUTIONX_SYSTEM_LIBSODIUM=OFF -DMO_LANG_DIR=\"/emuelec/configs/devilution/langs/\""
sed -i "s|;-static-libstdc++>|;-lstdc++>|" $PKG_BUILD/CMakeLists.txt

# copy korean font (with DevilutionX-add-koreanfont.patch)
cp -rf $PKG_DIR/fonts/* $PKG_BUILD/Packaging/resources/assets/fonts
# copy korean translation
cp -rf $PKG_DIR/Translations/ko.po $PKG_BUILD/Translations/ko_KR.po
}

makeinstall_target() { 
mkdir -p $INSTALL/usr/bin
cp -rf $PKG_BUILD/.$TARGET_NAME/devilutionx $INSTALL/usr/bin
#cp -rf $PKG_BUILD/Packaging/resources/CharisSILB.ttf $INSTALL/usr/bin
cp -rf $PKG_DIR/scripts/* $INSTALL/usr/bin

mkdir -p ${INSTALL}/usr/config/emuelec/configs/devilution/langs
cp $PKG_BUILD/.$TARGET_NAME/*.gmo ${INSTALL}/usr/config/emuelec/configs/devilution/langs

mkdir -p ${INSTALL}/usr/local/share/diasurgical/devilutionx/
cp $PKG_BUILD/.$TARGET_NAME/devilutionx.mpq ${INSTALL}/usr/local/share/diasurgical/devilutionx/

 
}
