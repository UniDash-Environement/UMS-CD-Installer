#!/usr/bin/bash

function all-install(){
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
                [1]* ) apt-source-list && root-password && add-administrator && change-hostname && install-timeshift && reboot;;
                [2]* ) ssh-config && install-wireguard && network-set && install-proxmox && reboot;;
                [3]* ) post-install-proxmox && install-docker && reboot;;
                [Ee]* ) break;;
            esac
        fi
    done
}


function installation-menu() {
    while true; do
        clear
        all-auestion
        clear

        if [ $USER == "root" ]; then
            echo "Voulez Vous installer:
    [A]ll (sauf zsh il faut l'éxécuté une fois en utilisateur)

    [T]imeshift

    [R]oot Mots de pass
    [U]tilisateur
    [F]r keyboard
    [Z]SH
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
                [Ff]* ) fr-keyboard;;
                [Hh]* ) change-hostname;;
                [Vv]* ) network-set;;
                [Ll]* ) apt-source-list;;
                [Rr]* ) root-password;;
                [Uu]* ) add-administrator;;
                [Zz]* ) install-zsh;;
                [Ww]* ) install-wireguard-client;;
                [Tt]* ) install-timeshift;;
                [Pp]* ) install-proxmox;;
                [Ss]* ) post-install-proxmox;;
                [Dd]* ) install-docker;;
                [Cc]* ) ssh-config;;
                [Aa]* ) all-install;;
                [Nn]* ) fix-name-server;;
                [Ee]* ) break;;
            esac
        else
            echo "Voulez Vous installer:
    [Z]SH
    [E]xit"
            read -p "$ " choiceInstall
            case $choiceInstall in
                [Zz]* ) install-zsh;;
                [Ee]* ) break;;
            esac
        fi
    done
}


function edition-menu() {
    while true; do
        clear

        echo "Voulez Vous faire une
    [L]vm
    [E]xit"
        read -p "$ " choiceEdition
        case $choiceEdition in
            [Ll]* ) extend-lvm;;
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
            [Ii]* ) installation-menu;;
            [Mm]* ) edition-menu;;
            [Ee]* ) break;;
        esac
    done

    clear
}
start