# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="PPSSPPSDL"
PKG_VERSION="3e481634ace6e799ef3f7a3fa6cdea0f4a8c060f"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/hrydgard/ppsspp"
PKG_URL="https://github.com/hrydgard/ppsspp.git"
PKG_DEPENDS_TARGET="toolchain ffmpeg libzip libpng SDL2 zlib zip"
PKG_SHORTDESC="PPSSPPDL"
PKG_LONGDESC="PPSSPP Standalone"
GET_HANDLER_SUPPORT="git"
PKG_BUILD_FLAGS="-lto"

PKG_CMAKE_OPTS_TARGET+="-DUSE_SYSTEM_FFMPEG=ON \
                        -DUSING_FBDEV=ON \
                        -DUSING_EGL=ON \
                        -DUSING_GLES2=ON \
                        -DUSING_X11_VULKAN=OFF \
                        -DUSE_DISCORD=OFF"

if [ $ARCH == "aarch64" ]; then
PKG_CMAKE_OPTS_TARGET+=" -DARM64=ON"
else
PKG_CMAKE_OPTS_TARGET+=" -DARMV7=ON"
fi


pre_configure_target() {
if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
	sed -i "s|include_directories(/usr/include/drm)|include_directories(${SYSROOT_PREFIX}/usr/include/drm)|" $PKG_BUILD/CMakeLists.txt
fi
}

pre_make_target() {
  # fix cross compiling
  find ${PKG_BUILD} -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find ${PKG_BUILD} -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
}


makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/ppsspp.sh $INSTALL/usr/bin/ppsspp.sh
    cp `find . -name "PPSSPPSDL" | xargs echo` $INSTALL/usr/bin/PPSSPPSDL
    ln -sf /storage/.config/ppsspp/assets $INSTALL/usr/bin/assets
    mkdir -p $INSTALL/usr/config/ppsspp/
    cp -r `find . -name "assets" | xargs echo` $INSTALL/usr/config/ppsspp/
    cp -rf $PKG_DIR/config/* $INSTALL/usr/config/ppsspp/
if [ "$DEVICE" == "OdroidGoAdvance" ]; then
    rm -f $INSTALL/usr/config/ppsspp/PSP/SYSTEM/controls_*.ini
    cp -f $PKG_DIR/config/PSP/SYSTEM/controls_oga.ini $INSTALL/usr/config/ppsspp/PSP/SYSTEM/controls.ini
elif [ "$DEVICE" == "RG351P" ]; then
    rm -f $INSTALL/usr/config/ppsspp/PSP/SYSTEM/controls_*.ini
    cp -f $PKG_DIR/config/PSP/SYSTEM/controls_rg351p.ini $INSTALL/usr/config/ppsspp/PSP/SYSTEM/controls.ini
elif [ "$DEVICE" == "RG351V" ]; then
    rm -f $INSTALL/usr/config/ppsspp/PSP/SYSTEM/controls_*.ini
    cp -f $PKG_DIR/config/PSP/SYSTEM/controls_rg351v.ini $INSTALL/usr/config/ppsspp/PSP/SYSTEM/controls.ini
fi
    rm $INSTALL/usr/config/ppsspp/assets/gamecontrollerdb.txt
    ln -sf /storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt $INSTALL/usr/config/ppsspp/assets/gamecontrollerdb.txt
} 
