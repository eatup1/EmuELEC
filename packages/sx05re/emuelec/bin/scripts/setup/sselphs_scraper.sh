#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

ee_console enable

function scrape_confirm() {
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
	text_viewer -y -w -t "Sselph의 스크래퍼" -f 24 -m "에뮬레이션스태이션이 종료되고 Sselph의 스크래퍼가 실행됩니다. 계속 하시겠습니까?\n\n스크래핑 메뉴를 사용하려면 키보드가 필요합니다."
    else
	text_viewer -y -w -t "Sselph's Scraper" -f 24 -m "This will Kill Emulationstation and will start Sselph's Scraper, do you want to continue?\n\nYou will need a keyboard to be able to use the scraping menu"
    fi
    [[ $? == 21 ]] && start_scraper || exit 0;
 }

function start_scraper() {
ee_console enable
systemd-run bash /usr/bin/modules/scraper.start
systemctl stop emustation
}

ee_console disable
scrape_confirm

