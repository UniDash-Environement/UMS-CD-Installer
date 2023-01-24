#!/usr/bin/bash

# a refaire avec la doc de porxmox pour debian 11

source /etc/ums-cd/install.conf

function installProxmox() {

    if [ $backendOrFrontend == "backend" 2>/dev/null ]; then
        ip="10.1.0.${serverNum}"
    else
        ip=$serverIp
    fi
    timeshift --create

    # installation de net-tools pour récupérer l'ipv4 local
    apt-get install -y net-tools

    # ajout dans une variable de la carte reseaux, de l'ip et du hostname
    cartereseaux=$(ip -o -4 route show to default | awk '{print $5}')
    hostname=$(cat /etc/hostname)

    # configuration des addresse / domaine de debian pour proxmox
    echo "127.0.0.1       localhost
${serverIp}         mail.exemple.com ${hostname}
# The following lines are desirable for IPv6 capable hosts
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters" > /etc/hosts

    # mise a jours de debian en proxmox
    apt-get update -y && apt-get full-upgrade -y

    # commenter la ligne ipv6 qui bug avec proxmox
    sed -i "s/iface ${cartereseaux} inet6 auto/# iface ${cartereseaux} inet6 auto/g" /etc/network/interfaces

    # installation de proxmox
    apt-get install -y proxmox-ve open-iscsi postfix
}


function postInstallProxmox() {
    sed -i "s/deb/#deb/g" /etc/apt/sources.list.d/pve-enterprise.list 2>/dev/null
    apt-get remove linux-image-amd64 'linux-image-5.10*' os-prober -y
    pveam download local $(pveam available --section system | grep debian-11 | cut -d" " -f11)
}

$1