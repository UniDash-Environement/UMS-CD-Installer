#!/usr/bin/bash

function read-conf() {
    if [ -e /etc/ums-cd/install.conf ]; then
        while read var value
        do
            export "$var"="$value"
        done < /etc/ums-cd/install.conf
    fi
}

function installTimeshift() {

    apt-get install timeshift -y

    timeshift --list-devices
    clear

    # Ajouté l'UUID
    sed -i "s/\"backup_device_uuid\" : \"*\",/\"backup_device_uuid\" : \"${timeshiftUUID}\",/g" /etc/timeshift/timeshift.json

    # créer une snapshot
    sudo timeshift --create
}

read-conf
$1