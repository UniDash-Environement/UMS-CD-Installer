#!/usr/bin/bash

source /etc/ums-cd/install.conf

function installTimeshift() {

    apt-get install timeshift -y

    # Generate timeshift conf file
    timeshift --list-devices
    clear

    # Add Partition UUID
    sed -i "s/\"backup_device_uuid\" : \"*\",/\"backup_device_uuid\" : \"${timeshiftUUID}\",/g" /etc/timeshift/timeshift.json
    sed -i "s/\"schedule_daily\" : \"false\",/\"schedule_daily\" : \"true\",/g" /etc/timeshift/timeshift.json
    sed -i "s/\"count_daily\" : \"5\",/\"count_daily\" : \"7\",/g" /etc/timeshift/timeshift.json

    # Add backup cron job
    echo "SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=\"\"

0 * * * * root timeshift --check --scripted" > /etc/cron.d/timeshift-hourly
    # Create snapshot
    sudo timeshift --create
}

$1