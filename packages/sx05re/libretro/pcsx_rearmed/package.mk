# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="pcsx_rearmed"
PKG_VERSION="bdeee1a1d2382868d7004aedde636d7680c1a0a0"
PKG_SHA256="c1e5935600681c987d7c8ffe8ff49adb9678f4b6bad0043544e63f70df1f228e"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
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
