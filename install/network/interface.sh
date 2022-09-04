#!/usr/bin/bash

function readConf() {
    if [ -e /etc/ums-cd/install.conf ]; then
        while read var value
        do
            export "$var"
        done < /etc/ums-cd/install.conf
    fi
}


function networkSet(){
    cp ./asset/bin/fix-network.sh /bin/fix-network
    chmod +x /bin/fix-network

    cp ./asset/systemd/fix-network.service /etc/systemd/system/fix-network.service
    systemctl enable --now fix-network.service
}

readConf
$1