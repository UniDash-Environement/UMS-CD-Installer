#!/usr/bin/bash

function installCommand() {
    # utilité ?
    cp ./asset/bin/add-ssd-key.sh /bin/add-ssd-key
    chmod +x /bin/add-ssd-key

    # utilité ?
    cp ./asset/bin/change-dns.sh /bin/change-dns
    chmod +x /bin/change-dns
    cp ./asset/bin/change-dns-client.sh /bin/change-dns-client
    chmod +x /bin/change-dns-client

    # A remplacer par log rotate
    cp ./asset/bin/clear-log.sh /bin/clear-log
    chmod +x /bin/clear-log
    cp ./asset/bin/auto-clear-log.sh /bin/auto-clear-log
    chmod +x /bin/auto-clear-log
    cp ./asset/systemd/auto-clear-log.service /etc/systemd/system/auto-clear-log.service
    systemctl enable --now auto-clear-log.service
}

installCommand