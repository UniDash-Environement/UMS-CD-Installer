#!/usr/bin/bash

function allInstallPart1() {
    bash ./install/config/apt.sh aptSourceList
    bash ./install/config/system.sh rootPassword
    bash ./install/config/system.sh addAdministrator
    bash ./install/config/system.sh changeHostname
    bash ./install/service/system/timeshift.sh installTimeshift

    reboot
}


function allInstallPart2() {
    bash ./install/config/ssh.sh sshConfig
    bash ./install/network/wireguard.sh installWireguard
    bash ./install/network/interface.sh networkSet
    bash ./install/service/system/proxmox.sh installProxmox

    reboot
}


function allInstallPart3() {
    bash ./install/service/system/proxmox.sh postInstallProxmox
    bash ./install/service/system/docker.sh installDocker

    reboot
}


function allInstall(){
    while true; do
        clear

        if [ $USER == "root" 2>/dev/null ]; then
            echo "Voulez Vous installer:
        [1]Partie 1
        [2]Partie 2
        [3]Partie 3
        [E]xit"
            read -p "$ " choiceInstallRoot
            case $choiceInstallRoot in
                [1]* ) allInstallPart1;;
                [2]* ) allInstallPart2;;
                [3]* ) allInstallPart3;;
                [Ee]* ) break;;
            esac
        fi
    done
}


function installationMenu() {
    while true; do
        clear
        allAuestion
        clear

        if [ $USER == "root" ]; then
            echo "Voulez Vous installer:
    [A]ll

    [T]imeshift

    [R]oot Mots de pass
    [U]tilisateur
    [C]onfig ssh

    [L]ist Source apt
    [V]lan server
    [H]Hostname
    [W]ireguard Client
    [N]ame server

    [P]roxmox
    [S]uite de InstallProxmox
    [D]ocker

    [E]xit"
            read -p "$ " choiceInstallRoot
            case $choiceInstallRoot in
                [Hh]* ) bash ./install/config/system.sh changeHostname;;
                [Vv]* ) bash ./install/network/interface.sh networkSet;;
                [Ll]* ) bash ./install/config/apt.sh aptSourceList;;
                [Rr]* ) bash ./install/config/system.sh rootPassword;;
                [Uu]* ) bash ./install/config/system.sh addAdministrator;;
                [Ww]* ) bash ./install/network/wireguard.sh installWireguardClient;;
                [Tt]* ) bash ./install/service/system/timeshift.sh installTimeshift;;
                [Pp]* ) bash ./install/service/system/proxmox.sh installProxmox;;
                [Ss]* ) bash ./install/service/system/proxmox.sh postInstallProxmox;;
                [Dd]* ) bash ./install/service/system/docker.sh installDocker;;
                [Cc]* ) bash ./install/config/ssh.sh sshConfig;;
                [Aa]* ) allInstall;;
                [Nn]* ) bash ./install/network/interface.sh fixNameServer;;
                [Ee]* ) break;;
            esac
        fi
    done
}


function editionMenu() {
    while true; do
        clear

        echo "Voulez Vous faire une
    [L]vm
    [E]xit"
        read -p "$ " choiceEdition
        case $choiceEdition in
            [Ll]* ) lvm-extend;;
            [Ee]* ) break;;
        esac
    done
}


function start() {
    while true; do
        clear

        echo "Voulez Vous faire une
    [I]nstallation
    [M]odifiquation
    [E]xit"
        read -p "$ " choiceInstallOrEdition
        case $choiceInstallOrEdition in
            [Ii]* ) installationMenu;;
            [Mm]* ) editionMenu;;
            [Ee]* ) break;;
        esac
    done

    clear
}
start