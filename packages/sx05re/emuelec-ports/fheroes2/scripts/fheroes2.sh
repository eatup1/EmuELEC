#!/bin/sh

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

DATAFILE="h2demo.zip"
DATA="https://archive.org/download/HeroesofMightandMagicIITheSuccessionWars_1020/${DATAFILE}"
CONFIGFOLDER="/storage/roms/ports/fheroes2"
PORTNAME="Free Heroes of Might and Magic II"
FLAGS=""

mkdir -p "${CONFIGFOLDER}"
cd "${CONFIGFOLDER}"

if [ "$EE_DEVICE" == "Amlogic-ng" ]; then 
    fbfix
fi

if [ ! -e "${CONFIGFOLDER}/DATA/HEROES2.AGG" ]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
        text_viewer -y -w -f 24 -t "데이터가 없습니다!" -m "${PORTNAME}를 처음 실행하거나 데이터 폴더가 없습니다.\n\n데모 데이터는 총 20MB이며 인터넷에 연결되어 있어야 합니다.\n\n\n데모를 다운로드하고 계속하시겠습니까?"
    else
        text_viewer -y -w -f 24 -t "Data does not exists!" -m "It seems this is the first time you are launching ${PORTNAME} or the data folder does not exists\n\nDemo data is about 20 MB total, and you need to be connected to the internet\n\n\nDownload demo and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            clear > /dev/tty0
            cat /etc/motd > /dev/tty0
            echo "Downloading ${PORTNAME} data, please wait..." > /dev/tty0
            wget "${DATA}" -q --show-progress > /dev/tty0 2>&1
            echo "Installing ${PORTNAME} data, please wait..." > /dev/tty0
            unzip -o "${DATAFILE}" -d "${CONFIGFOLDER}/zip" > /dev/tty0
            mv "${CONFIGFOLDER}/zip/DATA" "${CONFIGFOLDER}/DATA" > /dev/tty0 2>&1
            mv "${CONFIGFOLDER}/zip/MAPS" "${CONFIGFOLDER}/MAPS" > /dev/tty0 2>&1
            rm "${DATAFILE}" > /dev/tty0 2>&1
            rm -rf "${CONFIGFOLDER}/zip" > /dev/tty0 2>&1
            echo "Starting ${PORTNAME} for the first time, please wait..." > /dev/tty0
            ee_console disable
            cd "${CONFIGFOLDER}"
            fheroes2 ${FLAGS} > /emuelec/logs/emuelec.log 2>&1
        else
            exit 0
        fi
else
    fheroes2 ${FLAGS} > /emuelec/logs/emuelec.log 2>&1
fi

killall gptokeyb &
