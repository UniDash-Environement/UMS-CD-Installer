#!/usr/bin/bash

function network-set() {
    chmod +x /usr/bin/fix-network
    systemctl daemon reload
    systemctl enable --now fix-network

}


function fix-name-server(){
    echo "nameserver 1.1.1.1
nameserver 1.0.0.1" > /etc/resolv.conf
}

read-conf
$1