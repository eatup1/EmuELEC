#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

DIABLOPATH="/storage/.local/share/diasurgical/devilution"
DIABLOMPQPATH="/usr/local/share/diasurgical/devilutionx"
DIABLOROMPATH="/storage/roms/ports/diablo"

mkdir -p ${DIABLOPATH}

if [ -e ${DIABLOMPQPATH}/devilutionx.mpq ]; then
    if [ ! -L ${DIABLOPATH}/devilutionx.mpq ]; then
        ln -sf ${DIABLOMPQPATH}/devilutionx.mpq ${DIABLOPATH}/devilutionx.mpq
    fi
fi

if [ -e ${DIABLOMPQPATH}/fonts.mpq ]; then
    if [ ! -L ${DIABLOPATH}/fonts.mpq ]; then
        ln -sf ${DIABLOMPQPATH}/fonts.mpq ${DIABLOPATH}/fonts.mpq
    fi
fi

if [ -e ${DIABLOROMPATH}/diabdat.mpq ]; then
    if [ ! -L ${DIABLOPATH}/diabdat.mpq ]; then
        ln -sf ${DIABLOROMPATH}/diabdat.mpq ${DIABLOPATH}/diabdat.mpq
    fi
else
    exit 21
fi

if [ "${1}" == "hellfire" ]; then
    for hell in diabdat hellfire hfmonk hfmusic hfvoice; do
        if [ -e ${DIABLOROMPATH}/${hell}.mpq ]; then
            if [ ! -L ${DIABLOPATH}/${hell}.mpq ]; then
                ln -sf ${DIABLOROMPATH}/${hell}.mpq ${DIABLOPATH}/${hell}.mpq
            fi
        else
            exit 21
        fi
    done
else
PARAMS=" --diablo"
fi 

devilutionx --verbose ${PARAMS}
