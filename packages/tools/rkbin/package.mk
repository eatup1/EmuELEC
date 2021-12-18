# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rkbin"
if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
PKG_VERSION="0bb1c512492386a72a3a0b5a0e18e49c636577b9"
PKG_SHA256="aa37452788219a1fb10ef3cb62b55baccf6baee2b63b9fdc1bfebc2d6fac22e0"
else
# Version is: Kwiboo/tag:libreelec-4563e24
PKG_VERSION="4563e249a3f47e7fcd47a4c3769b6c05683b6e9d"
PKG_SHA256="0b3479117700bce9afea2110c1f027b626c76d99045802218b35a53606547d60"
fi
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/rockchip-linux/rkbin"
PKG_URL="https://github.com/rockchip-linux/rkbin/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="rkbin: Rockchip Firmware and Tool Binaries"
PKG_TOOLCHAIN="manual"
