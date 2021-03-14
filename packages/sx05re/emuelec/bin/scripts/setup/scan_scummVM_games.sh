#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

function restart_confirm() {
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -y -w -t "ScummVM 게임 스캔 완료" -f 24 -m "ScummVM 게임 스캔 완료, 다음번 에뮬레이션스태이션을 재시작할 때 발견된 모든 게임이 나타납니다!\n\n지금 재시작 하시겠습니까?"
    else
    text_viewer -y -w -t "ScummVM scan completed" -f 24 -m "ScummVM scan completed, any found games will appear next time you restart Emulationstation!\n\nDo you wish to restart now?"
    fi
	[[ $? == 21 ]] && systemctl restart emustation || exit 0; 
}

ee_console enable
bash /usr/bin/scummvm.start add
bash /usr/bin/scummvm.start create
ee_console disable
restart_confirm
