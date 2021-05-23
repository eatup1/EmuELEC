# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="es-theme-EmuELEC-carbon"
PKG_VERSION="58f9106ea6ae56f7470c43d99becc80b9090769f"
PKG_SHA256="c556e3b47959ce03f57a94e1214368fe6f6cf97feceb523a4a645631a83d6fb8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/EmuELEC/es-theme-EmuELEC-carbon"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="emuelec"
PKG_SHORTDESC="The EmulationStation theme Carbon Fabrice Caruso's fork with changes for EmuELEC by drixplm"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"

if [ ${PROJECT} = "Amlogic-ng" ] || [ ${PROJECT} = "Amlogic" ]; then
  PKG_PATCH_DIRS="Amlogic"
fi

if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ]; then
  PKG_PATCH_DIRS="OdroidGoAdvance"
fi

make_target() {
  : not
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon
    cp -r * $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon

    # Change to korean font
    sed -i "s|Cabin-Bold.ttf|NanumGothicBold.ttf|" $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon/theme.xml
    sed -i "s|Cabin-Regular.ttf|NanumGothic.ttf|" $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon/theme.xml
#    sed -i "s|Cabin-Bold.ttf|NanumGothicBold.ttf|" $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon/splash.xml
    sed -i "s|Cabin-Bold.ttf|NanumGothicBold.ttf|" $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon/art/grid/previewbar.xml
    cp -r $PKG_DIR/font/* $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon/art
    rm -rf $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon/art/Cabin-Bold.ttf
    rm -rf $INSTALL/usr/config/emulationstation/themes/es-theme-EmuELEC-carbon/art/Cabin-Regular.ttf
}
