#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

DATA="https://github.com/drfiemost/Hurrican/archive/refs/heads/master.zip"
DATAFOLDER="/storage/roms/ports/hurrican/data"
CONFIGFOLDER="/storage/roms/ports/hurrican"

mkdir -p "${DATAFOLDER}"
mkdir -p "${CONFIGFOLDER}/lang"
cd "${CONFIGFOLDER}"

if [ "${EE_DEVICE}" != "Amlogic-ng" ]; then 
    gptokeyb -c /emuelec/configs/gptokeyb/hurrican.gptk &
    FLAGS=" --depth 16 --lowres"
fi

if [ ! -e "${DATAFOLDER}/levels/levellist.dat" ]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
        text_viewer -y -w -f 24 -t "데이터 없음!" -m "허리케인을 처음 실행하거나 데이터 폴더가 존재하지 않습니다.\n\n데이터는 총 95MB이며 인터넷에 연결되어 있어야 합니다.\n\n\n다운로드하고 계속하시겠습니까?"
    else
        text_viewer -y -w -f 24 -t "Data does not exists!" -m "It seems this is the first time you are launching Hurrican or the data folder does not exists\n\nData is about 95 MB total, and you need to be connected to the internet\n\n\nDownload and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            clear > /dev/tty0
            cat /etc/motd > /dev/tty0
            echo "Downloading Hurrican data, please wait..." > /dev/tty0
            rm -rf "${DATAFOLDER}"
            rm -rf "/storage/roms/ports/hurrican/lang"
            wget "${DATA}" -q --show-progress > /dev/tty0 2>&1
            echo "Installing Hurrican data, please wait..." > /dev/tty0
            unzip "master.zip" "Hurrican-master/Hurrican/data/*" -d "${CONFIGFOLDER}"
            unzip "master.zip" "Hurrican-master/Hurrican/lang/*.lng" -d "${CONFIGFOLDER}"
            mv "Hurrican-master/Hurrican/data" "${CONFIGFOLDER}"
            mv "Hurrican-master/Hurrican/lang" "${CONFIGFOLDER}"
            rm -rf "Hurrican-master" > /dev/tty0 2>&1
            rm "master.zip" > /dev/tty0 2>&1
            ee_console disable
            cd "${CONFIGFOLDER}"
            hurrican ${FLAGS} > /emuelec/logs/emuelec.log 2>&1
        else
            exit 0
        fi
else
    hurrican ${FLAGS} > /emuelec/logs/emuelec.log 2>&1
fi

