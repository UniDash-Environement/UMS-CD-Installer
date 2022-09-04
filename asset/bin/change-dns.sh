#!/usr/bin/bash

function readConf() {
    if [ -e /etc/ums-cd/install.conf ]; then
        while read var value
        do
            export "$var"
        done < /etc/ums-cd/install.conf
    fi
}

function addSshKey() {
    num=0
    while [ $num != 256 ]
    do
        num1=0
        while [ $num1 != 256 ]
        do
            vmIp="10.${serverNum}.${num1}.${num}"
            fping -c1 -t300 vmIp 2>/dev/null 1>/dev/null
            if [ "$?" = 0 ]
            then
                ssh root@${ip} -c"change-dns-client ${1} ${2}"
            fi
            num=$(($num++))
        done
        num=$(($num++))
    done
}

readConf
addSshKey

