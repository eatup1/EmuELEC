#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

. /etc/profile

BIN="351Files"

init_port ${BIN} "default"

gptokeyb -c "/emuelec/configs/gptokeyb/${BIN}.gptk" &

if [ "$EE_DEVICE" == "OdroidGoAdvance" -o "$EE_DEVICE" == "RG351P" -o "$EE_DEVICE" == "RG351V" ] || [ "$EE_DEVICE" == "GameForce" ]; then
    
    clear >/dev/console
    
    case "$(oga_ver)" in
    "OGA"*|"RG351P")
        ${BIN} 480 320 14 24 24
    ;;
    "OGS")
        ${BIN} 854 480 14 24 24
    ;;
    "GF"|"RG351V")
        ${BIN} 640 480 14 24 24
    ;;
        esac
else
    ${BIN}
fi

end_port
