#!/usr/bin/bash

function readConf() {
    if [ -e /etc/ums-cd/install.conf ]; then
        while read var value
        do
            export "$var"="$value"
        done < /etc/ums-cd/install.conf
    fi
}

function installDocker() {
    timeshift --create

    sudo apt-get update
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin


    if [ $backendOrFrontend == "frontend" 2>/dev/null ]; then
        mkdir ./portainer
        cd ./portainer
        echo -e "$portainerCompose" > docker-compose.yml
        docker compose up -d
        cd ../

        mkdir ./reseaux
        cd ./reseaux
        echo -e "$reseauxCompose" > docker-compose.yml
        docker compose up -d
        cd ../
    else
        mkdir ./portainer_agent
        cd ./portainer_agent
        echo -e "$portainerAgentCompose" > docker-compose.yml
        docker compose up -d
        cd ../
    fi
}

readDonf
$1