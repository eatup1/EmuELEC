# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="openbor"
PKG_VERSION="f5261e7cb97786909276c0b87f8f9f63504d2844"
PKG_SHA256="585e57a406cb2c1f2205c1075ed046309d37c8d2e42c4ca58e9abb843be2eae5"
PKG_ARCH="any"
PKG_SITE="https://github.com/DCurrent/openbor"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2-git libogg libvorbisidec libvpx libpng"
PKG_SHORTDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more! "
PKG_LONGDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more! "
PKG_TOOLCHAIN="make"

if [ "$DEVICE" == "OdroidGoAdvance" ] || [ "$DEVICE" == "GameForce" ]; then
PKG_PATCH_DIRS="OdroidGoAdvance"
elif [ "$DEVICE" == "RG351P" ] || [ "$DEVICE" == "RG351V" ]; then
PKG_PATCH_DIRS="RG351"
fi

pre_configure_target() {
  PKG_MAKE_OPTS_TARGET="BUILD_LINUX_LE_arm=1 \
                        -C ${PKG_BUILD}/engine \
                        SDKPATH="${SYSROOT_PREFIX}"
                        PREFIX=${TARGET_NAME}"
  sed -i "s|\$(LNXDEV)/\$(PREFIX)strip|\$(PREFIX)-strip|" $PKG_BUILD/engine/Makefile
}

pre_make_target() {
cd $PKG_BUILD/engine
./version.sh
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp `find . -name "OpenBOR.elf" | xargs echo` $INSTALL/usr/bin/OpenBOR
    cp $PKG_DIR/scripts/*.sh $INSTALL/usr/bin
    chmod +x $INSTALL/usr/bin/*
    mkdir -p $INSTALL/usr/config/emuelec/configs/openbor
    if [ "$DEVICE" == "RG351P" ]; then
	cp $PKG_DIR/config/master_rg351p.cfg $INSTALL/usr/config/emuelec/configs/openbor/master.cfg
    elif [ "$DEVICE" == "RG351V" ]; then
	cp $PKG_DIR/config/master_rg351v.cfg $INSTALL/usr/config/emuelec/configs/openbor/master.cfg
    else
	cp $PKG_DIR/config/master.cfg $INSTALL/usr/config/emuelec/configs/openbor/master.cfg
    fi
   } 
