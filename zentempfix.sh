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