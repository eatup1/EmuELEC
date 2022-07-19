# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2022-present 7Ji (https://github.com/7Ji)

PKG_NAME="lib32-linux-headers"
PKG_VERSION="$(get_pkg_version linux)"
PKG_ARCH="aarch64"
PKG_URL=""
PKG_LICENSE="GPL"
PKG_SITE="http://www.kernel.org"
PKG_DEPENDS_TARGET="ccache:host rsync:host openssl:host"
PKG_LONGDESC="This package contains Linux headers."
PKG_DEPENDS_UNPACK+=" linux"
PKG_BUILD_FLAGS="lib32"

unpack() {
  mkdir -p ${PKG_BUILD}
  if [ "${LINUX}" = "default" ]; then
    tar --strip-components=1 -xf ${SOURCES}/linux/linux-${PKG_VERSION}.tar.xz -C ${PKG_BUILD}  
  else
    tar --strip-components=1 -xf ${SOURCES}/linux/linux-${LINUX}-${PKG_VERSION}.tar.gz -C ${PKG_BUILD}
  fi
}

make_target() {
  :
}

makeinstall_target() {
  make \
    ARCH=arm \
    HOSTCC="${TOOLCHAIN}/bin/host-gcc" \
    HOSTCXX="${TOOLCHAIN}/bin/host-g++" \
    HOSTCFLAGS="${HOST_CFLAGS}" \
    HOSTCXXFLAGS="${HOST_CXXFLAGS}" \
    HOSTLDFLAGS="${HOST_LDFLAGS}" \
    INSTALL_HDR_PATH=dest \
    headers_install
  mkdir -p ${SYSROOT_PREFIX}/usr/include
    cp -R dest/include/* ${SYSROOT_PREFIX}/usr/include
}