# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="parallel-n64"
PKG_VERSION="28c4572c9a09447b3bf5ed5fbd3594a558bc210d"
PKG_SHA256="03ebfd3b27f8d6d2846d180c2dba6ae5dd36f1f1ebea79db8c41817525ce38d2"
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
