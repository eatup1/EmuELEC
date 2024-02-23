PKG_NAME="openjazz"
PKG_VERSION="8108082394a2ca1007b2444b4099d9f18afcb530"
PKG_SHA256="0203dd43cab99d06e5bc8f728473e96af37eb3fd8548fbc99bc2090a18baf6e3"
PKG_ARCH="aarch64"
PKG_LICENSE="GPL-2.0-or-later"
PKG_SITE="http://www.alister.eu/jazz/oj/"
PKG_URL="https://github.com/AlisterT/openjazz/archive/${PKG_VERSION}.tar.gz"
PKG_SHORTDESC="OpenJazz for OGA"
PKG_LONGDESC="a free, open-source version of the classic Jazz Jackrabbit™ games."
PKG_DEPENDS_TARGET="toolchain SDL2"
PKG_TOOLCHAIN="auto"

pre_configure_target() {
  sed -i "s|sdl2-config|${SYSROOT_PREFIX}/usr/bin/sdl2-config|g" Makefile
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/OpenJazz ${INSTALL}/usr/bin
}
