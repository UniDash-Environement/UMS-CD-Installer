#!/usr/bin/bash

# Metre a jours ce fichier avec mais nouvelle doc

source /etc/ums-cd/install.conf

function addAdministrator() {
    apt-get install -y sudo

    UTILISATEUR=$userName
    PASSWORD=$userPass

    DESCRIPTION=Administrateur
    USER_ID=1100
    GROUP=users

    /usr/sbin/useradd             \
    --home-dir /home/$UTILISATEUR \
    --base-dir /home/$UTILISATEUR \
    --uid $USER_ID                \
    --groups $GROUP               \
    --no-user-group               \
    --shell /bin/bash             \
    --comment "$DESCRIPTION"      \
    --create-home $UTILISATEUR 2>/dev/null

    echo $UTILISATEUR:$PASSWORD | chpasswd;

    echo "$UTILISATEUR ALL=(ALL) PASSWD: ALL" > /etc/sudoers.d/$UTILISATEUR
}


function rootPassword() {
    echo root:$rootPass | chpasswd;
}


function changeHostname() {
    # Create Hostname Part
    numServer=${serverNum}
    vpsOrSRV="SRV"
    typeServer=${backendOrFrontend}
    infraName=${InfraName}

    # Compile Hostname
    newHostname=${vpsOrSRV}-${typeServer}-${numServer}-${infraName}
    hostname=$(cat /etc/hostname)

    # Change Hostname
    sed -i "s/${hostname}/${newHostname}/g" /etc/hostname

    # Change Hosts
    sed -i "s/${hostname}/${newHostname}.local ${newHostname}/g" /etc/hosts
    sed -i "s/127.0.1.1/${serverIp}/g" /etc/hosts
    hostname --ip-address
}

$1