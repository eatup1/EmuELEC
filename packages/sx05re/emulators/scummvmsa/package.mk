# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="scummvmsa"
PKG_VERSION="e2a1c59e20d915c272b9b249b47b71b04a3ad868"
PKG_SHA256="37daec93b304f0ada4f1e72a703900dd3e38873f97931b0f0ec66771eafcfff3"
PKG_GIT_CLONE_BRANCH="branch-2-8-0"
PKG_REV="1"
PKG_LICENSE="GPL2"
PKG_SITE="https://github.com/british-choi/scummvm"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_net freetype fluidsynth-git libmad"
PKG_SHORTDESC="Script Creation Utility for Maniac Mansion Virtual Machine"
PKG_LONGDESC="ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files."

pre_configure_target() { 
TARGET_CONFIGURE_OPTS=" --disable-opengl-game --disable-opengl-game-classic --disable-opengl-game-shaders --host=${TARGET_NAME} --backend=sdl --enable-vkeybd --enable-optimizations --opengl-mode=gles2 --with-sdl-prefix=${SYSROOT_PREFIX}/usr/bin"
}

post_makeinstall_target() {
mkdir -p ${INSTALL}/usr/config/scummvm/extra 
	cp -rf ${PKG_DIR}/config/* ${INSTALL}/usr/config/scummvm/
	cp -rf ${PKG_BUILD}/backends/vkeybd/packs/*.zip ${INSTALL}/usr/config/scummvm/extra

mv ${INSTALL}/usr/local/bin ${INSTALL}/usr/
	cp -rf ${PKG_DIR}/bin/* ${INSTALL}/usr/bin
	
for i in metainfo pixmaps appdata applications doc icons man; do
    rm -rf "${INSTALL}/usr/local/share/${i}"
  done

 
}

