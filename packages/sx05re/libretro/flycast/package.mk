################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="flycast"
if [ "${ARCH}" == "aarch64" -o "${DEVICE}" == "Amlogic-ng" ]; then
PKG_VERSION="aa6c9e21063c929ccf651328547e5c6a9afd1f62"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/flyinghead/flycast"
else
#for RK3326 32bit core
PKG_VERSION="886188804de48a4bd9324046598e8dedfd0d2099"
PKG_ARCH="arm"
PKG_SITE="https://github.com/libretro/flycast"
PKG_LICENSE="GPLv2"
fi
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain ${OPENGLES}"
PKG_SHORTDESC="Flycast is a multiplatform Sega Dreamcast emulator"
if [ "${ARCH}" == "aarch64" -o "${DEVICE}" == "Amlogic-ng" ]; then
PKG_BUILD_FLAGS="-lto"
PKG_TOOLCHAIN="cmake"

PKG_CMAKE_OPTS_TARGET="-DLIBRETRO=ON \
                        -DUSE_OPENMP=OFF \ 
                        -DCMAKE_BUILD_TYPE=Release \
                        -DUSE_GLES2=ON"
else
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-gold"

# Flycast defaults to -O3 but then CHD v5 do not seem to work on EmuELEC so we change it to -O2 to fix the issue
PKG_MAKE_OPTS_TARGET="ARCH=arm HAVE_OPENMP=0 GIT_VERSION=${PKG_VERSION:0:7} FORCE_GLES=1 SET_OPTIM=-O2 HAVE_LTCG=0"
fi

pre_make_target() {
if [ "${ARCH}" == "aarch64" -o "${DEVICE}" == "Amlogic-ng" ]; then
  find $PKG_BUILD -name flags.make -exec sed -i "s:isystem :I:g" \{} \;
  find $PKG_BUILD -name build.ninja -exec sed -i "s:isystem :I:g" \{} \;
else
   export BUILD_SYSROOT=$SYSROOT_PREFIX

  if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_MAKE_OPTS_TARGET+=" FORCE_GLES=1 LDFLAGS=-lrt"
  fi

  if [ "${DEVICE}" == "OdroidGoAdvance" -o "${DEVICE}" == "RG351P" -o "${DEVICE}" == "RG351V" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=classic_armv8_a35"
  fi
fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  if [ "${ARCH}" == "arm" ]; then
	cp flycast_libretro.so $INSTALL/usr/lib/libretro/flycast_32b_libretro.so
  else
	cp flycast_libretro.so $INSTALL/usr/lib/libretro/
  fi
}
