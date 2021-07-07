#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

function drastic_confirm() {
if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -y -w -t "Drastic 설치" -f 24 -m "이렇게 하면 Drastic이 설치되고 에뮬레이션스태이션에서 사용할 수 있게 됩니다.\n\n 참고: 인터넷 연결이 활성화되어 있어야 하며 스크립트가 종료된 후 ES를 다시 시작해야 합니다. 계속하시겠습니까?"
        if [[ $? == 21 ]]; then
            if drastic_install; then
                text_viewer -w -t "Drastic 설치 완료!" -f 24 -m "Drastic 설치 완료! /storage/roms/nds에 롬을 설치하고 에뮬레이션스태이션을 다시 시작하는 것을 잊지 마십시오!"
            else
                text_viewer -e -w -t "Drastic 설치 실패!" -f 24 -m "Drastic 설치가 완료되지 않았습니다! 인터넷에 연결되어 있습니까?"
            fi
      fi
    ee_console disable
else
    text_viewer -y -w -t "Install Drastic" -f 24 -m "This will install Drastic and enable it on Emulationstation\n\nNOTE: You need to have an active internet connection and you will need to restart ES after this script ends, continue?"
        if [[ $? == 21 ]]; then
            if drastic_install; then
                text_viewer -w -t "Install Drastic Complete!" -f 24 -m "Drastic installation is done!, don't forget to install roms to /storage/roms/nds and restart Emulationstation!"
            else
                text_viewer -e -w -t "Install Drastic FAILED!" -f 24 -m "Drastic installation was not completed!, Are you sure you are connected to the internet?"
            fi
      fi
    ee_console disable
fi
 }

function drastic_install() {
ee_console enable

if grep -q "aarch64" /etc/motd; then
    LINK="https://raw.githubusercontent.com/shantigilbert/binaries-1/master/drastic.tar.gz"
else
	LINK="https://raw.githubusercontent.com/shantigilbert/binaries/master/odroid-xu4/drastic.tar.gz"
fi

ES_FOLDER="/storage/.emulationstation"
LINKDEST="$ES_FOLDER/scripts/drastic.tar.gz"
CFG="$ES_FOLDER/es_systems.cfg"
EXE="emuelecRunEmu.sh"

mkdir -p "$ES_FOLDER/scripts/"

wget -O $LINKDEST $LINK

[[ ! -f $LINKDEST ]] && return 1
tar xvf $LINKDEST -C "$ES_FOLDER/scripts"
rm $LINKDEST

if grep -q '<name>nds</name>' "$CFG"
then
	echo 'Drastic is already setup in your es_systems.cfg file'
	echo 'deleting...nd from es_system.cfg'
	xmlstarlet ed -L -P -d "/systemList/system[name='nds']" $CFG
fi

	echo 'Adding Drastic to systems list'
	xmlstarlet ed --omit-decl --inplace \
		-s '//systemList' -t elem -n 'system' \
		-s '//systemList/system[last()]' -t elem -n 'name' -v 'nds'\
		-s '//systemList/system[last()]' -t elem -n 'fullname' -v 'Nintendo DS'\
		-s '//systemList/system[last()]' -t elem -n 'manufacturer' -v 'Nintendo'\
		-s '//systemList/system[last()]' -t elem -n 'release' -v '2004'\
		-s '//systemList/system[last()]' -t elem -n 'hardware' -v 'portable'\
		-s '//systemList/system[last()]' -t elem -n 'path' -v '/storage/roms/nds'\
		-s '//systemList/system[last()]' -t elem -n 'extension' -v '.nds .zip .NDS .ZIP'\
		-s '//systemList/system[last()]' -t elem -n 'command' -v "$EXE %ROM% -P%SYSTEM% --core=%CORE% --emulator=%EMULATOR% --controllers=\"%CONTROLLERSCONFIG%\""\
		-s '//systemList/system[last()]' -t elem -n 'platform' -v 'nds'\
		-s '//systemList/system[last()]' -t elem -n 'theme' -v 'nds'\
		$CFG

read -d '' content <<EOF
#!/bin/bash

# Only run pixel if it exists, mainly for N2
if [ -f "/storage/.emulationstation/scripts/pixel.sh" ]; then
/storage/.emulationstation/scripts/pixel.sh
fi

cd /storage/.emulationstation/scripts/drastic/
./drastic "\$1" > /dev/null 2>&1

EOF
echo "$content" > $ES_FOLDER/scripts/drastic.sh
chmod +x $ES_FOLDER/scripts/drastic.sh

if [ "$EE_DEVICE" == "OdroidGoAdvance" -o "$EE_DEVICE" == "RG351P" -o "$EE_DEVICE" == "RG351V" ] || [ "$EE_DEVICE" == "GameForce" ]; then
# copy the correct config file depending on what OGA

DEVICE=$(oga_ver)
cd "/storage/.emulationstation/scripts/drastic/config"

case "${DEVICE}" in
    "OGS")
        cp -rf drastic_ogs.cfg drastic.cfg
    ;;
    "OGABE")
        cp -rf drastic_ogabe.cfg drastic.cfg
    ;;
    "OGA1")
        cp -rf drastic_oga.cfg drastic.cfg
    ;;
    "GF")
        cp -rf drastic_ogs.cfg drastic.cfg
    ;;
    "RG351P")
        cp -rf drastic_rg351p.cfg drastic.cfg
    ;;
    "RG351V")
        cp -rf drastic_rg351v.cfg drastic.cfg
    ;;
esac

fi

echo "Done, restart ES"
ee_console disable
rm /tmp/display > /dev/null 2>&1
return 0
}

drastic_confirm

