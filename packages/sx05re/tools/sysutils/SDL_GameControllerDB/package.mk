# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)

PKG_NAME="SDL_GameControllerDB"
PKG_VERSION="cead9cccf79c0865cf8c2b7b652867372d63cd6e"
PKG_SHA256="af45411e7b4a24b91f267cf2281c63df209e7552f41f29d9a4261a50363811e5"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/gabomdq/SDL_GameControllerDB"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A community sourced database of game controller mappings to be used with SDL2 Game Controller functionality"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
# These maps are old, we use our own
sed -i "s/19000000010000000100000001010000,odroid/# 19000000010000000100000001010000,odroid/g" gamecontrollerdb.txt
sed -i "s/19000000010000000200000011000000,odroid/# 19000000010000000200000011000000,odroid/g" gamecontrollerdb.txt
sed -i "s/03000000d11800000094000011010000,Stadia Controller/# 03000000d11800000094000011010000,Stadia Controller/g" gamecontrollerdb.txt
sed -i "s/03000000790000001c18000011010000,PC Game Controller,a:b2/# 03000000790000001c18000011010000,PC Game Controller,a:b2/g" gamecontrollerdb.txt
sed -i "s/03000000790000000600000010010000,DragonRise Inc. Generic USB Joystick,a:b2/# 03000000790000000600000010010000,DragonRise Inc. Generic USB Joystick,a:b2/g" gamecontrollerdb.txt
sed -i "s/03000000bc2000000055000010010000,ShanWan PS3/PC Wired GamePad/# 03000000bc2000000055000010010000,ShanWan PS3/PC Wired GamePad" gamecontrollerdb.txt
if [ "$DEVICE" == "RG351V" ]; then
sed -i "s/OpenSimHardware OSH PB Controller,platform:Linux,x:b2,a:b0,b:b1,y:b3,guide:b7,back:b7,start:b6,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,dpup:h0.1,leftshoulder:b4,lefttrigger:b10,rightshoulder:b5,righttrigger:b11,leftstick:b8,rightstick:b9,leftx:a0,lefty:a1,rightx:a2,righty:a3,/OpenSimHardware OSH PB Controller,platform:Linux,x:b2,a:b0,b:b1,y:b3,guide:b9,back:b7,start:b6,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,dpup:h0.1,leftshoulder:b4,lefttrigger:b10,rightshoulder:b5,righttrigger:b11,leftstick:b8,leftx:a0,lefty:a1,/g" gamecontrollerdb.txt
fi
sed -i "s/030000004c0500006802000011810000,PS3 Controller/# 030000004c0500006802000011810000,PS3 Controller/g" gamecontrollerdb.txt
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/SDL-GameControllerDB
  cp $PKG_BUILD/gamecontrollerdb.txt $INSTALL/usr/config/SDL-GameControllerDB
}
