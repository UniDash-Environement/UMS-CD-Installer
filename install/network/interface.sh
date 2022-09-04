#!/usr/bin/bash

function readConf() {
    if [ -e /etc/ums-cd/install.conf ]; then
        while read var value
        do
            export "$var"
        done < /etc/ums-cd/install.conf
    fi
}


function fixNameServer(){
    echo "nameserver 1.1.1.1
nameserver 1.0.0.1" > /etc/resolv.conf
}

readConf
$1