#!/usr/bin/bash

function allInstallPart1() {
    bash ./install/config/apt.sh aptSourceList
    read
    bash ./install/config/system.sh rootPassword
    read
    bash ./install/config/system.sh addAdministrator
    read
    bash ./install/config/system.sh changeHostname
    read
    bash ./install/service/system/timeshift.sh installTimeshift
    read
    sed -i "s/cd \/root && git clone --branch v2 https:\/\/github.com\/UMS-CD\/UMS-CD-Installer.git//g" /root/.bashrc
    sed -i "s/cd \/root\/UMS-CD-Installer && bash install.sh part1//g" /root/.bashrc
    echo "cd /root/UMS-CD-Installer && bash install.sh part2" >> /root/.bashrc
    reboot
}


function allInstallPart2() {
    bash ./install/config/ssh.sh sshConfig
    read
    bash ./install/network/interface.sh networkSet
    read
    bash ./install/service/system/proxmox.sh installProxmox
    sed -i "s/cd \/root\/UMS-CD-Installer && bash install.sh part2//g" /root/.bashrc
    echo "cd /root/UMS-CD-Installer && bash install.sh part3" >> /root/.bashrc
    reboot
}


function allInstallPart3() {
    sed -i "s/cd \/root\/UMS-CD-Installer && bash install.sh part3//g" /root/.bashrc
    bash ./install/service/system/proxmox.sh postInstallProxmox
    read
    rm -rf /etc/ums-cd/install.conf
    reboot
}

function mainMenu() {
    while true; do
        clear

        if [ ${USER} == "root" ]; then
            choiceInstallMethod=$(whiptail --title "UMS-CD Installer" --menu "Choose an install method" 15 60 3 \
            "autoInstall" "Automatic Installation" \
            "manualInstall" "Manual Installation" \
            "editMenu" "Open Edit Menu" 3>&1 1>&2 2>&3)

            if [ ${choiceInstallMethod} == "autoInstall" ]; then
                allInstallPart1
            elif [ ${choiceInstallMethod} == "editMenu" ]; then
                editMenu
            elif [ -z ${choiceInstallMethod} ]; then
                break
            fi

            if [ ${choiceInstallMethod} == "manualInstall" ]; then
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
                "docker" "Install Docker" 3>&1 1>&2 2>&3)

                if [ -z ${choiceInstallRoot} ]; then
                  break
                fi

                case ${choiceInstallRoot} in
                    hostname ) bash ./install/config/system.sh changeHostname;;
                    vlanServer ) bash ./install/network/interface.sh networkSet;;
                    listApt ) bash ./install/config/apt.sh aptSourceList;;
                    rootPassword ) bash ./install/config/system.sh rootPassword;;
                    user ) bash ./install/config/system.sh addAdministrator;;
                    wireguardClient ) bash ./install/network/wireguard.sh installWireguardClient;;
                    nameServer ) bash ./install/service/system/timeshift.sh installTimeshift;;
                    proxmoxP1 ) bash ./install/service/system/proxmox.sh installProxmox;;
                    proxmoxP2 ) bash ./install/service/system/proxmox.sh postInstallProxmox;;
                    docker ) bash ./install/service/system/docker.sh installDocker;;
                    sshConfigure ) bash ./install/config/ssh.sh sshConfig;;
                    nameServer ) bash ./install/network/interface.sh fixNameServer;;
                esac
            fi
        fi
    done
}


function editMenu() {
    while true; do
        clear
            choice=$(whiptail --title "UMS Tweaker" --menu "Choose an Option" 15 60 3 \
            "lvm" "LVM Resize" \
            "changeDns" "Change DNS Settings" \
            "shareSshKey" "Share SSH Key to Other Servers" \
            "clearLogs" "Clear Server Logs" \
            "fixNetwork" "Reload and Reconfigure Network Settings" 3>&1 1>&2 2>&3)
        if [ -z ${choice} ]; then
            break
        fi
        case ${choice} in
            lvm ) lvmMenu;;
            changeDns ) changeDns;;
            shareSshKey ) shareSshKey;;
            clearLogs ) clearLogs;;
            fixNetwork ) fixNetwork;;
        esac
    done
}
function lvmMenu() {
    while true; do
        clear
            choice=$(whiptail --title "UMS Tweaker : LVM" --menu "Choose an Option" 15 60 3 \
            "extend" "extend LVM partition" \
            "retract" "retract LVM partition" 3>&1 1>&2 2>&3)

        case ${choice} in
            extend ) lvm-extend;;
            retract ) lvm-retract;;
        esac
    done
}

bash ./install/question.sh

if [ -z $1 ]; then
    mainMenu
elif [ $1 == "part1" ]; then
    allInstallPart1
elif [ $1 == "part2" ]; then
    allInstallPart2
elif [ $1 == "part3" ]; then
    allInstallPart3
fi