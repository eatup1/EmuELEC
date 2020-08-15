# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="es-theme-EmuELEC-carbon"
PKG_VERSION="750d5b7e29f595c6699cec0ec911c0cba1c14810"
PKG_SHA256="f90d3595389af09ba5a2d2aeafbf286e4fdccc83691c9acbcdfb598ee43a21d2"
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
