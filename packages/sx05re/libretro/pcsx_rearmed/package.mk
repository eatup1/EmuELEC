# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="pcsx_rearmed"
PKG_VERSION="9aefd427e47e1cdf94578e1913054bc14a44bab6"
PKG_SHA256="3c355e64761be3b75459eccdb014540d1def37c5100dbd8faeb0f8c1750a8b40"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa"
PKG_SHORTDESC="ARM optimized PCSX fork"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed -gold"

make_target() {
cd ${PKG_BUILD}
export ALLOW_LIGHTREC_ON_ARM=1
if [ "${ARCH}" == "arm" ]; then
	if [ "${DEVICE}" == "Amlogic-old" ]; then
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=rpi3
	else
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=rpi4
	fi
else
	if [ "${DEVICE}" == "Amlogic-old" ]; then
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=h5
	elif [ "${DEVICE}" == "OdroidGoAdvance" -o "${DEVICE}" == "RG351P" -o "${DEVICE}" == "RG351V" ] || [ "${DEVICE}" == "Gameforce" ]; then
		sed -i "s|cortex-a53|cortex-a35|g" Makefile.libretro
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=h5
	else
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=CortexA73_G12B
	fi
fi
}

makeinstall_target() {
INSTALLTO="/usr/lib/libretro"
mkdir -p ${INSTALL}${INSTALLTO}/

if [ "${ARCH}" == "arm" ]; then
    cp pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}/pcsx_rearmed_32b_libretro.so
else
    cp pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}
fi
}
