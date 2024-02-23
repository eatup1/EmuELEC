# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="solarus"
PKG_VERSION="8fff7c03de610669fc4f4079fa64df2bed28dfcd"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://gitlab.com/solarus-games/solarus"
PKG_URL="${PKG_SITE}.git"
PKG_DEPENDS_TARGET="toolchain luajit glm libmodplug physfs SDL2 SDL2_image SDL2_ttf"
PKG_SHORTDESC="Action-RPG/Adventure 2D game engine"
PKG_TOOLCHAIN="cmake"
GET_HANDLER_SUPPORT="git"

pre_configure_target() {
export LDFLAGS+=" -ldl"
PKG_CMAKE_OPTS_TARGET="-DSOLARUS_GL_ES=ON -DSOLARUS_GUI=OFF -DSOLARUS_USE_LUAJIT=ON -DSOLARUS_TESTS=OFF"
}

pre_makeinstall_target() {
mkdir -p ${INSTALL}/usr/bin
cp ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin

mkdir -p ${INSTALL}/usr/config/emuelec/configs/solarus
cp ${PKG_DIR}/config/* ${INSTALL}/usr/config/emuelec/configs/solarus

}
