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

PKG_NAME="nxengine"
<<<<<<< HEAD
PKG_VERSION="4c9f87898485f0a3063827c9d313b52cf6a9b19a"
PKG_SHA256="d6d8cf49dc41c5a4add6b582b8aa280317c7d0931789ddcd514575353ef6ed32"
=======
PKG_VERSION="e271c6262d73f07e5d92d285503f1c049801c51a"
PKG_SHA256="221873fe0f8eca81100d355eea379de70030fb20c9afec35f7d675bf2840f044"
>>>>>>> 3efb27cbb9feccb536f4dfd3fc10cc6df09141de
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/british-choi/nxengine-libretro"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="Port of NxEngine to libretro - Cave Story game engine clone"
PKG_LONGDESC="A complete open-source clone/rewrite of the masterpiece jump-and-run platformer Doukutsu Monogatari (also known as Cave Story)."

PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"

pre_configure_target() {
  sed -i -e "s/CC         = gcc//" Makefile
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp nxengine_libretro.so $INSTALL/usr/lib/libretro/
}
