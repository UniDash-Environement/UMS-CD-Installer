#!/usr/bin/bash

# changer les dépot proxmox pour ceut de debian 11

function aptSourceList() {
    rm -rf /etc/apt/sources.list.d/*
    mkdir /etc/apt/sources.list.d
    echo "" > /etc/apt/sources.list

    echo "deb http://deb.debian.org/debian bullseye main contrib non-free
    deb-src http://deb.debian.org/debian bullseye main contrib non-free

    deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
    deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free

    deb http://deb.debian.org/debian bullseye-updates main contrib non-free
    deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free" > /etc/apt/sources.list

    apt-get update -y
    apt-get upgrade -y
}

$1