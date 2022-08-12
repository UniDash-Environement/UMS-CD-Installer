#!/usr/bin/bash

function installTimeshift() {

    apt-get install timeshift -y

    timeshift --list-devices
    clear

    # Ajouté l'UUID
    sed -i "s/\"backup_device_uuid\" : \"*\",/\"backup_device_uuid\" : \"${timeshiftUUID}\",/g" /etc/timeshift/timeshift.json

    # créer une snapshot
    sudo timeshift --create
}