#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

if [ $(get_ee_setting system.language) == "ko_KR" ]; then
text_viewer -t "마지막 EmuELEC 로그!" -f 24 /emuelec/logs/emuelec.log
else
text_viewer -t "Last EmuELEC Log!" -f 24 /emuelec/logs/emuelec.log
fi