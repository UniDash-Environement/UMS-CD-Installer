#!/usr/bin/bash

function backendOrFrontendQuestion() {
    backendOrFrontend=""
    while [backendOrFrontend == "Back" 2>/dev/null || backendOrFrontend == "Front" 2>/dev/null]; do
        clear

        echo "Votre serveur est un [B]ack ou un [F]ront?"
        read -p "$ " backendOrFrontend
    done
}


function questionReseaux() {
    serverIp=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
    serverGateway=$(/sbin/ip route | awk '/default/ { print $3 }')
    serverMask=$(ip -f inet -o addr|cut -d\  -f 7 | grep $serverIp | cut -d/ -f 2)
    serverInterface=$(ip -br a | grep $serverIp | cut -d " " -f 1)

    while [ $userName != "" 2>/dev/null ]; do
        clear

        echo "Quel est l'ip de la super node que vous souaiter?"
        read -p "$ " superNodeIp
    done
}


function serverNumQuestion() {
    while [ $serverNum =~ ^[0-9]+$ && $serverNum != "" 2>/dev/null]; do
        clear

        echo "Quel est le numéro de votre serveur?"
        read -p "$ " serverNum
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
    while [ $userName != "" 2>/dev/null ]; do
        clear

        echo "Quel est le nouveau nom d'utilisateur que vous souaiter?"
        read -p "$ " userName

        if [ $userName != "" 2>/dev/null ]; then
            userName=$(echo $userName | tr '[A-Z]' '[a-z]')
        fi
    done
}


function questionUser () {
    questionUserName
    while [$userPass != "" 2>/dev/null && $userPass2 != "" 2>/dev/null && $userPass == $userPass2 2>/dev/null ]; do
        clear

        echo "Quel est sont mots de pass?"
        read -s -p "$ " userPass
        clear

        echo "Répter le."
        read -s -p "$ " userPass2
    done
}


function questionRoot () {
    while [ $rootPass != "" 2>/dev/null && $rootPass2 != "" 2>/dev/null && $rootPass == $rootPass2 2>/dev/null ]; do
        clear

        echo "Quel est le nouveau mots de pass root que vous souaiter?"
        read -s -p "$ " rootPass
        clear

        echo "Répter le."
        read -s -p "$ " rootPass2
    done
}


function allQuestion() {
    # Execute auto Question
    questionRoot
    questionUser
    infraNameQuestion
    questionReseaux
    questionTimeshift

    # Execute manual Question
    serverNumQuestion
    backendOrFrontendQuestion

    # Create Conf file
    mkdir /etc/ums-cd
    touch /etc/ums-cd/install.conf

    # Write Conf file
    echo -e "backendOrFrontend=${backendOrFrontend}" > /etc/ums-cd/install.conf
    echo -e "serverIp=${serverIp}" >> /etc/ums-cd/install.conf
    echo -e "superNodeIp=${superNodeIp}" >> /etc/ums-cd/install.conf
    echo -e "serverInterface=${serverInterface}" >> /etc/ums-cd/install.conf
    echo -e "serverGateway=${serverGateway}" >> /etc/ums-cd/install.conf
    echo -e "serverMask=${serverMask}" >> /etc/ums-cd/install.conf
    echo -e "serverNum=${serverNum}" >> /etc/ums-cd/install.conf
    echo -e "lowerInfraName=${lowerInfraName}" >> /etc/ums-cd/install.conf
    echo -e "infraName=${infraName}" >> /etc/ums-cd/install.conf
    echo -e "timeshiftUUID=${timeshiftUUID}" >> /etc/ums-cd/install.conf
    echo -e "userName=${userName}" >> /etc/ums-cd/install.conf
    echo -e "userPass=${userPass}" >> /etc/ums-cd/install.conf
    echo -e "rootPass=${rootPass}" >> /etc/ums-cd/install.conf

    echo -e "backendOrFrontend=${backendOrFrontend}" > /etc/ums-cd/config.conf
    echo -e "serverNum=${serverNum}" >> /etc/ums-cd/config.conf
    echo -e "lowerInfraName=${lowerInfraName}" >> /etc/ums-cd/config.conf
    echo -e "infraName=${infraName}" >> /etc/ums-cd/config.conf

    # Set permission to conf file
    chmod +x /etc/ums-cd/install.conf
    chmod +x /etc/ums-cd/config.conf
}

function start() {
    # Check if conf file exist or if -f is set
    if [ ! -f /etc/ums-cd/install.conf || $1 == "-f" 2>/dev/null ]; then
        allQuestion
    fi
}

start