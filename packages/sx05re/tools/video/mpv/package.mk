# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mpv"
PKG_VERSION="4dcaf70b9653cd04c2159fac6545f25f8e1cbcf9"
PKG_SHA256="41dd8ea95d835a01aa4bc23f4aa5f82c5781ea99cf474872f0b7257ab0446742"
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
  
 if [[ "$DEVICE" == "OdroidGoAdvance" || "$DEVICE" == "RG351P" || "$DEVICE" == "GameForce" ]]; then
  ./waf configure --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --enable-drm --enable-gl --enable-uchardet
  else
  ./waf configure --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --disable-drm --disable-gl --enable-uchardet
 fi
}

make_target() {
  ./waf build
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp ./build/mpv $INSTALL/usr/bin
}
