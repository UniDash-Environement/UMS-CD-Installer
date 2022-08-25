#!/usr/bin/bash

function installCommand() {
    cp ./asset/bin/lvm-extend.sh /bin/lvm-extend
    chmod +x /bin/lvm-extend
    cp ./asset/bin/lvm-retract.sh /bin/lvm-retract
    chmod +x /bin/lvm-retract

    cp ./asset/bin/add-ssd-key.sh /bin/add-ssd-key
    chmod +x /bin/add-ssd-key

    cp ./asset/bin/change-dns.sh /bin/change-dns
    chmod +x /bin/change-dns
    cp ./asset/bin/change-dns-client.sh /bin/change-dns-client
    chmod +x /bin/change-dns-client
}

installCommand