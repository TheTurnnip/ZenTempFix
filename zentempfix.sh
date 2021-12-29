#!/bin/bash

#Please read the docs that are present on github page for full details on how to use the script.

#Variables
#---------------------------------------


echo "please choose an install directory"

read -p 'Enter_Install_Directory' dir


#functions
#---------------------------------------


testroot(){
    if [ $UID -eq 0 ]
    then
        dirtest
    else
        echo "User is not root. Please run script as root."
}

dirtest(){
    if [ -d $dir ]
    then
        servicedir
    else 
        mkdir $dir
    fi
}


servicedir(){
    cd /etc/systemd/system
}

genserv() {
    echo "[Unit]
Description=<probing the kernel module it87 cpu temperature monitoring with a forced id of 0x8620>

[Service]
User=<root>
WorkingDirectory=<$dir>
ExecStart=<tempfix.sh>
Restart=always

[Install]
WantedBy=multi-user.target" >> fixtemps.service
}

installdir() {
    cd $dir
}

gentask() {
    echo -e "#!/bin/bash \nmodprobe it87 force_id=0x8620" >> tempfix.sh
}

enabler(){
    read -p 'Do you wish to enable the service now?(Y/n)' opt
    if [ opt=Y ]
    then
        enableservice
    else
        echo "Service can be enabled later through systmed"
}

enableservice(){
    systemctl enable fixtemps.service
    echo "Service has been enabled"
}

#Run Functions
#---------------------------------------


genserv
installdir
gentask
enabler

echo "Script has compleated install"

#ZenTempFix, A script to fix tempature sensors on the 1.15 Linux Kernel
#Copyright (C) 2021  Ryan Steffan

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program. If not, see <https://www.gnu.org/licenses/>.