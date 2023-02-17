# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="fbneo"
PKG_VERSION="868dee240104ed2ba3b74ec0bc3c9f467fb284f8"
PKG_SHA256="593c68179577e403dadc2de98a83c38371719b70e93da77e5b17eb06a1f6000e"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/FBNeo"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="libretro"
PKG_SHORTDESC="Port of Final Burn Neo to Libretro (v1.0.0.3)."
PKG_LONGDESC="Currently, FB neo supports games on Capcom CPS-1 and CPS-2 hardware, SNK Neo-Geo hardware, Toaplan hardware, Cave hardware, and various games on miscellaneous hardware. "
PKG_TOOLCHAIN="make"


pre_configure_target() {
sed -i "s|LDFLAGS += -static-libgcc -static-libstdc++|LDFLAGS += -static-libgcc|"  ./src/burner/libretro/Makefile

PKG_MAKE_OPTS_TARGET=" -C ./src/burner/libretro USE_CYCLONE=0 profile=performance"

if [[ "$TARGET_FPU" =~ "neon" ]]; then
	PKG_MAKE_OPTS_TARGET+=" HAVE_NEON=1"
fi

if [ "$DEVICE" == "OdroidGoAdvance" -o "$DEVICE" == "RG351P" -o "$DEVICE" == "RG351V" ] || [ "$DEVICE" == "GameForce" ]; then
	if [ "$ARCH" == "arm" ]; then
	PKG_MAKE_OPTS_TARGET+=" platform=classic_armv8_a35"
	fi
fi
perl ./src/dep/scripts/gamelist.pl -o ./src/dep/generated/driverlist.h ./src/burn/drv/atari ./src/burn/drv/capcom ./src/burn/drv/cave ./src/burn/drv/channelf ./src/burn/drv/coleco ./src/burn/drv/cps3 ./src/burn/drv/dataeast ./src/burn/drv/galaxian ./src/burn/drv/irem ./src/burn/drv/konami ./src/burn/drv/megadrive ./src/burn/drv/midway ./src/burn/drv/msx ./src/burn/drv/neogeo ./src/burn/drv/pce ./src/burn/drv/pgm ./src/burn/drv/pst90s ./src/burn/drv/pre90s ./src/burn/drv/psikyo ./src/burn/drv/sega ./src/burn/drv/sg1000 ./src/burn/drv/spectrum ./src/burn/drv/taito ./src/burn/drv/toaplan  ./src/burn/drv/sms ./src/burn/drv/nes ./src/burn/drv
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp $PKG_BUILD/src/burner/libretro/fbneo_libretro.so $INSTALL/usr/lib/libretro/
}
