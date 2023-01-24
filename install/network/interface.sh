#!/usr/bin/bash

# suprimer le fichier fix-network et sont service pour le corriger ici

function networkSet(){
    cp ./asset/bin/fix-network.sh /bin/fix-network
    chmod +x /bin/fix-network

    cp ./asset/systemd/fix-network.service /etc/systemd/system/fix-network.service
    systemctl enable --now fix-network.service
}

$1