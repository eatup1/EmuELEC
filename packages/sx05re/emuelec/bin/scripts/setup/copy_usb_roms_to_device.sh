#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

ROMFILE="emuelec_copy_roms_from_here"

function copy_from_where() {
FULLPATHTOROMS="$(find /media/*/roms/ -name ${ROMFILE} -maxdepth 1 | head -n 1)"

if [[ -z "${FULLPATHTOROMS}" ]]; then
	ROMSNOTFOUND="yes"
else
	ROMSNOTFOUND="no"
	PATHTOROMS="${FULLPATHTOROMS%$ROMFILE}"
fi 

echo $PATHTOROMS
}

ROMFOLDER="$(copy_from_where)"

function copy_confirm() {
if [ -z "${ROMFOLDER}" ]; then 
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -e -w -t "에러!" -f 24 -m "\"${ROMFILE}\"파일이 있는 USB 미디어가 연결되어 있지 않습니다! 파일을 만들었습니까?\n\n이 스크립트를 실행하기 전에 USB:/roms 폴더에 \"${ROMFILE}\"(확장자 없음!)이라는 파일(폴더/디렉토리 아님)을 만들어야 합니다! "
    else
    text_viewer -e -w -t "ERROR!" -f 24 -m "No USB media with the file \"${ROMFILE}\" is connected! Did you create the file?\n\nYou need to create a file (NOT A FOLDER/DIRECTORY!) named\n\n\"${ROMFILE}\" (WITH NO EXTENSION!)\n\nin the USB:/roms folder before runing this script! "
    fi
	exit 1
fi
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -y -w -t "USB에서 SD로 ROM복사" -f 24 -m "\"${ROMFOLDER}\"의 모든 파일이 디바이스의 \"/storage/roms\"로 복사됩니다.\n\n디바이스에 충분한 저장 공간이 있는지 확인하십시오!\n\n경고: \"/storage/roms\"에 있는 동일한 이름의 기존 파일을 덮어씁니다.\n\n백업이 생성되지 않습니다!\n\n계속 진행하시겠습니까?"
    else
    text_viewer -y -w -t "Copy roms from USB to SD" -f 24 -m "This will copy all files from \"${ROMFOLDER}\", to \"/storage/roms\" on the device.\n\nMAKE SURE YOU HAVE ENOUGH SPACE IN YOUR DEVICE!\n\nWARNING: Existing files in \"/storage/roms\" with the same name will be overwriten\nNO BACKUP WILL BE CREATED!\n\nare you sure you want to continue?"
    fi
    [[ $? == 21 ]] && copy_roms || exit 0;
 }

function copy_roms() {
	# Sanity checks
	[[ -L "/storage/roms" ]] && rm /storage/roms
	[[ -d /storage/roms2 ]] && mv /storage/roms2 /storage/roms
	[[ ! -d /storage/roms ]] && mkdir -p /storage/roms
	# End sanity
	
    ee_console enable

    echo "Copying, please wait!..." > /dev/tty0
	rsync -ahI --progress "${ROMFOLDER}"* /storage/roms > /dev/tty0
    COPY=$(cat /tmp/copy)
    
    ee_console disable
    
	# Clean up
	[[ -f /storage/roms/${ROMFILE} ]] && rm /storage/roms/${ROMFILE}
	[[ -f /storage/roms/emuelecroms ]] && rm /storage/roms/emuelecroms
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    echo -en "복사 완료!\n\n" >> /tmp/display
    echo -en "장치에서 USB 미디어를 제거하고 YES를 눌러 ES를 재시작합니다.\n\nNO를 누르면 재시작하지 않고 ES로 돌아갑니다!" >> /tmp/display
    echo -en "\n\n\n$COPY" >> /tmp/display
    text_viewer -y -w -t "USB에서 SD로 ROM복사" -f 24 /tmp/display
    else
    echo -en "Copy finished!\n\n" >> /tmp/display
    echo -en "Remove the USB media from the device and press YES to restart ES\n\nPressing NO will return to ES without restarting!" >> /tmp/display
    echo -en "\n\n\n$COPY" >> /tmp/display
    text_viewer -y -w -t "Copy roms from USB to SD" -f 24 /tmp/display
    fi
	if [[ $? == 21 ]]; then
        rm /tmp/display
        ee_console disable
        systemctl restart emustation
    else
        exit 0;
    fi
}

copy_confirm

