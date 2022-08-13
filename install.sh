#!/usr/bin/bash

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
                [1]* ) aptSourceList && rootPassword && addAdministrator && changeHostname && installTimeshift && reboot;;
                [2]* ) sshConfig && installWireguard && networkSet && installProxmox && reboot;;
                [3]* ) postInstallProxmox && installDocker && reboot;;
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
                [Ff]* ) frKeyboard;;
                [Hh]* ) changeHostname;;
                [Vv]* ) networkSet;;
                [Ll]* ) aptSourceList;;
                [Rr]* ) rootPassword;;
                [Uu]* ) addAdministrator;;
                [Zz]* ) installZsh;;
                [Ww]* ) installWireguardClient;;
                [Tt]* ) installTimeshift;;
                [Pp]* ) installProxmox;;
                [Ss]* ) postInstallProxmox;;
                [Dd]* ) installDocker;;
                [Cc]* ) sshConfig;;
                [Aa]* ) allInstall;;
                [Nn]* ) fixNameServer;;
                [Ee]* ) break;;
            esac
        else
            echo "Voulez Vous installer:
    [Z]SH
    [E]xit"
            read -p "$ " choiceInstall
            case $choiceInstall in
                [Zz]* ) installZsh;;
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
            [Ll]* ) extendLvm;;
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