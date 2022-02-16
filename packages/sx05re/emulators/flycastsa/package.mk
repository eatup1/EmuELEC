# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="flycastsa"
PKG_VERSION="a4b0a69c455971c85257e3cfc3ee13a592296ce7"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/flyinghead/flycast"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES} alsa SDL2 libzip zip"
PKG_LONGDESC="Flycast is a multiplatform Sega Dreamcast, Naomi and Atomiswave emulator"
PKG_TOOLCHAIN="cmake"
PKG_GIT_CLONE_BRANCH="master"

if [ "${ARCH}" == "arm" ]; then
	PKG_PATCH_DIRS="arm"
fi

PKG_CMAKE_OPTS_TARGET="-DUSE_VULKAN=OFF \
                        -DUSE_OPENMP=OFF \ 
                        -DCMAKE_BUILD_TYPE=Release \
                        -DUSE_GLES2=ON"

pre_make_target() {
  find $PKG_BUILD -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find $PKG_BUILD -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
  sed -i "s|as_fn_append WARN_CXXFLAGS \" -Werror\"|as_fn_append WARN_CXXFLAGS \" -Wall\"|g" ${PKG_BUILD}/core/deps/breakpad/configure
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/.${TARGET_NAME}/flycast $INSTALL/usr/bin/flycast
  cp $PKG_DIR/scripts/* $INSTALL/usr/bin

	chmod +x $INSTALL/usr/bin/flycast.sh
	chmod +x $INSTALL/usr/bin/set_flycast_joy.sh
}
