# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="rkbin"
if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
PKG_VERSION="0bb1c512492386a72a3a0b5a0e18e49c636577b9"
PKG_SHA256="aa37452788219a1fb10ef3cb62b55baccf6baee2b63b9fdc1bfebc2d6fac22e0"
else
PKG_VERSION="b0c100f1a260d807df450019774993c761beb79d"
PKG_SHA256="c6ebf8ab556e071e3b067540e95aecff650143f0c97e129cd40c837a4f11a881"
fi
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/rockchip-linux/rkbin"
PKG_URL="https://github.com/rockchip-linux/rkbin/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="rkbin: Rockchip Firmware and Tool Binaries"
PKG_TOOLCHAIN="manual"
