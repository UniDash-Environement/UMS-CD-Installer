#!/usr/bin/bash

function backendOrFrontend-question() {
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
    infraName="UMS-CD"
    lowerInfraName="ums-cd"
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

    mkdir /etc/ums-cd
    touch /etc/ums-cd/install.conf

    echo -e "backendOrFrontend=${backendOrFrontend}\n" > /etc/ums-cd/install.conf
    echo -e "serverIp=${serverIp}\n" >> /etc/ums-cd/install.conf
    echo -e "serverGateway=${serverGateway}\n" >> /etc/ums-cd/install.conf
    echo -e "serverMask=${serverMask}\n" >> /etc/ums-cd/install.conf
    echo -e "serverNum=${serverNum}d\n" >> /etc/ums-cd/install.conf
    echo -e "lowerInfraName=${lowerInfraName}\n" >> /etc/ums-cd/install.conf
    echo -e "infraName=${infraName}\n" >> /etc/ums-cd/install.conf
    echo -e "timeshiftUUID=${timeshiftUUID}\n" >> /etc/ums-cd/install.conf
    echo -e "userName=${userName}\n" >> /etc/ums-cd/install.conf
    echo -e "userPass=${userPass}\n" >> /etc/ums-cd/install.conf
    echo -e "rootPass=${rootPass}\n" >> /etc/ums-cd/install.conf

    echo -e "backendOrFrontend=${backendOrFrontend}\n" > /etc/ums-cd/config.conf
    echo -e "serverNum=${serverNum}d\n" >> /etc/ums-cd/config.conf
}

function readConf() {
    if [ -f /etc/ums-cd/install.conf ]; then
        while read var value
        do
            export "$var"="$value"
        done < /etc/ums-cd/install.conf
    fi
}

function start() {
    if [ ! -f /etc/ums-cd/install.conf ]; then
        allQuestion
    elif [ $1 == "-f" 2>/dev/null ]; then
        allQuestion
    fi
}

start