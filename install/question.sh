#!/usr/bin/bash

function backendOrFrontendQuestion() {
    while true; do
        clear

        echo "Votre serveur est un [B]ackend ou un [F]rontend?"
        read -p "$ " backendOrFrontend

        case $backendOrFrontend in
            [Bb]* ) backendOrFrontend="backend" && break;;
            [Ff]* ) backendOrFrontend="frontend" && break;;
        esac
    done
}


function questionReseaux() {
    serverIp=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
    serverGateway=$(/sbin/ip route | awk '/default/ { print $3 }')
    serverMask=$(ip -f inet -o addr|cut -d\  -f 7 | grep $serverIp | cut -d/ -f 2)
}


function serverNumQuestion() {
    while true; do
        clear

        echo "Quel est le numéro de votre serveur?"
        read -p "$ " serverNum

        if [[ $serverNum =~ ^[0-9]+$ ]]; then
            if [ $serverNum != "" 2>/dev/null ]; then
                break
            fi
        fi
    done
}


function infraNameQuestion() {
    infraName="Upscalable_MultiSite-Cloud_Deployer"
    lowerInfraName="upscalable_multiSite-cloud_deployer"
}


function questionTimeshift () {
    timeshiftUUID=$(blkid | grep vg0-mnt--timeshift | cut -d "\"" -f 2 )

    if [ $timeshiftUUID == "" ]; then
        timeshiftUUID=$(blkid | grep sda1 | cut -d "\"" -f 2)
    fi
}


function questionUserName () {
    while true; do
        clear

        echo "Quel est le nouveau nom d'utilisateur que vous souaiter?"
        read -p "$ " userName

        if [ $userName != "" 2>/dev/null ]; then
            userName=$(echo $userName | tr ‘[A-Z]’ ‘[a-z]’)
            break
        fi
    done
}


function questionUser () {
    questionUserName
    while true; do
        clear

        echo "Quel est sont mots de pass?"
        read -s -p "$ " userPass
        clear

        echo "Répter le."
        read -s -p "$ " userPass2

        if [ $userPass != "" 2>/dev/null ]; then
            if [ $userPass2 != "" 2>/dev/null ]; then
                if [ $userPass == $userPass2 2>/dev/null ]; then
                    break
                fi
            fi
        fi
    done
}


function questionRoot () {
    while true; do
        clear

        echo "Quel est le nouveau mots de pass root que vous souaiter?"
        read -s -p "$ " rootPass
        clear

        echo "Répter le."
        read -s -p "$ " rootPass2

        if [ $rootPass != "" 2>/dev/null ]; then
            if [ $rootPass2 != "" 2>/dev/null ]; then
                if [ $rootPass == $rootPass2 2>/dev/null ]; then
                    break
                fi
            fi
        fi
    done
}


function allQuestion() {
    questionRoot
    questionUser
    infraNameQuestion
    questionReseaux
    questionTimeshift

    serverNumQuestion
    backendOrFrontendQuestion

}