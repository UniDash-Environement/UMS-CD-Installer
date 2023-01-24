#!/usr/bin/bash

# A remplacer par n2n
# suprimer le fichier fix-network et sont service pour le corriger ici

source /etc/ums-cd/install.conf

function installWireguardClient() {
    apt-get install -y wireguard resolvconf

    sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf;
    /sbin/sysctl -w net.ipv4.ip_forward=1;

    echo -e "${WireguardConfClientPvKey[$serverNum -2]}" > /etc/wireguard/privatekey;
    echo -e "${WireguardConfClientPbKey[$serverNum -2]}" > /etc/wireguard/publickey;

    echo -e "${WireguardConfClient[$serverNum -2]}" > /etc/wireguard/wg0.conf;

    chmod 600 -R /etc/wireguard/;
}


function installWireguardServer() {
    apt-get install wireguard resolvconf -y

    echo -e "${wireguardPvKeyServer}" > /etc/wireguard/privatekey;
    echo -e "${wireguardPbKeyServer}" > /etc/wireguard/publickey;

    echo -e "${wireguardConfServer}" > /etc/wireguard/wg0.conf;
    chmod 600 -R /etc/wireguard/;
}


function installWireguard() {
    if [ $backendOrFrontend == "backend" 2>/dev/null ]; then
        installWireguardClient
    else
        installWireguardServer
    fi
}

$1