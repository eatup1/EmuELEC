# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="Crystal"
PKG_VERSION="0ae5fe3192db790c9e054349c5e1594a26860ae8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/dm2912/Crystal"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain Crystal-Collections"
PKG_SECTION="emuelec"
PKG_SHORTDESC="Crystal theme for EMUELEC by Dim (dm2912)"
PKG_TOOLCHAIN="manual"
GET_HANDLER_SUPPORT="git"

make_target() {
  : not
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/config/emulationstation/themes/Crystal
    cp -r * $INSTALL/usr/config/emulationstation/themes/Crystal
    rm -rf $INSTALL/usr/config/emulationstation/themes/Crystal/screens.png

    # add korean lang
    cp -r $PKG_DIR/lang/* $INSTALL/usr/config/emulationstation/themes/Crystal/lang

    # Change to korean font
    sed -i "s|Homizio.ttf|NanumGothic.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/gamelists.xml
    sed -i "s|OpenSans-Bold.ttf|NanumGothicExtraBold.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/systemview/common.xml
    sed -i "s|OpenSans-Bold.ttf|NanumGothicExtraBold.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/systemview/details.xml
    sed -i "s|OpenSans-Bold.ttf|NanumGothicExtraBold.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/systemview/horizontal_details.xml
    sed -i "s|OpenSans-Homizio.ttf|NanumGothic.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/gamelists.xml
    sed -i "s|OpenSans-Homizio.ttf|NanumGothic.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/theme.xml
    sed -i "s|OpenSans-Light.ttf|NanumGothic.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/theme.xml
    sed -i "s|OpenSans-Semibold.ttf|NanumGothicBold.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/gamelists.xml
    sed -i "s|OpenSans-Semibold.ttf|NanumGothicBold.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/theme.xml
    sed -i "s|OpenSans-Semi-Bold.ttf|NanumGothicBold.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/systemview/details.xml
    sed -i "s|OpenSans-Semi-Bold.ttf|NanumGothicBold.ttf|" $INSTALL/usr/config/emulationstation/themes/Crystal/systemview/horizontal_details.xml

    # Copy korean nanum font & Remove unused font
    cp -r $PKG_DIR/font/* $INSTALL/usr/config/emulationstation/themes/Crystal/fonts
    rm -rf $INSTALL/usr/config/emulationstation/themes/Crystal/fonts/Homizio.ttf
    rm -rf $INSTALL/usr/config/emulationstation/themes/Crystal/fonts/OpenSans-Bold.ttf
    rm -rf $INSTALL/usr/config/emulationstation/themes/Crystal/fonts/OpenSans-Homizio.ttf
    rm -rf $INSTALL/usr/config/emulationstation/themes/Crystal/fonts/OpenSans-Light.ttf
    rm -rf $INSTALL/usr/config/emulationstation/themes/Crystal/fonts/OpenSans-Semibold.ttf
}
