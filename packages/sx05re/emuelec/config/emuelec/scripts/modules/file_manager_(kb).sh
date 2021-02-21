#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

. /etc/profile

if [[ "$EE_DEVICE" == "OdroidGoAdvance" || "$EE_DEVICE" == "RG351P" ]] || [[ "$EE_DEVICE" == "GameForce" ]]; then
    cd /usr/bin
    case "$(oga_ver)" in
        "OGS")
            DinguxCommander.ogs
        ;;
        *)
            DinguxCommander
        ;;
    esac
else
    source /emuelec/scripts/env.sh
    joy2keyStart
    mc -a
    joy2keyStop
fi
