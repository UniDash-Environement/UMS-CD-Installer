#!/usr/bin/bash

# changer les dépot proxmox pour ceut de debian 11

function aptSourceList() {
    rm -rf /etc/apt/sources.list.d/*
    mkdir /etc/apt/sources.list.d
    echo "" > /etc/apt/sources.list

    echo "#Debian Officiel:
deb http://deb.debian.org/debian/                       bullseye main
deb http://deb.debian.org/debian/                       bullseye-updates main contrib

#Debian Source:
deb-src http://deb.debian.org/debian/                   bullseye main
deb-src http://deb.debian.org/debian/                   bullseye-updates main contrib

#Backports:
deb http://deb.debian.org/debian        bullseye-backports main contrib non-free

#Backports Source:
deb-src http://deb.debian.org/debian    bullseye-backports main contrib non-free

#Security
deb http://security.debian.org/debian-security          bullseye-security main contrib
deb-src http://security.debian.org/debian-security      bullseye-security main contrib"\
     > /etc/apt/sources.list.d/debian.list

    echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bullseye pve-no-subscription" \
     > /etc/apt/sources.list.d/pve-install-repo.list
    wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg \
     -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

    apt-get update -y
    apt-get upgrade -y
}

$1