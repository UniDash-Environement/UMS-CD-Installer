#!/usr/bin/bash

source /etc/ums-cd/config.conf

function changeSns() {
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

changeSns

