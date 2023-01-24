#!/usr/bin/bash

# Utilité ?

source /etc/ums-cd/config.conf

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
                ssh-copy-id root@${ip}
            fi
            num=$(($num++))
        done
        num=$(($num++))
    done
}

addSshKey