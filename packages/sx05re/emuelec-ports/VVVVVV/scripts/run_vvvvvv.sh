#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023-present Youngjun Choi (https://github.com/british-choi)

# Source predefined functions and variables
. /etc/profile

# This variable has to match the version on data_only branch
VERSION="db15da6327fe7cabaa9d381f8f9e4a05cc7b922b"

DATA="https://github.com/british-choi/VVVVVV/archive/${VERSION}.zip"

DATAFOLDER="/storage/roms/ports/VVVVVV"

mkdir -p "${DATAFOLDER}"
cd "${DATAFOLDER}"

if [ "$EE_DEVICE" == "Amlogic-ng" ]; then 
fbfix
fi

if [ ! -e "${DATAFOLDER}/fonts/README.txt" ]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -y -w -f 24 -t "폰트/언어 데이터가 없습니다!" -m "VVVVVV를 처음 실행하거나 폰트/언어 폴더가 없습니다.\n\n데이터는 약 7MB이며 인터넷에 연결되어 있어야 합니다.\n\n다운로드하고 계속하시겠습니까?"
    else
    text_viewer -y -w -f 24 -t "Fonts/Lang does not exists!" -m "It seems this is the first time you are launching VVVVVV or the Fonts/Lang folder does not exists\n\nData is about 7 MB total, and you need to be connected to the internet\n\nDownload and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            rm -rf ${DATAFOLDER}/fonts/*
	    rm -rf ${DATAFOLDER}/lang/*
            wget "${DATA}" -O "${VERSION}.zip" -q --show-progress > /dev/tty0 2>&1
            unzip "${VERSION}.zip" > /dev/tty0
            mv VVVVVV-${VERSION}/desktop_version/* "${DATAFOLDER}" > /dev/tty0
            rm -rf "VVVVVV-${VERSION}"
            rm "${VERSION}.zip"
            ee_console disable
            # VVVVVV will complain about a missing gamecontrollerdb.txt unless we switch to this folder first
	    cd /storage/.config/SDL-GameControllerDB/
            VVVVVV -langdir /roms/ports/VVVVVV/lang -fontsdir /roms/ports/VVVVVV/fonts
        else
            exit 0
        fi
else
    VVVVVV -langdir /roms/ports/VVVVVV/lang -fontsdir /roms/ports/VVVVVV/fonts
fi

