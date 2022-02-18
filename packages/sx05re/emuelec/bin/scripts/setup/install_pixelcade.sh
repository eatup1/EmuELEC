#!/bin/bash

. /etc/profile

java_installed=false
install_succesful=false
auto_update=false #this doesn't do anything, keep on false
PIXELCADE_PRESENT=false
version=7  #increment this as the script is updated
upgrade_software=false
upgrade_artwork=false

cat > /tmp/pixelcade_kr.txt << "EOF"
       _          _               _
 _ __ (_)_  _____| | ___ __ _  __| | ___
| '_ \| \ \/ / _ \ |/ __/ _` |/ _` |/ _ \
| |_) | |>  <  __/ | (_| (_| | (_| |  __/
| .__/|_/_/\_\___|_|\___\__,_|\__,_|\___|
|_|
EOF

cat >> /tmp/pixelcade_kr.txt <<EOF

       EmuELEC용 Pixelcade LED 설치 프로그램 : 설치 프로그램 버전 $version

이 스크립트는 /storage/roms 폴더에 Pixelcade를 설치합니다.
/storage/roms에 최소 800MB의 여유 디스크 공간이 있는지 확인하십시오.
이제 Pixelcade를 기기(Odroid, Android Box 등)의 여유 USB 포트에 연결하세요.
Pixelcade 보드의 토글 스위치가 BT가 아닌 USB를 가리키고 있는지 확인합니다.
Pixelcade 하드웨어가 연결되어 있지 않으면 설치 프로그램이 실행되지 않습니다.
이 설치 프로그램은 약 15분 정도 소요되므로 커피나 차를 준비하세요.

나중에 이 설치 프로그램을 재실행하여 업데이트된 마키 아트워크를 다운로드할 수 있습니다.

계속하시겠습니까?
EOF

cat > /tmp/pixelcade.txt << "EOF"
       _          _               _
 _ __ (_)_  _____| | ___ __ _  __| | ___
| '_ \| \ \/ / _ \ |/ __/ _` |/ _` |/ _ \
| |_) | |>  <  __/ | (_| (_| | (_| |  __/
| .__/|_/_/\_\___|_|\___\__,_|\__,_|\___|
|_|
EOF

cat >> /tmp/pixelcade.txt <<EOF

       Pixelcade LED Installer for EmuELEC : Installer Version $version

This script will install Pixelcade in your /storage/roms folder
Plese ensure you have at least 800 MB of free disk space in /storage/roms
Now connect Pixelcade to a free USB port on your device (Odroid, Android Box, etc)
Ensure the toggle switch on the Pixelcade board is pointing towards USB and not BT
The installer will not run unless the Pixelcade hardware is connected
Grab a coffee or tea as this installer will take around 15 minutes

You may also re-run this installer later to download updated marquee artwork

Would you like to continue?
EOF

if [ $(get_ee_setting system.language) == "ko_KR" ]; then
    text_viewer -w -y -t "Pixelcade LED 마키 설치" -f 24 /tmp/pixelcade_kr.txt
    if [[ $? != 21 ]]; then
        text_viewer -w -t "설치가 취소됨!" -f 24 -m "Pixelcade 설치가 취소되었습니다. 종료하려면 Start 또는 A을 누르십시오!"
        exit 0
    fi
else
    text_viewer -w -y -t "Pixelcade LED Marquee Installer" -f 24 /tmp/pixelcade.txt
    if [[ $? != 21 ]]; then
        text_viewer -w -t "Installation canceled!" -f 24 -m "Pixelcade installation canceled! press start or A to exit!"
        exit 0
    fi
fi

INSTALLPATH="/storage/roms/"

updateartwork() {  #this is needed for rom names with spaces

  cd ${INSTALLPATH}

  if [[ -f "${INSTALLPATH}master.zip" ]]; then #if the user killed the installer mid-stream,it's possible this file is still there so let's remove it to be sure before downloading, otherwise wget will download and rename to .1
     rm "${INSTALLPATH}master.zip"
  fi

  if [[ -d "${INSTALLPATH}pixelcade-master" ]]; then #if the user killed the installer mid-stream,it's possible this file is still there so let's remove it to be sure before downloading, otherwise wget will download and rename to .1
     rm -r "${INSTALLPATH}pixelcade-master"
  fi

  if [[ ! -d "${INSTALLPATH}user-modified-pixelcade-artwork" ]]; then
     mkdir "${INSTALLPATH}user-modified-pixelcade-artwork"
  fi
  #let's get the files that have been modified since the initial install as they would have been overwritten

  #find all files that are newer than .initial-date and put them into /ptemp/modified.tgz
  echo "Backing up any artwork that you have added or changed..."

  if [[ -f "${INSTALLPATH}pixelcade/system/.initial-date" ]]; then #our initial date stamp file is there
     cd ${INSTALLPATH}pixelcade
     find . -not -name "*.rgb565" -not -name "pixelcade-version" -not -name "*.txt" -not -name "decoded" -not -name "*.ini" -not -name "*.csv" -not -name "*.log" -not -name "*.sh" -newer ${INSTALLPATH}pixelcade/system/.initial-date -print0 | sed "s/'/\\\'/" | xargs -0 tar --no-recursion -czf ${INSTALLPATH}user-modified-pixelcade-artwork/changed.tgz
     #unzip the file
     cd "${INSTALLPATH}user-modified-pixelcade-artwork"
     tar -xvzf changed.tgz
     rm changed.tgz
     #dont' delete the folder because initial date gets reset so we need continusly to track what the user changed during each update in this folder
  else
      echo "[ERROR] ${INSTALLPATH}pixelcade/system/.initial-date does not exist, any custom or modified artwork you have done will not backup and will be overwritten"
  fi

  cd ${INSTALLPATH}
  wget https://github.com/alinke/pixelcade/archive/refs/heads/master.zip
  unzip master.zip
  echo "Copying over new artwork..."
  # not that because of github the file dates of pixelcade-master will be today's date and thus newer than the destination
  # now let's overwrite with the pixelcade repo and because the repo files are today's date, they will be newer and copy over
  #rsync -avruh --exclude '*.jar' --exclude '*.csv' --exclude '*.ini' --exclude '*.log' --exclude '*.cfg' --exclude emuelec --exclude batocera --exclude recalbox --progress ${INSTALLPATH}pixelcade-master/. ${INSTALLPATH}pixelcade/ #this is going to reset the last updated date
  rsync -aruh --exclude '*.jar' --exclude '*.csv' --exclude '*.ini' --exclude '*.log' --exclude '*.cfg' --exclude emuelec --exclude batocera --exclude recalbox ${INSTALLPATH}pixelcade-master/. ${INSTALLPATH}pixelcade/ #this is going to reset the last updated date
  # ok so now copy back in here the files from ptemp

  if [[ -f "${INSTALLPATH}pixelcade/system/.initial-date" ]]; then
     cp -r -v "${INSTALLPATH}user-modified-pixelcade-artwork/." "${INSTALLPATH}pixelcade/"
  fi

  echo "Cleaning up, this will take a bit..."
  rm -r ${INSTALLPATH}pixelcade-master
  rm ${INSTALLPATH}master.zip

  cd ${INSTALLPATH}pixelcade
  ${INSTALLPATH}bios/jdk/bin/java -jar pixelweb.jar -b & #run pixelweb in the background\
  touch ${INSTALLPATH}pixelcade/system/.initial-date
  exit 1
}

updateartworkandsoftware() {  #this is needed for rom names with spaces

cd ${INSTALLPATH}

if [[ -f "${INSTALLPATH}master.zip" ]]; then #if the user killed the installer mid-stream,it's possible this file is still there so let's remove it to be sure before downloading, otherwise wget will download and rename to .1
   rm "${INSTALLPATH}master.zip"
fi

if [[ -d "${INSTALLPATH}pixelcade-master" ]]; then #if the user killed the installer mid-stream,it's possible this file is still there so let's remove it to be sure before downloading, otherwise wget will download and rename to .1
   rm -r "${INSTALLPATH}pixelcade-master"
fi

if [[ ! -d "${INSTALLPATH}user-modified-pixelcade-artwork" ]]; then
   mkdir "${INSTALLPATH}user-modified-pixelcade-artwork"
fi

#find all files that are newer than .initial-date and put them into /ptemp/modified.tgz
echo "Backing up your artwork modifications..."

if [[ -f "${INSTALLPATH}pixelcade/system/.initial-date" ]]; then #our initial date stamp file is there
   cd ${INSTALLPATH}pixelcade
   find . -not -name "*.rgb565" -not -name "pixelcade-version" -not -name "*.txt" -not -name "decoded" -not -name "*.ini" -not -name "*.csv" -not -name "*.log" -not -name "*.sh" -newer ${INSTALLPATH}pixelcade/system/.initial-date -print0 | sed "s/'/\\\'/" | xargs -0 tar --no-recursion -czf ${INSTALLPATH}user-modified-pixelcade-artwork/changed.tgz
   #unzip the file
   cd "${INSTALLPATH}user-modified-pixelcade-artwork"
   tar -xvzf changed.tgz
   rm changed.tgz
   #dont' delete the folder because initial date gets reset so we need continusly to track what the user changed during each update in this folder
else
    echo "[ERROR] ${INSTALLPATH}pixelcade/system/.initial-date does not exist, any custom or modified artwork you have done will not backup and will be overwritten"
fi

cd ${INSTALLPATH}
wget https://github.com/alinke/pixelcade/archive/refs/heads/master.zip
unzip master.zip
echo "Copying over new artwork..."
# not that because of github the file dates of pixelcade-master will be today's date and thus newer than the destination
# now let's overwrite with the pixelcade repo and because the repo files are today's date, they will be newer and copy over
#rsync -avruh --progress ${INSTALLPATH}pixelcade-master/. ${INSTALLPATH}pixelcade/
rsync -aruh ${INSTALLPATH}pixelcade-master/. ${INSTALLPATH}pixelcade/
# ok so now copy back in here the files from ptemp

if [[ -f "${INSTALLPATH}pixelcade/system/.initial-date" ]]; then
   cp -r -v "${INSTALLPATH}user-modified-pixelcade-artwork/." "${INSTALLPATH}pixelcade/"
fi

echo "Cleaning up, this will take a bit..."
rm -r ${INSTALLPATH}pixelcade-master
rm ${INSTALLPATH}master.zip

cd ${INSTALLPATH}pixelcade
PIXELCADE_PRESENT=true
}

# let's detect if Pixelcade is USB connected, could be 0 or 1 so we need to check both
if ls /dev/ttyACM0 | grep -q '/dev/ttyACM0'; then
   echo "Pixelcade LED Marquee Detected on ttyACM0"
else
    if ls /dev/ttyACM1 | grep -q '/dev/ttyACM1'; then
        echo "Pixelcade LED Marquee Detected on ttyACM1"
    else
       if [ $(get_ee_setting system.language) == "ko_KR" ]; then
           text_viewer -e -w -t "에러: PixelCade가 감지되지 않습니다!" -f 24 -m "죄송합니다. Pixelcade LED Marquee가 감지되지 않았습니다. Pixelcade가 EmuELC 장치에 USB로 연결되어 있고 Pixelcade 보드의 토글 스위치가 USB를 가리키고 있는지 확인하십시오. 종료..."
       else
           text_viewer -e -w -t "ERROR: PixelCade Not Detected!" -f 24 -m "Sorry, Pixelcade LED Marquee was not detected, pleasse ensure Pixelcade is USB connected to your EmuELEC device and the toggle switch on the Pixelcade board is pointing towards USB, exiting..."
       fi
       exit 1
    fi
fi

# let's make sure we have EmuELEC installation
if lsb_release -a | grep -q 'EmuELEC'; then
        echo "EmuELEC Detected"
else
   echo "Sorry, EmuELEC was not detected, exiting..."
   exit 1
fi

killall java #need to stop pixelweb.jar if already running

# let's check the version and only proceed if the user has an older version
if [[ -d "${INSTALLPATH}pixelcade" ]]; then
    if [[ -f "${INSTALLPATH}pixelcade/pixelcade-version" ]]; then
      echo "Existing Pixelcade installation detected, checking version..."
      read -r currentVersion<${INSTALLPATH}pixelcade/pixelcade-version
      if [[ $currentVersion -lt $version ]]; then
            echo "Older Pixelcade version detected, now upgrading..."

        if [ $(get_ee_setting system.language) == "ko_KR" ]; then
          text_viewer -y -w -t "이전 버전이 감지되었습니다!" -f 24 -m "이전 버전의 Pixelcade 소프트웨어가 있습니다. Pixelcade 소프트웨어를 업그레이드하시겠습니까?"
	else
          text_viewer -y -w -t "Old version detected!" -f 24 -m "You've got an older version of Pixelcade software, would you like to upgrade your Pixelcade software?"
        fi
            if [[ $? == 21 ]]; then
                upgrade_software=true
            else
                exit 0;
            fi

        if [ $(get_ee_setting system.language) == "ko_KR" ]; then
          text_viewer -y -w -t "아트워크 업데이트?" -f 24 -m "최신 Pixelcade 아트웍도 받고 싶으신가요? 15분 정도 걸릴 겁니다"
        else
          text_viewer -y -w -t "Update Artwork?" -f 24 -m "Would you also like to get the latest Pixelcade artwork? This will take around 15 minutes..."
	fi
            if [[ $? == 21 ]]; then
                upgrade_artwork=true
            else
                upgrade_artwork=false
            fi

            if [[ $upgrade_software = true && $upgrade_artwork = true ]]; then
                  updateartworkandsoftware
            elif [ "$upgrade_software" = true ]; then
                 echo "Upgrading Pixelcade software...";
            elif [ "$upgrade_artwork" = true ]; then
                 updateartwork #this will exit after artwork upgrade and not continue on for the software update
            fi

      else

        if [ $(get_ee_setting system.language) == "ko_KR" ]; then
          text_viewer -y -w -t "최신 소프트웨어" -f 24 -m "Pixelcade 소프트웨어 버전이 최신 버전입니다. 다시 설치하시겠습니까?"
        else
          text_viewer -y -w -t "Software up to date" -f 24 -m "Your Pixelcade software vesion is up to date. Do you want to re-install?"
        fi
            if [[ $? == 21 ]]; then
                upgrade_software=true
            else
                uupgrade_software=false
            fi


        if [ $(get_ee_setting system.language) == "ko_KR" ]; then
          text_viewer -y -w -t "아트워크 업데이트?" -f 24 -m "최신 Pixelcade 아트웍도 받고 싶으신가요? 15분 정도 걸릴 겁니다"
        else
          text_viewer -y -w -t "Update Artwork?" -f 24 -m "Would you also like to get the latest Pixelcade artwork? This will take around 15 minutes..."
        fi
            if [[ $? == 21 ]]; then
                upgrade_artwork=true
            else
                upgrade_artwork=false
            fi

        if [[ $upgrade_software = true && $upgrade_artwork = true ]]; then
              updateartworkandsoftware
              #text_viewer "Installing..." -f 24 -m "Installing Pixelcade LED marquee software, this will take around 15 minutes..."
        elif [ "$upgrade_software" = true ]; then
             echo "Upgrading Pixelcade software...";
        elif [ "$upgrade_artwork" = true ]; then
               #text_viewer "Installing..." -f 24 -m "Installing Pixelcade LED marquee software, this will take around 15 minutes..."
             updateartwork #this will exit after artwork upgrade and not continue on for the software update
        fi

      fi
    fi
fi

#. /etc/profile

#ee_console enable
#echo "Checking JDK..." > /dev/console

JDKDEST="${HOME}/roms/bios/jdk"
JDKNAME="zulu18.0.45-ea-jdk18.0.0-ea.18"
CDN="https://cdn.azul.com/zulu/bin"

# Alternate just for reference
#CDN="https://cdn.azul.com/zulu-embedded/bin"

mkdir -p "${JDKDEST}"

OLDVERSION="$(cat ${JDKDEST}/eeversion 2>/dev/null)"
if [ "${JDKNAME}" != "${OLDVERSION}" ]; then
   JDKINSTALLED="no"
   rm -rf "${JDKDEST}"
   mkdir -p "${JDKDEST}"
fi

if [ "${JDKINSTALLED}" == "no" ]; then
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80
if [ $? -ne 0 ]; then
    echo "No internet connection, exiting..."
    if [ $(get_ee_setting system.language) == "ko_KR" ]; then
      text_viewer -e -w -t "인터넷 안됨!" -m "JDK 다운로드를 위해 인터넷에 연결되어야 합니다.\n인터넷에 연결되지 않았습니다. 종료합니다...";
    else
      text_viewer -e -w -t "No Internet!" -m "You need to be connected to the internet to download the JDK\nNo internet connection, exiting...";
    fi
    exit 1
fi
    echo "Downloading JDK please be patient..."
    cd ${JDKDEST}/..
    wget "${CDN}/${JDKNAME}-linux_aarch64.tar.gz"
    echo "Inflating JDK please be patient..."
    tar xvfz ${JDKNAME}-linux_aarch64.tar.gz ${JDKNAME}-linux_aarch64/lib
    tar xvfz ${JDKNAME}-linux_aarch64.tar.gz ${JDKNAME}-linux_aarch64/bin
    tar xvfz ${JDKNAME}-linux_aarch64.tar.gz ${JDKNAME}-linux_aarch64/conf
    rm ${JDKNAME}-linux_aarch64/lib/*.zip
    mv ${JDKNAME}-linux_aarch64/* ${JDKDEST}
    rm -rf ${JDKNAME}-linux_aarch64*

    for del in jmods include demo legal man DISCLAIMER LICENSE readme.txt release Welcome.html; do
        rm -rf ${JDKDEST}/${del}
    done
    echo "JDK done! loading core!"
    cp -rf /usr/lib/libretro/freej2me-lr.jar ${HOME}/roms/bios
    echo "${JDKNAME}" > "${JDKDEST}/eeversion"
fi


if [ ${PIXELCADE_PRESENT} == "false" ]; then  #skip this if the user already had pixelcade
  echo "Installing Pixelcade from GitHub Repo..."
  cd ${INSTALLPATH}
  git clone --depth 1 git://github.com/alinke/pixelcade.git
fi

if [[ -d ${INSTALLPATH}ptemp ]]; then
    rm -r ${INSTALLPATH}ptemp
fi

#creating a temp dir for the Pixelcade system files
mkdir ${INSTALLPATH}ptemp
cd ${INSTALLPATH}ptemp

#get the Pixelcade system files
wget https://github.com/alinke/pixelcade-linux/archive/refs/heads/main.zip
unzip main.zip

if [[ ! -d /storage/.emulationstation/scripts ]]; then #does the ES scripts folder exist, make it if not
    mkdir /storage/.emulationstation/scripts
fi

#pixelcade core files
echo "${yellow}Installing Pixelcade Core Files...${white}"

cp -f ${INSTALLPATH}ptemp/pixelcade-linux-main/core/* ${INSTALLPATH}pixelcade #the core Pixelcade files, no sub-folders in this copy
#pixelcade system folder
cp -a -f ${INSTALLPATH}ptemp/pixelcade-linux-main/system ${INSTALLPATH}pixelcade #system folder, .initial-date will go in here
#pixelcade scripts for emulationstation events
#copy over the custom scripts
echo "${yellow}Installing Pixelcade EmulationStation Scripts...${white}"
cp -r -f ${INSTALLPATH}ptemp/pixelcade-linux-main/emuelec/scripts /storage/.emulationstation #note this will overwrite existing scripts
find /storage/.emulationstation/scripts -type f -iname "*.sh" -exec chmod +x {} \; #make all the scripts executble
#hi2txt for high score scrolling
echo "${yellow}Installing hi2txt for High Scores...${white}"
cp -r -f ${INSTALLPATH}ptemp/pixelcade-linux-main/hi2txt ${INSTALLPATH} #for high scores

# set the emuelec logo as the startup marquee
sed -i 's/startupLEDMarqueeName=arcade/startupLEDMarqueeName=emuelec/' ${INSTALLPATH}pixelcade/settings.ini
# need to remove a few lines in console.csv
sed -i 's/startupLEDMarqueeName=arcade/startupLEDMarqueeName=emuelec/' ${INSTALLPATH}pixelcade/console.csv
sed -i '/all,mame/d' ${INSTALLPATH}pixelcade/console.csv
sed -i '/favorites,mame/d' ${INSTALLPATH}pixelcade/console.csv
sed -i '/recent,mame/d' ${INSTALLPATH}pixelcade/console.csv

if cat /storage/.config/custom_start.sh | grep -q 'pixelcade'; then
    echo "Pixelcade was already added to custom_start.sh, skipping..."
else
    echo "Adding Pixelcade Listener auto start to custom_start.sh ..."
    sed -i '/^"before")/a cd '${INSTALLPATH}'pixelcade && '${INSTALLPATH}'bios/jdk/bin/java -jar pixelweb.jar -b &' /storage/.config/custom_start.sh  #insert this line after "before"
fi

#lastly let's just check for Pixelcade LCD
cd ${INSTALLPATH}pixelcade
echo "Checking for Pixelcade LCDs..."
${INSTALLPATH}bios/jdk/bin/java -jar pixelcadelcdfinder.jar -nogui #check for Pixelcade LCDs

cd ${INSTALLPATH}pixelcade
${INSTALLPATH}bios/jdk/bin/java -jar pixelweb.jar -b & #run pixelweb in the background\

chmod +x /storage/.config/custom_start.sh

# let's send a test image and see if it displays
sleep 8
cd ${INSTALLPATH}pixelcade
${INSTALLPATH}bios/jdk/bin/java -jar pixelcade.jar -m stream -c mame -g 1941

echo "Cleaning up..."
if [[ -d ${INSTALLPATH}ptemp ]]; then
    rm -r ${INSTALLPATH}ptemp
fi

if [[ -f ${INSTALLPATH}setup-emuelec.sh ]]; then
    rm ${INSTALLPATH}setup-emuelec.sh
fi

if [[ -f ${INSTALLPATH}Pixelcade.sh ]]; then
    rm ${INSTALLPATH}Pixelcade.sh
fi

if [[ -f /storage/setup-emuelec.sh ]]; then
    rm /storage/setup-emuelec.sh
fi

#let's write the version so the next time the user can try and know if he/she needs to upgrade
echo $version > ${INSTALLPATH}pixelcade/pixelcade-version
touch ${INSTALLPATH}pixelcade/system/.initial-date
  if [ $(get_ee_setting system.language) == "ko_KR" ]; then
     text_viewer -y -w -t "설치 완료!" -f 24 -m "1941 게임 로고가 지금 Pixelcade에 표시되나요?"
  else
     text_viewer -y -w -t "Installation complete!" -f 24 -m "Is the 1941 Game Logo Displaying on Pixelcade Now?"
  fi
         if [[ $? == 21 ]]; then
           if [ $(get_ee_setting system.language) == "ko_KR" ]; then
             text_viewer -y -w -t "설치 완료!" -f 24 -m "설치가 완료되었습니다. 지금 다시 부팅하면 픽셀케이드가 EmuELC에 의해 제어됩니다. 지금 다시 부팅하시겠습니까?"
           else
             text_viewer -y -w -t "Installation complete!" -f 24 -m "INSTALLATION COMPLETE , please now reboot and then Pixelcade will be controlled by EmuELEC, would you like to reboot now?"
           fi
            if [[ $? == 21 ]]; then
               systemctl reboot
            fi
         else
           if [ $(get_ee_setting system.language) == "ko_KR" ]; then
             text_viewer -y -w -t "설치 완료!" -f 24 -m "여전히 괜찮고 재부팅을 시도할 수 있습니다. https://pixelcade.org/download-pi/에서 문제 해결 단계를 참조할 수도 있습니다. 지금 재부팅하시겠습니까?"
           else
             text_viewer -y -w -t "Installation incomplete!" -f 24 -m "It may still be ok and try rebooting, you can also refer to https://pixelcade.org/download-pi/ for troubleshooting steps, would you like to reboot now?"
           fi
         fi
