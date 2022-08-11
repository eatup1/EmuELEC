#!/usr/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Young-jun Choi (https://github.com/british.choi)

# Source predefined functions and variables
. /etc/profile

DATA="http://www.cavestory.org/downloads/cavestoryen.zip"
LANG="https://github.com/british-choi/lang_korean/releases/download/v1.0/lang_korean.tar.gz"
DATAFOLDER="/storage/roms/ports/nxengine"
CONFIGFOLDER="/usr/config/emuelec/configs/nxengine"

mkdir -p "${DATAFOLDER}"
cd "${DATAFOLDER}"

if [ "$EE_DEVICE" == "Amlogic-ng" ]; then 
    fbfix
fi

if [ ! -e "${DATAFOLDER}/Doukutsu.exe" ]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
        text_viewer -y -w -f 24 -t "데이터가 없습니다!" -m "동굴이야기-evo를 처음 실행하거나 데이터 폴더가 없습니다.\n\n데이터는 총 20MB이며 인터넷에 연결되어 있어야 합니다.\n\n\n다운로드하고 계속하시겠습니까?"
    else
        text_viewer -y -w -f 24 -t "Data does not exists!" -m "It seems this is the first time you are launching Cave Story - evo or the data folder does not exists\n\nData is about 20 MB total, and you need to be connected to the internet\n\n\nDownload and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            clear > /dev/tty0
            cat /etc/motd > /dev/tty0
            echo "Downloading Cave Story data, please wait..." > /dev/tty0
            wget "${DATA}" -q --show-progress > /dev/tty0 2>&1
            wget "${LANG}" -q --show-progress > /dev/tty0 2>&1
            echo "Installing Cave Story data, please wait..." > /dev/tty0
            unzip "cavestoryen.zip" > /dev/tty0
            mv ./CaveStory/* "${DATAFOLDER}"
            cp -r /usr/share/nxengine/data "${DATAFOLDER}"
	    mkdir -p "${DATAFOLDER}/data/lang"
	    nxextract /dev/tty0 2>&1
	    tar -zxvf "lang_korean.tar.gz" -C "${DATAFOLDER}/data/lang/" > /dev/tty0 2>&1
            rm -rf "CaveStory" > /dev/tty0 2>&1
            rm "cavestoryen.zip" > /dev/tty0 2>&1
	    rm "lang_korean.tar.gz" > /dev/tty0 2>&1

            case "$(oga_ver)" in
                "OGA"*)
                    cp "${CONFIGFOLDER}/settings_oga.dat" "${DATAFOLDER}/settings.dat"
                ;;
                "OGS")
                    cp "${CONFIGFOLDER}/settings_ogs.dat" "${DATAFOLDER}/settings.dat"
                ;;
                "RG351P")
                    cp "${CONFIGFOLDER}/settings_rg351p.dat" "${DATAFOLDER}/settings.dat"
                ;;
                "RG351V")
                    cp "${CONFIGFOLDER}/settings_rg351v.dat" "${DATAFOLDER}/settings.dat"
                ;;
            esac
            ee_console disable
            gptokeyb -c /emuelec/configs/gptokeyb/nxengine-evo.gptk &
            nxengine-evo > /emuelec/logs/emuelec.log 2>&1
        else
            exit 0
        fi
else
    if [ ! -e "${DATAFOLDER}/settings.dat" ]; then
        case "$(oga_ver)" in
            "OGA"*)
                cp "${CONFIGFOLDER}/settings_oga.dat" "${DATAFOLDER}/settings.dat"
            ;;
            "OGS")
                cp "${CONFIGFOLDER}/settings_ogs.dat" "${DATAFOLDER}/settings.dat"
            ;;
            "RG351P")
                cp "${CONFIGFOLDER}/settings_rg351p.dat" "${DATAFOLDER}/settings.dat"
            ;;
            "RG351V")
                cp "${CONFIGFOLDER}/settings_rg351v.dat" "${DATAFOLDER}/settings.dat"
            ;;
        esac
    fi
    gptokeyb -c /emuelec/configs/gptokeyb/nxengine-evo.gptk &
    nxengine-evo > /emuelec/logs/emuelec.log 2>&1
fi

killall gptokeyb &
