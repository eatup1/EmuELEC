# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="parallel-n64"
PKG_VERSION="28ef8ff960efef4fc3c462ddc52707e140fee3be"
PKG_SHA256="25689b7c30a8706979eadbeb971107ea3159d4763f50870d79b4e84548b5ee66"
PKG_REV="2"
PKG_LICENSE="GPLv2"
PKG_ARCH="arm"
PKG_SITE="https://github.com/libretro/parallel-n64"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"


if [[ "$ARCH" == "arm" ]]; then
	PKG_PATCH_DIRS="emuelec-arm32"
else
	PKG_PATCH_DIRS="emuelec-aarch64"
fi

pre_configure_target() {
if [[ "$ARCH" == "arm" ]]; then
	PKG_PATCH_DIRS="arm"
	PKG_MAKE_OPTS_TARGET=" platform=${DEVICE}"
	
	if [ "${DEVICE}" == "OdroidGoAdvance" -o "${DEVICE}" == "RG351P" -o "${DEVICE}" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
		PKG_MAKE_OPTS_TARGET=" platform=Odroidgoa"
	fi
	
	if [ "$DEVICE" == "RK356x" ] || [ "$DEVICE" == "OdroidM1" ]; then
		PKG_MAKE_OPTS_TARGET=" platform=Odroidgoa-RK356x"
	fi
else
	PKG_PATCH_DIRS="emuelec-aarch64"
	PKG_MAKE_OPTS_TARGET=" platform=emuelec64-armv8"
	
	if [ "${DEVICE}" == "OdroidGoAdvance" -o "${DEVICE}" == "RG351P" -o "${DEVICE}" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
		#todo add odroidgoadvance to 64bits
		PKG_MAKE_OPTS_TARGET=" platform=emuelec64-armv8"
	fi
fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp parallel_n64_libretro.so $INSTALL/usr/lib/libretro/parallel_n64_32b_libretro.so
}
