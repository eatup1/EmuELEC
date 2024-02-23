#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

DATA="https://github.com/mmatyas/supermariowar-data/archive/master.zip"
DATAFOLDER="/storage/roms/ports/smw/data"
CONFIGFOLDER="/emuelec/configs/smw"

mkdir -p "${DATAFOLDER}"
mkdir -p "${CONFIGFOLDER}"
cd "${DATAFOLDER}"

if [ ! -f "${CONFIGFOLDER}/nofakekeyb" ]; then 
    gptokeyb &
    touch "${CONFIGFOLDER}/nofakekeyb"
fi

if [ ! -e "${DATAFOLDER}/worlds/Big JM_Mixed River.txt" ]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -y -w -f 24 -t "데이터가 없습니다!" -m "슈퍼 마리오 워를 처음 실행하거나 데이터 폴더가 없습니다.\n\n데이터는 약30MB이며 인터넷에 연결되어 있어야 합니다.\n\n게임을 처음 실행할 때 가짜 키보드가 설정되어 있으면, 컨트롤러/게임 패드를 설정하고 게임을 재시작해야 합니다.\n\n다운로드하고 계속하시겠습니까?"
    else
    text_viewer -y -w -f 24 -t "Data does not exists!" -m "It seems this is the first time you are launching Super Mario War or the data folder does not exists\n\nData is about 30 MB total, and you need to be connected to the internet\n\nKeep in mind the first time you run the game a fake keyboard is set, you need to set up your controller/gamepad and restart the game.\n\nDownload and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            wget "${DATA}" -q --show-progress > /dev/tty0 2>&1
            unzip "master.zip" > /dev/tty0
            mv supermariowar-data-master/* "${DATAFOLDER}" > /dev/tty0
            rm -rf "supermariowar-data-master" > /dev/tty0 2>&1
            rm "master.zip" > /dev/tty0 2>&1
            rm "imgui.ini" > /dev/tty0 2>&1
            ee_console disable
            cd "${DATAFOLDER}/.."
            smw --datadir "${DATAFOLDER}" > /emuelec/logs/emuelec.log 2>&1
        else
            exit 0
        fi
else
    smw --datadir "${DATAFOLDER}" > /emuelec/logs/emuelec.log 2>&1
fi

killall gptokeyb &
