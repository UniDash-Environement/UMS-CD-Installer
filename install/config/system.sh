#!/usr/bin/bash

source /etc/ums-cd/install.conf

function addAdministrator() {
    # Remove Old User
    userdel ${userName}; rm -rf /home/${userName}

    # Create New User
    useradd                        \
     --home-dir /home/${userName}  \
     --base-dir /home/${userName}  \
     --uid 1100                    \
     --groups users                \
     --no-user-group               \
     --shell /usr/bin/fish         \
     --comment "Admin"             \
     --create-home ${userName}

    # Set Password
    echo ${userName}:${userPass} | chpasswd;

    # Add User to Sudoers
    echo "${userName} ALL=(ALL) PASSWD: ALL" > /etc/sudoers.d/${userName}
}


function rootPassword() {
    echo root:$rootPass | chpasswd;
}


function changeHostname() {
    # Create Hostname
    newHostname="SRV-${backendOrFrontend}-${serverNum}-${infraName}"
    hostname=$(cat /etc/hostname)

    # Change Hostname
    sed -i "s/${hostname}/${newHostname}/g" /etc/hostname

    # Change Hosts
    sed -i "s/${hostname}/${newHostname}.local ${newHostname}/g" /etc/hosts
    sed -i "s/127.0.1.1/${serverIp}/g" /etc/hosts
}

$1