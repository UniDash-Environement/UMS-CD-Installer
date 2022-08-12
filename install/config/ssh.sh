#!/usr/bin/bash

function sshConfig() {
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g'  /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/g'                 /etc/ssh/sshd_config
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g'       /etc/ssh/sshd_config
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/g'                 /etc/ssh/sshd_config
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g'     /etc/ssh/sshd_config
    sed -i 's/#StrictModes yes/StrictModes yes/g'                       /etc/ssh/sshd_config

    while true; do
        clear

        echo "Voulez Vous Blocker le ssh par mots de pass
    [O]ui
    [N]on"
        read -p "$ " choiceEdition
        case $choiceEdition in
            [Oo]* ) sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && break;;
            [Nn]* ) break;;
        esac
    done

    systemctl restart ssh
}