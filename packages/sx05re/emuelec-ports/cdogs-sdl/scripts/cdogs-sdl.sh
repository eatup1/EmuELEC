#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

DATAFILE="C-Dogs.SDL-1.5.0-Linux.tar.gz"
DATA="https://github.com/cxong/cdogs-sdl/releases/download/1.5.0/${DATAFILE}"
CONFIGFOLDER="/storage/roms/ports/cdogs-sdl"
PORTNAME="Cdogs-sdl"
FLAGS=""

mkdir -p "${CONFIGFOLDER}"
cd "${CONFIGFOLDER}"

if [ "$EE_DEVICE" == "Amlogic-ng" ]; then 
    fbfix
fi

if [ ! -e "${CONFIGFOLDER}/data/ammo.json" ]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
        text_viewer -y -w -f 24 -t "데이터 없음!" -m "${PORTNAME}을 처음 실행하거나 데이터 폴더가 존재하지 않습니다.\n\n데이터는 총 35MB이며 인터넷에 연결되어 있어야 합니다.\n\n\n다운로드하고 계속하시겠습니까?"
    else
        text_viewer -y -w -f 24 -t "Data does not exists!" -m "It seems this is the first time you are launching ${PORTNAME} or the data folder does not exists\n\nData is about 35 MB total, and you need to be connected to the internet\n\n\nDownload and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            clear > /dev/tty0
            cat /etc/motd > /dev/tty0
            echo "Downloading ${PORTNAME} data, please wait..." > /dev/tty0
            wget "${DATA}" -q --show-progress > /dev/tty0 2>&1
            echo "Installing ${PORTNAME} data, please wait..." > /dev/tty0
            tar -xvf "${DATAFILE}" -C "${CONFIGFOLDER}" > /dev/tty0
            mv C-Dogs.SDL-1.5.0-Linux/* "${CONFIGFOLDER}"
            rm -rf C-Dogs.SDL-1.5.0-Linux bin share > /dev/tty0 2>&1
            rm "${DATAFILE}" > /dev/tty0 2>&1
            echo "Starting ${PORTNAME} for the first time, please wait..." > /dev/tty0
            ee_console disable
            cd "${CONFIGFOLDER}"
            cdogs-sdl ${FLAGS} > /emuelec/logs/emuelec.log 2>&1
        else
            exit 0
        fi
else
    cdogs-sdl ${FLAGS} > /emuelec/logs/emuelec.log 2>&1
fi

killall gptokeyb &
