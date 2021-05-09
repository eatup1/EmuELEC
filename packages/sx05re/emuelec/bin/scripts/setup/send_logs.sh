#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

LOGLINK=$(emueleclogs.sh)
if [ $(get_ee_setting system.language) == "ko_KR" ]; then
text_viewer -w -t "EmuELEC 로그 보내기" -f 24 -m "이 링크를 사용하여 도움을 요청하십시오:\n\n${LOGLINK}"
else
text_viewer -w -t "EmuELEC Send Logs" -f 24 -m "Use this link to ask for help:\n\n${LOGLINK}"
fi