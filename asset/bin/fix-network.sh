#!/bin/bash

function read-conf() {
    if [ -e /etc/ums-cd/config.conf ]; then
        while read var value
        do
            export "$var"="$value"
        done < /etc/ums-cd/config.conf
    fi
}


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

auto $IFACE
iface $IFACE inet manual
    address 172.16.0.${serverNum}/16
    ip-forward 1
    pre-up ip link add wg0 type wireguard"

    if [ ${backendOrFrontend} == "frontend" ]; then
        confReseaux="${confReseaux}
    post-up iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ${cartereseaux} -j MASQUERADE"
        for i in "${!WireguardConfClientPbKey[@]}"
        do
            confReseaux="${confReseaux}
    up wg set $IFACE listen-port 51820 private-key /etc/wireguard/privatekey peer ${WireguardConfClientPbKey[$i]} allowed-ips 172.16.0.$(expr $i + 2)/32 persistent-keepalive 25 endpoint ${wireguardEndpointIp}:51820"
        done
        confReseaux="${confReseaux}
    post-down iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ${cartereseaux} -j MASQUERADE"
    else
        confReseaux="${confReseaux}
    up wg set $IFACE listen-port 51820 private-key /etc/wireguard/privatekey peer ${wireguardPbKeyServer} allowed-ips 0.0.0.0/0 persistent-keepalive 25 endpoint ${wireguardEndpointIp}:51820"
    fi

    confReseaux="${confReseaux}
    post-down ip link del wg0
    post-up ip link set wg0 mtu 1420
    post-up ip addr add 172.16.0.${serverNum}/16 dev wg0

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

read-conf
questionReseaux

networkSet
fixNameServer

ifdown wg0
ifup wg0