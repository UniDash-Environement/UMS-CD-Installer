#!/usr/bin/bash

function readConf() {
    if [ -e /etc/ums-cd/install.conf ]; then
        # shellcheck disable=SC2162
        # shellcheck disable=SC2034
        while read var value
        do
            # shellcheck disable=SC2163
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