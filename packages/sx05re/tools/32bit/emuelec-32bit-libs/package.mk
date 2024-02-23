# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="emuelec-32bit-libs"
PKG_VERSION="91d82daa6791de6dc0d9c925b2fe6a207b0cb2dd"
PKG_SHA256="68277b6684dd5471a6307a285f2280468fc088f2a7967651598d6bffe380bdb6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/british-choi/emuelec-32bit-libs"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES}"
PKG_LONGDESC="EmuELEC 32-bit libraries, binaries and cores to use with EmuELEC aarch64"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}
if [[ "${DEVICE}" == "OdroidGoAdvance" ]] || [[ "${DEVICE}" == "RG351P" ]] || [[ "${DEVICE}" == "RG351V" ]] || [[ "${DEVICE}" == "GameForce" ]]; then
	cp -rf ${PKG_BUILD}/OdroidGoAdvance/* ${INSTALL}/
	
	if [[ "${DEVICE}" == "GameForce" ]]; then
	   cp -rf ${PKG_BUILD}/GameForce/* ${INSTALL}/
	elif [[ "${DEVICE}" == "RG351P" ]]; then
	   cp -rf ${PKG_BUILD}/RG351P/* ${INSTALL}/
	elif [[ "${DEVICE}" == "RG351V" ]]; then
	   cp -rf ${PKG_BUILD}/RG351V/* ${INSTALL}/
	fi
	cp -rf --remove-destination "$(get_build_dir mali-bifrost)/libmali.so_rk3326_gbm_arm32_r13p0_with_vulkan_and_cl" ${INSTALL}/usr/config/emuelec/lib32/libMali.so	
elif [[ "${DEVICE}" == "Amlogic-ng" ]]; then
    cp -rf ${PKG_BUILD}/Amlogic-ng/* ${INSTALL}/
    cp -p "$(get_build_dir opengl-meson)/lib/eabihf/gondul/r12p0/fbdev/libMali.so" ${INSTALL}/usr/config/emuelec/lib32/libMali.gondul.so
    cp -p "$(get_build_dir opengl-meson)/lib/eabihf/dvalin/r12p0/fbdev/libMali.so" ${INSTALL}/usr/config/emuelec/lib32/libMali.dvalin.so
    cp -p "$(get_build_dir opengl-meson)/lib/eabihf/m450/r7p0/fbdev/libMali.so" ${INSTALL}/usr/config/emuelec/lib32/libMali.m450.so
elif [[ "${DEVICE}" == "Amlogic-old" ]]; then
    cp -rf ${PKG_BUILD}/Amlogic-old/* ${INSTALL}/
    cp -p "$(get_build_dir opengl-meson)/lib/eabihf/m450/r7p0/fbdev/libMali.so" ${INSTALL}/usr/config/emuelec/lib32/libMali.m450.so
elif [[ "${DEVICE}" == "RK356x" ]] || [[ "${DEVICE}" == "OdroidM1" ]]; then
    cp -rf ${PKG_BUILD}/RK356x/* ${INSTALL}/
    cp -rfp --remove-destination "$(get_build_dir mali-bifrost)/lib/arm-linux-gnueabihf/libmali-bifrost-g52-g2p0-gbm.so" ${INSTALL}/usr/config/emuelec/lib32/libMali.so
fi

mkdir -p ${INSTALL}/usr/lib
ln -sf /emuelec/lib32 ${INSTALL}/usr/lib/arm-linux-gnueabihf
ln -sf /emuelec/lib32/ld-linux-armhf.so.3 ${INSTALL}/usr/lib/ld-linux-armhf.so.3

mkdir -p ${INSTALL}/usr/lib/libretro
cp ${PKG_DIR}/infos/*.info ${INSTALL}/usr/lib/libretro/
}
