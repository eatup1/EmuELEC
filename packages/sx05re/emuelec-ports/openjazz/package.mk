PKG_NAME="openjazz"
PKG_VERSION="ff36254abe1c094f69e445e698c043aeb1d577cd"
PKG_SHA256="1db79f6c641aee532fc982e17a2b800abe1a319273c4caab1a0399b5e24b772d"
PKG_ARCH="aarch64"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="http://www.alister.eu/jazz/oj/"
PKG_URL="https://github.com/AlisterT/openjazz/archive/$PKG_VERSION.tar.gz"
PKG_SHORTDESC="OpenJazz for OGA"
PKG_LONGDESC="a free, open-source version of the classic Jazz Jackrabbit™ games."
PKG_DEPENDS_TARGET="toolchain SDL2-git"
PKG_TOOLCHAIN="auto"

pre_configure_target() {
  sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|g" Makefile
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/OpenJazz $INSTALL/usr/bin
}
