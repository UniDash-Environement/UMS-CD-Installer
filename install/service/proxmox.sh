#!/usr/bin/bash

source /etc/ums-cd/install.conf

function installProxmox() {
  # Add repository
  echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
  wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
  sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

  # Upgrade and install Proxmox Karnel
  apt update && apt full-upgrade -y
  apt install pve-kernel-5.15 -y
}


function postInstallProxmox() {
    # Install Proxmox
    apt install proxmox-ve postfix open-iscsi -y
    apt remove linux-image-amd64 'linux-image-5.10*' -y

    # Update Grub
    update-grub
    apt remove os-prober

    # Remove Install and entreprise repository
    rm /etc/apt/sources.list.d/pve-install-repo.list
    rm /etc/apt/sources.list.d/pve-enterprise.list
    echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
}

$1