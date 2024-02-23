#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

# This variable has to match the version on package.mk
VERSION="data_only"

DATA="https://github.com/british-choi/supertux/archive/${VERSION}.zip"
DATAFOLDER="/storage/roms/ports/supertux"
CONFIGFOLDER="/emuelec/configs/supertux2"

if [ "${EE_DEVICE}" == "OdroidGoAdvance" ] || [ "${EE_DEVICE}" == "RG351P" ] || [ "${EE_DEVICE}" == "RG351V" ] || [ "${EE_DEVICE}" == "GameForce" ]; then
OGAVER=$(oga_ver)
case "${OGAVER}" in
    "OGA" | "OGABE" | "RG351P")
        sed -i "s|(fullscreen_width .*|(fullscreen_width 480)|" ${CONFIGFOLDER}/config
        sed -i "s|(fullscreen_height .*|(fullscreen_height 320)|" ${CONFIGFOLDER}/config
        sed -i "s|(fullscreen_refresh_rate .*|(fullscreen_refresh_rate 60)|" ${CONFIGFOLDER}/config
        sed -i "s|(window_width .*|(window_width 480)|" ${CONFIGFOLDER}/config
        sed -i "s|(window_height .*|(window_height 320)|" ${CONFIGFOLDER}/config
    ;;
    "OGS")
        sed -i "s|(fullscreen_width .*|(fullscreen_width 854)|" ${CONFIGFOLDER}/config
        sed -i "s|(fullscreen_height .*|(fullscreen_height 480)|" ${CONFIGFOLDER}/config
        sed -i "s|(fullscreen_refresh_rate .*|(fullscreen_refresh_rate 60)|" ${CONFIGFOLDER}/config
        sed -i "s|(window_width .*|(window_width 854)|" ${CONFIGFOLDER}/config
        sed -i "s|(window_height .*|(window_height 480)|" ${CONFIGFOLDER}/config
    ;;
    "GF" | "RG351V")
        sed -i "s|(fullscreen_width .*|(fullscreen_width 640)|" ${CONFIGFOLDER}/config
        sed -i "s|(fullscreen_height .*|(fullscreen_height 480)|" ${CONFIGFOLDER}/config
        sed -i "s|(fullscreen_refresh_rate .*|(fullscreen_refresh_rate 60)|" ${CONFIGFOLDER}/config
        sed -i "s|(window_width .*|(window_width 640)|" ${CONFIGFOLDER}/config
        sed -i "s|(window_height .*|(window_height 480)|" ${CONFIGFOLDER}/config
    ;;
esac
fi

mkdir -p "${DATAFOLDER}"
cd "${DATAFOLDER}"

if [ ! -e "${DATAFOLDER}/credits.stxt" ]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -y -w -f 24 -t "데이터가 없습니다!" -m "수퍼 턱스를 처음 실행하거나 데이터 폴더가 없습니다.\n\n데이터는 약200MB이며 인터넷에 연결되어 있어야 합니다.\n\n다운로드하고 계속하시겠습니까?"
    else
    text_viewer -y -w -f 24 -t "Data does not exists!" -m "It seems this is the first time you are launching Super Tux or the data folder does not exists\n\nData is about 200 MB total, and you need to be connected to the internet\n\nDownload and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            rm -rf ${DATAFOLDER}/*
            wget "${DATA}" -O "${VERSION}.zip" -q --show-progress > /dev/tty0 2>&1
            unzip "${VERSION}.zip" > /dev/tty0
            mv supertux-${VERSION}/data/* "${DATAFOLDER}" > /dev/tty0
            rm -rf "supertux-${VERSION}"
            rm "${VERSION}.zip"
            rm "imgui.ini"
            mv ${DATAFOLDER}/levels/misc/menu.stl.in ${DATAFOLDER}/levels/misc/menu.stl
            sed -i "s|@LOGO_FILE@|logo_final.sprite|g" ${DATAFOLDER}/levels/misc/menu.stl
            ee_console disable
           SUPERTUX2_DATA_DIR="${DATAFOLDER}" supertux2
        else
            exit 0
        fi
else
    SUPERTUX2_DATA_DIR="${DATAFOLDER}" SUPERTUX2_USER_DIR="${CONFIGFOLDER}" supertux2
fi

