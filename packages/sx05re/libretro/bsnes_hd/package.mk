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

PKG_NAME="bsnes_hd"
PKG_VERSION="f46b6d6368ea93943a30b5d4e79e8ed51c2da5e8"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/DerKoun/bsnes-hd"
PKG_URL="${PKG_SITE}.git"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Fork of bsnes that adds HD video features."
PKG_TOOLCHAIN="make"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  make -C bsnes -f GNUmakefile target="libretro" compiler="${CXX}" CXXFLAGS="${CXXFLAGS}" platform=linux local=false binary=library
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp bsnes/out/bsnes_hd_beta_libretro.so ${INSTALL}/usr/lib/libretro/
}
