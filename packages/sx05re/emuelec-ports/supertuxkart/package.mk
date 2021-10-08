# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="supertuxkart"
PKG_VERSION="1c983f7090cbdd6ad44537c7fad79761bd8df337"
PKG_SHA256="b384ac081212e66969e12e55fbd5fb0da408c116f00332f59f68b659a7b816b9"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/supertuxkart/stk-code"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2-git harfbuzz"
PKG_LONGDESC="SuperTuxKart is a free kart racing game. It focuses on fun and not on realistic kart physics. Instructions can be found on the in-game help page."

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET+=" -DUSE_WIIUSE=OFF -DCHECK_ASSETS=off -DCMAKE_BUILD_TYPE=Release"
}

makeinstall_target() {
mkdir -p $INSTALL/usr/bin
cp $PKG_BUILD/.${TARGET_NAME}/bin/supertuxkart $INSTALL/usr/bin/
cp $PKG_DIR/scripts/* $INSTALL/usr/bin
}
