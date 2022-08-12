#!/usr/bin/bash

function lvmQuestion() {
    while true; do
        clear

        echo "Voulez Vous installer:
    [0]swap
    [1]root(/)
    [2]opt(/opt)
    [3]tmp(/tmp)
    [4]usr(/usr)
    [5]var(/var)
    [6]var--log(/var/log)
    [7]var--lib(/var/lib)
    [8]mnt--timeshift(/mnt/timeshift)"
        read -p "$ " lvmVolume
        case $lvmVolume in
            [0]* ) lvmVolume="swap" && break;;
            [1]* ) lvmVolume="root" && break;;
            [2]* ) lvmVolume="opt" && break;;
            [3]* ) lvmVolume="tmp" && break;;
            [4]* ) lvmVolume="usr" && break;;
            [5]* ) lvmVolume="var" && break;;
            [6]* ) lvmVolume="var--log" && break;;
            [7]* ) lvmVolume="var--lib" && break;;
            [8]* ) lvmVolume="mnt--timeshift" && break;;
        esac
    done

    while true; do
        clear
        echo "a quel taille veut tu modifier ton volume?"
        read -p "$ " lvmSise

        if [[ $lvmSise =~ ^[0-9]+$ ]]; then
            clear
            break
        fi
    done
}


function extendLvm() {
    lvmQuestion
    lvextend -L ${lvmSise}G /dev/mapper/vg0-${lvmVolume}
    resize2fs /dev/mapper/vg0-${lvmVolume}
}