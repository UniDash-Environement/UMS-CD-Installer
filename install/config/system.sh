#!/usr/bin/bash

Function read-conf() {
    if [ -e /etc/ums-cd/install.conf ]; then
        while read var value
        do
            export "$var"="$value"
        done < /etc/ums-cd/install.conf
    fi
}

function add-administrator() {
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


function root-password() {
    echo root:$rootPass | chpasswd;
}


function change-hostname() {
    hostname="${backendOrFrontend}-${serverNum}-${lowerInfraName}"
    echo $hostname > /etc/hostname
}

read-conf
$1