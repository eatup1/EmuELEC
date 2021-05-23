# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mpv"
# mpv v0.33.1
PKG_VERSION="b5d3e43198b9d57af5620b63537885aaa41fa8cd"
PKG_SHA256="50705b1332947b4dfe001434f16d75e0fe8d9ded8423f0a2d419704f4314f776"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/mpv-player/mpv"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg SDL2-git youtube-dl libass uchardet"
PKG_LONGDESC="Video player based on MPlayer/mplayer2 https://mpv.io"
PKG_TOOLCHAIN="manual"

configure_target() {
  #./bootstrap.py 
  # the bootstrap was failing for some reason. 
  cp $PKG_DIR/waf/* $PKG_BUILD  
  
 if [[ "$DEVICE" == "OdroidGoAdvance" || "$DEVICE" == "RG351P" || "$DEVICE" == "RG351V" || "$DEVICE" == "GameForce" ]]; then
  python3 ./waf configure --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --enable-drm --enable-gl --enable-uchardet
  else
  python3 ./waf configure --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --disable-drm --disable-gl --enable-uchardet
 fi
}

make_target() {
  python3 ./waf build
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp ./build/mpv $INSTALL/usr/bin
}
