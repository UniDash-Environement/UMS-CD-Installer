#!/usr/bin/bash


function networkSet(){
    cp ./asset/bin/fix-network.sh /bin/fix-network
    chmod +x /bin/fix-network

    cp ./asset/systemd/fix-network.service /etc/systemd/system/fix-network.service
    systemctl enable --now fix-network.service
}

$1