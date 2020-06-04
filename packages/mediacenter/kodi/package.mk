# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-2018 Team LibreELEC (https://libreelec.tv)
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.tv)

PKG_NAME="kodi"
PKG_LICENSE="GPL"
PKG_SITE="http://www.kodi.tv"
PKG_DEPENDS_TARGET="toolchain JsonSchemaBuilder:host TexturePacker:host Python2 zlib systemd lzo pcre swig:host libass curl fontconfig fribidi tinyxml libjpeg-turbo freetype libcdio taglib libxml2 libxslt rapidjson sqlite ffmpeg crossguid giflib libdvdnav libhdhomerun libfmt lirc libfstrcmp flatbuffers:host flatbuffers"
PKG_LONGDESC="A free and open source cross-platform media player."

PKG_PATCH_DIRS="$KODI_VENDOR"

case $KODI_VENDOR in
  amlogic-3.14)
    PKG_VERSION="4ed5bd9dda1bd66a0681e151f269504f571ff8cb"
    PKG_SHA256="798c22646d9bbc8bdfb6074046fe830c0be16b828c406f574ca0fb39626714b3"
    PKG_URL="https://github.com/CoreELEC/xbmc/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_NAME="kodi-$PKG_VERSION.tar.gz"
    PKG_PATCH_DIRS="default coreelec"
    ;;
  amlogic-4.9)
    PKG_VERSION="8426e66a32ef11064928dfcb490bd379d2e13b59"
    PKG_SHA256="91e10a8f136cb57e9427386bd2df5a07b1c7abd6988d8d74f367a9e0e6970335"
    PKG_URL="https://github.com/CoreELEC/xbmc/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_NAME="kodi-$PKG_VERSION.tar.gz"
    PKG_PATCH_DIRS="default coreelec"
    ;;
  raspberrypi)
    PKG_VERSION="newclock5_18.7-Leia"
    PKG_SHA256="af87ba596aac26dd160e36bd4a15b108da1f2a551df61c6bcbc0daaff67cc59f"
    PKG_URL="https://github.com/popcornmix/xbmc/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_NAME="kodi-$KODI_VENDOR-$PKG_VERSION.tar.gz"
    ;;
  raspberrypi4)
    PKG_VERSION="leia_pi4_18.7-Leia"
    PKG_SHA256="661dc4b425ea6a6fd44be27ed037a03d92e91dd6e5ce74ce2813148f1de952ca"
    PKG_URL="https://github.com/popcornmix/xbmc/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_NAME="kodi-$KODI_VENDOR-$PKG_VERSION.tar.gz"
    ;;
  rockchip)
    PKG_VERSION="rockchip_18.7-Leia"
    PKG_SHA256="92b081ce7091040ee7e0615dcf9a4dfab00a1b1162d3cdcaa0f51aa180e12ec7"
    PKG_URL="https://github.com/kwiboo/xbmc/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_NAME="kodi-$KODI_VENDOR-$PKG_VERSION.tar.gz"
    ;;
  *)
    PKG_VERSION="18.7-Leia"
    PKG_SHA256="f6bb2ad9d8ca27d1b6bf68690d699f5e2bf3d0c7e5700d8e564b7583054c434e"
    PKG_URL="https://github.com/xbmc/xbmc/archive/$PKG_VERSION.tar.gz"
    PKG_SOURCE_NAME="kodi-$PKG_VERSION.tar.gz"
    ;;
esac

if [ "$PROJECT" = "RPi" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
fi

configure_package() {
  # Single threaded LTO is very slow so rely on Kodi for parallel LTO support
  if [ "$LTO_SUPPORT" = "yes" ] && ! build_with_debug; then
    PKG_KODI_USE_LTO="-DUSE_LTO=$CONCURRENCY_MAKE_LEVEL"
  fi

  get_graphicdrivers

  if [ "$TARGET_ARCH" = "x86_64" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pciutils"
  fi

  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET dbus"

  if [ "$DISPLAYSERVER" = "x11" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libX11 libXext libdrm libXrandr"
    KODI_XORG="-DCORE_PLATFORM_NAME=x11"
  elif [ "$DISPLAYSERVER" = "weston" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET wayland waylandpp"
    CFLAGS="$CFLAGS -DMESA_EGL_NO_X11_HEADERS"
    CXXFLAGS="$CXXFLAGS -DMESA_EGL_NO_X11_HEADERS"
    KODI_XORG="-DCORE_PLATFORM_NAME=wayland -DWAYLAND_RENDER_SYSTEM=gles"
  fi

  if [ ! "$OPENGL" = "no" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL glu"
  fi

  if [ "$OPENGLES_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGLES"
  fi

  if [ "$ALSA_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET alsa-lib"
    KODI_ALSA="-DENABLE_ALSA=ON"
  else
    KODI_ALSA="-DENABLE_ALSA=OFF"
 fi

  if [ "$PULSEAUDIO_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pulseaudio"
    KODI_PULSEAUDIO="-DENABLE_PULSEAUDIO=ON"
  else
    KODI_PULSEAUDIO="-DENABLE_PULSEAUDIO=OFF"
  fi

  if [ "$ESPEAK_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET espeak"
  fi

  if [ "$CEC_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libcec"
    KODI_CEC="-DENABLE_CEC=ON"
  else
    KODI_CEC="-DENABLE_CEC=OFF"
  fi

  if [ "$CEC_FRAMEWORK_SUPPORT" = "yes" ]; then
    PKG_PATCH_DIRS+=" cec-framework"
  fi

  if [ "$KODI_OPTICAL_SUPPORT" = yes ]; then
    KODI_OPTICAL="-DENABLE_OPTICAL=ON"
  else
    KODI_OPTICAL="-DENABLE_OPTICAL=OFF"
  fi

  if [ "$KODI_DVDCSS_SUPPORT" = yes ]; then
    KODI_DVDCSS="-DENABLE_DVDCSS=ON \
                 -DLIBDVDCSS_URL=$SOURCES/libdvdcss/libdvdcss-$(get_pkg_version libdvdcss).tar.gz"
  else
    KODI_DVDCSS="-DENABLE_DVDCSS=OFF"
  fi

  if [ "$KODI_BLURAY_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libbluray"
    KODI_BLURAY="-DENABLE_BLURAY=ON"
  else
    KODI_BLURAY="-DENABLE_BLURAY=OFF"
  fi

  if [ "$AVAHI_DAEMON" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi nss-mdns"
    KODI_AVAHI="-DENABLE_AVAHI=ON"
  else
    KODI_AVAHI="-DENABLE_AVAHI=OFF"
  fi

  case "$KODI_MYSQL_SUPPORT" in
    mysql)   PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET mysql"
             KODI_MYSQL="-DENABLE_MYSQLCLIENT=ON -DENABLE_MARIADBCLIENT=OFF"
             ;;
    mariadb) PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET mariadb-connector-c"
             KODI_MYSQL="-DENABLE_MARIADBCLIENT=ON -DENABLE_MYSQLCLIENT=OFF"
             ;;
    *)       KODI_MYSQL="-DENABLE_MYSQLCLIENT=OFF -DENABLE_MARIADBCLIENT=OFF"
  esac

  if [ "$KODI_AIRPLAY_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libplist"
    KODI_AIRPLAY="-DENABLE_PLIST=ON"
  else
    KODI_AIRPLAY="-DENABLE_PLIST=OFF"
  fi

  if [ "$KODI_AIRTUNES_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libshairplay"
    KODI_AIRTUNES="-DENABLE_AIRTUNES=ON"
  else
    KODI_AIRTUNES="-DENABLE_AIRTUNES=OFF"
  fi

  if [ "$KODI_NFS_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libnfs"
    KODI_NFS="-DENABLE_NFS=ON"
  else
    KODI_NFS="-DENABLE_NFS=OFF"
  fi

  if [ "$KODI_SAMBA_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET samba"
  fi

  if [ "$KODI_WEBSERVER_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libmicrohttpd"
  fi

  if [ "$KODI_UPNP_SUPPORT" = yes ]; then
    KODI_UPNP="-DENABLE_UPNP=ON"
  else
    KODI_UPNP="-DENABLE_UPNP=OFF"
  fi

  if target_has_feature neon; then
    KODI_NEON="-DENABLE_NEON=ON"
  else
    KODI_NEON="-DENABLE_NEON=OFF"
  fi

  if [ "$VDPAU_SUPPORT" = "yes" -a "$DISPLAYSERVER" = "x11" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
    KODI_VDPAU="-DENABLE_VDPAU=ON"
  else
    KODI_VDPAU="-DENABLE_VDPAU=OFF"
  fi

  if [ "$VAAPI_SUPPORT" = yes ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva"
    KODI_VAAPI="-DENABLE_VAAPI=ON"
  else
    KODI_VAAPI="-DENABLE_VAAPI=OFF"
  fi

  if [ "$TARGET_ARCH" = "x86_64" ]; then
    KODI_ARCH="-DWITH_CPU=$TARGET_ARCH"
  else
    KODI_ARCH="-DWITH_ARCH=$TARGET_ARCH"
  fi

  if [ "$PROJECT" = "Amlogic" -o "$PROJECT" = "Amlogic-ng" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET amlogic.displayinfo"
  fi

  if [ "$DEVICE" = "Slice" -o "$DEVICE" = "Slice3" ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET led_tools"
  fi

  if [ ! "$KODIPLAYER_DRIVER" = default ]; then
    PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $KODIPLAYER_DRIVER libinput libxkbcommon"
    if [ "$KODIPLAYER_DRIVER" = bcm2835-driver ]; then
      KODI_PLAYER="-DCORE_PLATFORM_NAME=rbpi"
    elif [ "$OPENGLES_SUPPORT" = yes -a "$KODIPLAYER_DRIVER" = "$OPENGLES" ]; then
      KODI_PLAYER="-DCORE_PLATFORM_NAME=gbm -DGBM_RENDER_SYSTEM=gles"
      CFLAGS="$CFLAGS -DMESA_EGL_NO_X11_HEADERS"
      CXXFLAGS="$CXXFLAGS -DMESA_EGL_NO_X11_HEADERS"
    elif [ "$KODIPLAYER_DRIVER" = libamcodec ]; then
      KODI_PLAYER="-DCORE_PLATFORM_NAME=aml"
    fi
  fi

  KODI_LIBDVD="$KODI_DVDCSS \
               -DLIBDVDNAV_URL=$SOURCES/libdvdnav/libdvdnav-$(get_pkg_version libdvdnav).tar.gz \
               -DLIBDVDREAD_URL=$SOURCES/libdvdread/libdvdread-$(get_pkg_version libdvdread).tar.gz"

  PKG_CMAKE_OPTS_TARGET="-DNATIVEPREFIX=$TOOLCHAIN \
                         -DWITH_TEXTUREPACKER=$TOOLCHAIN/bin/TexturePacker \
                         -DWITH_JSONSCHEMABUILDER=$TOOLCHAIN/bin/JsonSchemaBuilder \
                         -DDEPENDS_PATH=$PKG_BUILD/depends \
                         -DPYTHON_EXECUTABLE=$TOOLCHAIN/bin/$PKG_PYTHON_VERSION \
                         -DPYTHON_INCLUDE_DIRS=$SYSROOT_PREFIX/usr/include/$PKG_PYTHON_VERSION \
                         -DGIT_VERSION=$PKG_VERSION \
                         -DWITH_FFMPEG=$(get_build_dir ffmpeg) \
                         -DENABLE_INTERNAL_FFMPEG=OFF \
                         -DFFMPEG_INCLUDE_DIRS=$SYSROOT_PREFIX/usr \
                         -DENABLE_INTERNAL_CROSSGUID=OFF \
                         -DENABLE_UDEV=ON \
                         -DENABLE_DBUS=ON \
                         -DENABLE_XSLT=ON \
                         -DENABLE_CCACHE=ON \
                         -DENABLE_LIRCCLIENT=ON \
                         -DENABLE_EVENTCLIENTS=ON \
                         -DENABLE_LDGOLD=ON \
                         -DENABLE_DEBUGFISSION=OFF \
                         -DENABLE_APP_AUTONAME=OFF \
                         -DENABLE_INTERNAL_FLATBUFFERS=OFF \
                         $PKG_KODI_USE_LTO \
                         $KODI_ARCH \
                         $KODI_NEON \
                         $KODI_VDPAU \
                         $KODI_VAAPI \
                         $KODI_CEC \
                         $KODI_XORG \
                         $KODI_SAMBA \
                         $KODI_NFS \
                         $KODI_LIBDVD \
                         $KODI_AVAHI \
                         $KODI_UPNP \
                         $KODI_MYSQL \
                         $KODI_AIRPLAY \
                         $KODI_AIRTUNES \
                         $KODI_OPTICAL \
                         $KODI_BLURAY \
                         $KODI_PLAYER"
}

pre_configure_target() {
  export LIBS="$LIBS -lncurses"
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin/kodi
  rm -rf $INSTALL/usr/bin/kodi-standalone
  rm -rf $INSTALL/usr/bin/xbmc
  rm -rf $INSTALL/usr/bin/xbmc-standalone
  rm -rf $INSTALL/usr/share/kodi/cmake
  rm -rf $INSTALL/usr/share/applications
  rm -rf $INSTALL/usr/share/icons
  rm -rf $INSTALL/usr/share/pixmaps
  rm -rf $INSTALL/usr/share/kodi/addons/skin.estouchy
  rm -rf $INSTALL/usr/share/kodi/addons/skin.estuary
  rm -rf $INSTALL/usr/share/kodi/addons/service.xbmc.versioncheck
  rm -rf $INSTALL/usr/share/kodi/addons/visualization.vortex
  rm -rf $INSTALL/usr/share/xsessions

  mkdir -p $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi-config $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi-after $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi-safe-mode $INSTALL/usr/lib/kodi
    cp $PKG_DIR/scripts/kodi.sh $INSTALL/usr/lib/kodi

    # Configure safe mode triggers - default 5 restarts within 900 seconds/15 minutes
    sed -e "s|@KODI_MAX_RESTARTS@|${KODI_MAX_RESTARTS:-5}|g" \
        -e "s|@KODI_MAX_SECONDS@|${KODI_MAX_SECONDS:-900}|g" \
        -i $INSTALL/usr/lib/kodi/kodi.sh

  mkdir -p $INSTALL/usr/sbin
    cp $PKG_DIR/scripts/service-addon-wrapper $INSTALL/usr/sbin

  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/kodi-remote $INSTALL/usr/bin
    cp $PKG_DIR/scripts/setwakeup.sh $INSTALL/usr/bin
    cp $PKG_DIR/scripts/pastekodi $INSTALL/usr/bin
    ln -sf /usr/bin/pastekodi $INSTALL/usr/bin/pastecrash

  mkdir -p $INSTALL/usr/share/kodi/addons
    cp -R $PKG_DIR/config/os.openelec.tv $INSTALL/usr/share/kodi/addons
    sed -e "s|@OS_VERSION@|$OS_VERSION|g" -i $INSTALL/usr/share/kodi/addons/os.openelec.tv/addon.xml
    cp -R $PKG_DIR/config/os.libreelec.tv $INSTALL/usr/share/kodi/addons
    sed -e "s|@OS_VERSION@|$OS_VERSION|g" -i $INSTALL/usr/share/kodi/addons/os.libreelec.tv/addon.xml
    cp -R $PKG_DIR/config/repository.coreelec $INSTALL/usr/share/kodi/addons/$ADDON_REPO_ID
    sed -e "s|@ADDON_URL@|$ADDON_URL|g" -i $INSTALL/usr/share/kodi/addons/$ADDON_REPO_ID/addon.xml
    sed -e "s|@ADDON_REPO_ID@|$ADDON_REPO_ID|g" -i $INSTALL/usr/share/kodi/addons/$ADDON_REPO_ID/addon.xml
    sed -e "s|@ADDON_REPO_NAME@|$ADDON_REPO_NAME|g" -i $INSTALL/usr/share/kodi/addons/$ADDON_REPO_ID/addon.xml
    sed -e "s|@ADDON_REPO_VERSION@|$ADDON_REPO_VERSION|g" -i $INSTALL/usr/share/kodi/addons/$ADDON_REPO_ID/addon.xml

  mkdir -p $INSTALL/usr/share/kodi/config

  ln -sf /run/libreelec/cacert.pem $INSTALL/usr/share/kodi/system/certs/cacert.pem

  mkdir -p $INSTALL/usr/share/kodi/system/settings

  $PKG_DIR/scripts/xml_merge.py $PKG_DIR/config/guisettings.xml \
                                $PROJECT_DIR/$PROJECT/kodi/guisettings.xml \
                                $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/guisettings.xml \
                                > $INSTALL/usr/share/kodi/config/guisettings.xml

  $PKG_DIR/scripts/xml_merge.py $PKG_DIR/config/sources.xml \
                                $PROJECT_DIR/$PROJECT/kodi/sources.xml \
                                $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/sources.xml \
                                > $INSTALL/usr/share/kodi/config/sources.xml

  $PKG_DIR/scripts/xml_merge.py $PKG_DIR/config/advancedsettings.xml \
                                $PROJECT_DIR/$PROJECT/kodi/advancedsettings.xml \
                                $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/advancedsettings.xml \
                                > $INSTALL/usr/share/kodi/system/advancedsettings.xml

  $PKG_DIR/scripts/xml_merge.py $PKG_DIR/config/appliance.xml \
                                $PROJECT_DIR/$PROJECT/kodi/appliance.xml \
                                $PROJECT_DIR/$PROJECT/devices/$DEVICE/kodi/appliance.xml \
                                > $INSTALL/usr/share/kodi/system/settings/appliance.xml

  # update addon manifest
  ADDON_MANIFEST=$INSTALL/usr/share/kodi/system/addon-manifest.xml
  xmlstarlet ed -L -d "/addons/addon[text()='service.xbmc.versioncheck']" $ADDON_MANIFEST
  xmlstarlet ed -L -d "/addons/addon[text()='skin.estouchy']" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "os.libreelec.tv" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "os.openelec.tv" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "$ADDON_REPO_ID" $ADDON_MANIFEST
  xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "service.coreelec.settings" $ADDON_MANIFEST

  if [ "$DRIVER_ADDONS_SUPPORT" = "yes" ]; then
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "script.program.driverselect" $ADDON_MANIFEST
  fi

  if [ "$PROJECT" = "Amlogic-ng" -o "$PROJECT" = "Amlogic" ]; then
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "script.amlogic.displayinfo" $ADDON_MANIFEST
  fi

  if [ "$DEVICE" = "Slice" -o "$DEVICE" = "Slice3" ]; then
    xmlstarlet ed -L --subnode "/addons" -t elem -n "addon" -v "service.slice" $ADDON_MANIFEST
  fi

  # more binaddons cross compile badness meh
  sed -e "s:INCLUDE_DIR /usr/include/kodi:INCLUDE_DIR $SYSROOT_PREFIX/usr/include/kodi:g" \
      -e "s:CMAKE_MODULE_PATH /usr/lib/kodi /usr/share/kodi/cmake:CMAKE_MODULE_PATH $SYSROOT_PREFIX/usr/share/kodi/cmake:g" \
      -i $SYSROOT_PREFIX/usr/share/kodi/cmake/KodiConfig.cmake

  if [ "$KODI_EXTRA_FONTS" = yes ]; then
    mkdir -p $INSTALL/usr/share/kodi/media/Fonts
      cp $PKG_DIR/fonts/*.ttf $INSTALL/usr/share/kodi/media/Fonts
  fi

  debug_strip $INSTALL/usr/lib/kodi/kodi.bin
}

post_install() {
  enable_service kodi.target
  enable_service kodi-autostart.service
  enable_service kodi-cleanlogs.service
  enable_service kodi-halt.service
  enable_service kodi-poweroff.service
  enable_service kodi-reboot.service
  enable_service kodi-waitonnetwork.service
  enable_service kodi.service
  enable_service kodi-lirc-suspend.service
  enable_service kodi-cleanpackagecache.service
}
