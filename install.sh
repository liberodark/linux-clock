#!/bin/bash
#
# About: Linux Clock
# Author: liberodark
# License: GNU GPLv3

update_source="https://raw.githubusercontent.com/liberodark/linux-clock/master/install.sh"
version="1.0.0"

echo "Welcome on Linux Clock Install Script $version"

# make update if asked
if [ "$1" = "noupdate" ]; then
  update_status="false"
  else
  update_status="true"
  fi ;

# update updater
if [ "$update_status" = "true" ]; then
  wget -O "$0" $update_source
  $0 noupdate
  exit 0
  fi ;

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST
#=================================================

app=linux-clock

#==============================================
# INSTALL SERVICE
#==============================================

if ! command -v nrpe > /dev/null 2>&1; then
echo "wget is not Installed"
echo Install $app service
mv linux-clock-curl.service /etc/systemd/system/"$app".service

else

echo "wget is Installed"
echo Install $app service
mv linux-clock-wget.service /etc/systemd/system/"$app".service

fi

#=================================================
# SETUP SERVICE
#=================================================

echo "Enable services"
systemctl enable "$app".service
systemctl start "$app".service
