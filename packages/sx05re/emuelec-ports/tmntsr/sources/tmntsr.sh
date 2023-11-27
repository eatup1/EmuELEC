#!/bin/bash

. /etc/profile

directory="/storage/roms"

export gameassembly="TMNT.exe"
export gamedir="/$directory/ports/tmntsr"

# Untar port files
if [[ ! -f "${gamedir}/MMLoader.exe" ]]; then
tar -xf "/emuelec/configs/tmntsr.tar.xz" -C "$directory/ports"
fi

# check if required files are installed
if [[ ! -f "${gamedir}/gamedata/${gameassembly}" ]]; then
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -e -w -t "에러!" -f 24 -m "TMNT:SR 게임 데이터가 ${GAMEDIR}/gamedata 에 없습니다.\n\n게임 복사본에서 자신의 게임 데이터를 제공해야 합니다."
    else
    text_viewer -e -w -t "ERROR!" -f 24 -m "TMNT:SR Game Data does not exist on ${gamedir}/gamedata\n\nYou need to provide your own game data from your copy of the game"
    fi
    exit 0
fi

cd "$gamedir/gamedata"

# Setup mono
monodir="/emuelec/mono"
monofile="$directory/ports/mono-6.12.0.122-aarch64.squashfs"

if [ ! -e "${monofile}" ]; then
monourl="https://github.com/PortsMaster/PortMaster-Hosting/releases/download/large-files/mono-6.12.0.122-aarch64.squashfs"
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -y -w -f 24 -t "MONO가 없습니다!" -m "TMNT:SR을 처음 시작하거나 MONO 파일이 존재하지 않는 것 같습니다\n\nMONO는 약 260MB이며 인터넷에 연결되어 있어야 합니다.\n\n중요: 이것은 게임 데이터가 아닙니다! 여전히 TMNT:SR 사본에서 제공해야 합니다.\n\n다운로드 후 계속하시겠습니까?"
    else
    text_viewer -y -w -f 24 -t "MONO does not exists!" -m "It seems this is the first time you are launching TMNT:SR or the MONO file does not exists\n\nMONO is about 260 MB, and you need to be connected to the internet\n\nIMPORTANT: THIS IS NOT THE GAME DATA! YOU STILL NEED TO PROVIDE THIS FROM YOUR COPY OF TMNT:SR\n\nDownload and continue?"
    fi
        if [[ $? == 21 ]]; then
            ee_console enable
            wget "${monourl}" -O "${monofile}" -q --show-progress > /dev/tty0 2>&1
            ee_console disable
        else
            exit 0
        fi
else
    mkdir -p "$monodir"
    umount "$monofile" || true
    mount "$monofile" "$monodir"
fi


# Remove all the dependencies in favour of system libs - e.g. the included 
rm -f System*.dll mscorlib.dll FNA.dll Mono.*.dll

# Setup path and other environment variables
# export FNA_PATCH="$gamedir/dlls/PanzerPaladinPatches.dll"
export MONO_IOMAP=all
export XDG_DATA_HOME=/emuelec/configs
export MONO_PATH="$gamedir/dlls":"$gamedir/gamedata":"$gamedir/monomod"
export LD_LIBRARY_PATH="$gamedir/libs":"$monodir/lib":"$LD_LIBRARY_PATH"
export PATH="$monodir/bin":"$PATH"

# Setup savedir
if [ ! -L ${XDG_DATA_HOME}/Tribute\ Games/TMNT ]; then
rm -rf ${XDG_DATA_HOME}/Tribute\ Games/TMNT
mkdir -p ${XDG_DATA_HOME}/Tribute\ Games/
ln -sfv "${gamedir}/savedata" ${XDG_DATA_HOME}/Tribute\ Games/TMNT
fi

# Configure the renderpath
export FNA3D_FORCE_DRIVER=OpenGL
export FNA3D_OPENGL_FORCE_ES3=1
export FNA3D_OPENGL_FORCE_VBO_DISCARD=1
export FNA_SDL2_FORCE_BASE_PATH=0

sha1sum -c "${gamedir}/gamedata/.ver_checksum"
if [ $? -ne 0 ]; then
	echo "Checksum fail or unpatched binary found, patching game..." |& tee /dev/tty0
	rm -f "${gamedir}/gamedata/.astc_done"
	rm -f "${gamedir}/gamedata/.patch_done"
fi

if [[ ! -f "${gamedir}/gamedata/.astc_done" ]] || [[ ! -f "${gamedir}/gamedata/.patch_done" ]]; then
	chmod +x ../repack.src ../utils/*
	progressor \
		--log "../repack.log" \
		--font "../FiraCode-Regular.ttf" \
		--title "First Time Setup" \
		../repack.src

	[[ $? != 0 ]] && exit -1
fi

# Fix for a goof on previous on the previous patcher...
if [[ -f "${gamedir}/gamedata/MONOMODDED_ParisEngine.dll.so" ]]; then
	mv "${gamedir}/gamedata/MONOMODDED_ParisEngine.dll.so" "${gamedir}/gamedata/ParisEngine.dll.so"
	mv "${gamedir}/gamedata/MONOMODDED_${gameassembly}.so" "${gamedir}/gamedata/${gameassembly}.so"
fi

printf "\033c" > /dev/tty0
echo "Loading... Please Wait." > /dev/tty0

mono --ffast-math -O=all ../MMLoader.exe MONOMODDED_${gameassembly} |& tee ${gamedir}/log.txt
kill -9 $(pidof gptokeyb)
umount "$monodir"

# Disable console
printf "\033c" >> /dev/tty1
