# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="mpv"
PKG_VERSION="88120d47599da61e17350da4d35b565d5c3e29aa"
PKG_SHA256="cdf790b66c3c1b5eefb6502292ff1fc046d0cb5527257028f52032547e3c5c87"
PKG_LICENSE="GPLv2+"
PKG_SITE="https://github.com/mpv-player/mpv"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ffmpeg SDL2 youtube-dl libass uchardet"
PKG_LONGDESC="Video player based on MPlayer/mplayer2 https://mpv.io"
PKG_TOOLCHAIN="manual"


pre_configure_target() {
	WAFRELEASE="waf-2.0.20"
	WAFURL="https://waf.io/${WAFRELEASE}"
	
if [ ! -e ${SOURCES}/${PKG_NAME}/waf ]; then
	wget "${WAFURL}" -O "${SOURCES}/${PKG_NAME}/waf" || echo "Could not download waf $?"
	chmod +x "${SOURCES}/${PKG_NAME}/waf"
fi

cp ${SOURCES}/${PKG_NAME}/waf ${PKG_BUILD}
}

configure_target() {
  #./bootstrap.py 
  # the bootstrap was failing for some reason. 
	cd ${PKG_BUILD}

 if [[ "$DEVICE" == "OdroidGoAdvance" || "$DEVICE" == "RG351P" || "$DEVICE" == "RG351V" || "$DEVICE" == "GameForce" ]]; then
  ./waf configure --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --enable-drm --enable-gl --enable-uchardet
  else
  ./waf configure --enable-libmpv-shared --enable-sdl2 --enable-sdl2-gamepad --disable-pulse --enable-egl --disable-libbluray --disable-drm --disable-gl --enable-uchardet
 fi
}

make_target() {
  ./waf build
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp ./build/mpv $INSTALL/usr/bin
}
