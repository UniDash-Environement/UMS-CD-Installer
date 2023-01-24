#!/bin/bash

# A suprimer pour le configurer dans interface

source /etc/ums-cd/config.conf

function questionReseaux() {
    serverIp=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
    serverGateway=$(/sbin/ip route | awk '/default/ { print $3 }')
    serverMask=$(ip -f inet -o addr|cut -d\  -f 7 | grep $serverIp | cut -d/ -f 2)
}


function networkSet() {
    # ajout dans une variable de la carte reseaux, de l'ip et du hostname
    cartereseaux=$(ip -o -4 route show to default | awk '{print $5}')

    IFACE=wg0

    cp /etc/network/interfaces /etc/network/interfaces.old

    confReseaux="
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto ${cartereseaux}
iface ${cartereseaux} inet static
    address ${serverIp}/${serverMask}
    gateway ${serverGateway}
# Réseaux Physique

auto vmbr0
iface vmbr0 inet static
    address 10.${serverNum}.0.1/16
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up iptables -t nat -A POSTROUTING -s \"10.${serverNum}.0.0/16\" -o ${cartereseaux} -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s \"10.${serverNum}.0.0/16\" -o ${cartereseaux} -j MASQUERADE
    post-up iptables -t nat -A POSTROUTING -s \"10.${serverNum}.0.0/16\" -o wg0 -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s \"10.${serverNum}.0.0/16\" -o wg0 -j MASQUERADE


source-directory /etc/network/interfaces.d
source-directory /run/network/interfaces.d
"

    echo -e "${confReseaux}" > /etc/network/interfaces

}


function fixNameServer(){
    echo "nameserver 1.1.1.1
nameserver 1.0.0.1" > /etc/resolv.conf
}

questionReseaux

networkSet
fixNameServer