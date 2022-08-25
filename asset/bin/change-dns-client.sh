#!/usr/bin/bash

actualResolv=$(echo $(cat /etc/resolv.conf) | cut -d" " -f1-2 && echo \\n && echo $(cat /etc/resolv.conf) | cut -d " " -f3-4)
sed "s/${actualResolv}/nameserver ${1}\nnameserver ${2}/g" /usr/bin/fix-network
echo "nameserver ${1}\nnameserver ${2}" > /etc/resolv.conf