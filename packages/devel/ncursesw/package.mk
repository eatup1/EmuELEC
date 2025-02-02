# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="ncursesw"
PKG_VERSION="6.1-20181215"
PKG_SHA256="08b07c3e792961f300829512c283d5fefc0b1c421a57b76922c3d13303ed677d"
PKG_LICENSE="MIT"
PKG_SITE="http://www.gnu.org/software/ncurses/"
#PKG_URL="http://invisible-mirror.net/archives/ncurses/current/ncurses-${PKG_VERSION}.tgz"
PKG_URL="http://sources.libreelec.tv/mirror/ncurses/ncurses-${PKG_VERSION}.tgz"
PKG_DEPENDS_HOST="ccache:host"
PKG_DEPENDS_TARGET="toolchain zlib ncurses:host"
PKG_LONGDESC="A library is a free software emulation of curses in System V Release 4.0, and more."
# causes some segmentation fault's (dialog) when compiled with gcc's link time optimization.
PKG_BUILD_FLAGS="+pic"
PKG_CONFIGURE_OPTS_HOST="--enable-hashmap \
                        --enable-widec"

PKG_CONFIGURE_OPTS_TARGET="--without-ada \
                           --without-cxx \
                           --without-cxx-binding \
                           --disable-db-install \
                           --without-manpages \
                           --without-progs \
                           --without-tests \
                           --without-shared \
                           --with-normal \
                           --without-debug \
                           --without-profile \
                           --without-termlib \
                           --without-ticlib \
                           --without-gpm \
                           --without-dbmalloc \
                           --without-dmalloc \
                           --disable-rpath \
                           --disable-database \
                           --with-fallbacks=linux,screen,xterm,xterm-color,dumb,st-256color \
                           --with-termpath=/storage/.config/termcap \
                           --disable-big-core \
                           --enable-termcap \
                           --enable-getcap \
                           --disable-getcap-cache \
                           --enable-symlinks \
                           --disable-bsdpad \
                           --without-rcs-ids \
                           --enable-ext-funcs \
                           --disable-const \
                           --enable-no-padding \
                           --disable-sigwinch \
                           --enable-pc-files \
                           --with-pkg-config-libdir=/usr/lib/pkgconfig \
                           --disable-tcap-names \
                           --without-develop \
                           --disable-hard-tabs \
                           --disable-xmc-glitch \
                           --enable-hashmap \
                           --disable-safe-sprintf \
                           --disable-scroll-hints \
                           --enable-widec \
                           --disable-echo \
                           --disable-warnings \
                           --disable-home-terminfo \
                           --disable-assertions"

post_makeinstall_target() {
  cp misc/ncurses-config ${TOOLCHAIN}/bin/ncursesw-config
  chmod +x ${TOOLCHAIN}/bin/ncursesw-config
  sed -e "s:\(['=\" ]\)/usr:\\1${PKG_ORIG_SYSROOT_PREFIX}/usr:g" -i ${TOOLCHAIN}/bin/ncursesw-config
  sed -i "s|if test ncurses = ncurses|if test ncursesw = ncursesw|g" "${TOOLCHAIN}/bin/ncursesw-config"
  rm -rf $INSTALL/usr/bin
}
