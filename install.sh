#!/bin/bash
#
# About: MTU Fix Debian
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
# INSTALL NET-TOOLS
#==============================================

apt install -y net-tools

#==============================================
# INSTALL SERVICE
#==============================================
echo Install $app service

echo "
[Unit]
Description=$app
After=network.target

[Service]
WorkingDirectory=$final_path
User=root
Group=users
Type=simple
UMask=000
ExecStart=/usr/bin/date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
TimeoutSec=30
RestartSec=15s
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$app.service

#=================================================
# SETUP APP
#=================================================

echo Enable services
systemctl enable $app.service
systemctl start $app.service
