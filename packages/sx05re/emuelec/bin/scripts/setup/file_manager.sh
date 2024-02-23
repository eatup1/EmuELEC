#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

. /etc/profile
BIN="351Files"

init_port ${BIN} "default"

gptokeyb -c "/emuelec/configs/gptokeyb/${BIN}.gptk" &

clear >/dev/console
ee_console disable

if [ "${EE_DEVICE}" == "OdroidGoAdvance" ] || [ "${EE_DEVICE}" == "RG351P" ] || [ "${EE_DEVICE}" == "RG351V" ] || [ "${EE_DEVICE}" == "GameForce" ]; then
    
    clear >/dev/console
    
    # 351Files SCREEN_WIDTH SCREEN_HEIGHT FONT_SIZE LINE_HEIGHT ICON_SIZE MARGIN_X KEYBOARD_MARGIN KEYBOARD_KEY_SPACING
    case "$(oga_ver)" in
    "OGA"*|"RG351P")
        ${BIN} 480 320 14 24 24 8 3 3
    ;;
    "OGS")
        ${BIN} 854 480 20 32 24 10 8 4
    ;;
    "GF"|"RG351V")
        ${BIN} 640 480 20 32 24 10 8 4
    ;;
        esac
else
    ${BIN}
fi

end_port
