#!/usr/bin/bash

function allInstallPart1() {
    bash ./install/service/system/command.sh installLVMCommand
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


function mainMenu() {
    while true; do
        clear
        allAuestion
        clear

        if [ $USER == "root" ]; then
            choiceInstallMethod=$(whiptail --title "UMS-CD Installer" --menu "Choose an install method" 15 60 3 \
            "autoInstall" "Automatic Installation" \
            "manualInstall" "Manual Installation" \
            "editMenu" "Open Edit Menu" 3>&1 1>&2 2>&3)

            if [ $choiceInstallMethod == "autoInstall" ]; then
                allInstall
            else if [ $choiceInstallMethod == "editMenu"]
                editMenu
            fi

            if [ -z $choiceInstallMethod ]; then
                break
            fi

            if [ $choiceInstallMethod == "manualInstall" ]; then
                choiceInstallRoot=$(whiptail --title "UMS-CD Manual Installer" --menu "Choose an option" 15 60 14 \
                "timeshift" "Install and Configure Timeshift" \
                "rootPassword" "Set Root Password" \
                "user" "Add An Administrator" \
                "sshConfigure" "Configure SSH" \
                "listApt" "Add APT Sources List" \
                "vlanServer" "Configure Network Interface" \
                "hostname" "Configure Hostname" \
                "wireguardClient" "Configure Wireguard Client" \
                "nameServer" "Start taking defined backup" \
                "proxmoxP1" "Install Proxmox (Part 1)" \
                "proxmoxP2" "Install Proxmox (Part 2)" \
                "docker" "Install Docker" \
                "exit" "Exit Manual Installer" 3>&1 1>&2 2>&3)

                case $choiceInstallRoot in
                    Hostname ) bash ./install/config/system.sh changeHostname;;
                    VlanServer ) bash ./install/network/interface.sh networkSet;;
                    ListApt ) bash ./install/config/apt.sh aptSourceList;;
                    RootPassword ) bash ./install/config/system.sh rootPassword;;
                    User ) bash ./install/config/system.sh addAdministrator;;
                    WireguardClient ) bash ./install/network/wireguard.sh installWireguardClient;;
                    NameServer ) bash ./install/service/system/timeshift.sh installTimeshift;;
                    ProxmoxP1 ) bash ./install/service/system/proxmox.sh installProxmox;;
                    ProxmoxP2 ) bash ./install/service/system/proxmox.sh postInstallProxmox;;
                    Docker ) bash ./install/service/system/docker.sh installDocker;;
                    SshConfigure ) bash ./install/config/ssh.sh sshConfig;;
                    NameServer ) bash ./install/network/interface.sh fixNameServer;;
                    Exit ) break;;
                esac
            fi    
        fi
    done
}


function editMenu() {
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
mainMenu