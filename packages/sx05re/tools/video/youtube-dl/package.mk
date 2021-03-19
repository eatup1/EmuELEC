# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="youtube-dl"
PKG_VERSION="2021.03.14"
PKG_SHA256="3595d61a08966b940681842f002cff93e9199dbe1f280775d956762f8fe6b927"
PKG_LICENSE="The Unlicense"
PKG_SITE="https://github.com/ytdl-org/youtube-dl"
PKG_URL="${PKG_SITE}/releases/download/${PKG_VERSION}/youtube-dl"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Command-line program to download videos from YouTube.com and other video sites"
PKG_TOOLCHAIN="manual"

unpack() {
:
}

makeinstall_target() {
mkdir -p ${INSTALL}/usr/bin
cp -rf ${SOURCES}/${PKG_NAME}/${PKG_NAME}-${PKG_VERSION}.youtube-dl ${INSTALL}/usr/bin/youtube-dl
chmod +x ${INSTALL}/usr/bin/youtube-dl
}
