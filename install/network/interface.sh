#!/usr/bin/bash

source /etc/ums-cd/install.conf

function networkSet(){
  # Change DNS Config
  echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolv.conf

  # Install N2N
  wget https://packages.ntop.org/apt-stable/bullseye/all/apt-ntop-stable.deb && apt install -y ./apt-ntop-stable.deb

  apt-get clean all -y
  apt-get update
  apt-get install -y pfring-dkms nprobe ntopng n2disk cento pfring-drivers-zc-dkms iptables resolvconf n2n

  # Change N2N SuperNote Port
  echo "-p=5182" > /etc/n2n/supernode.conf
  systemctl enable --now supernode

  # Change Edge Config
  echo "-d n2n0
  -c VPN-${infraName}
  -k ${userPass}
  -a 10.255.0.${serverNum}/8
  -f
  -l ${superNodeIp}:5182" > /etc/n2n/edge.conf

  # Change Network Config
  echo "source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback
# Interface Loopback

auto ${serverInterface}
iface ${serverInterface} inet manual
# Physique Interface (Down for VMBR255)

auto vmbr255
iface vmbr255 inet static
        address         ${serverIp}/${serverMask}
        gateway         ${serverGateway}

        bridge-ports    ${serverInterface}
        bridge-stp      off
        bridge-fd       0
# VMBR255 Interface (Physique Network)

auto n2n0
iface n2n0 inet manual
        address         10.255.0.${numServer}/8
        up              systemctl restart edge.service
# N2N Interface (VPN Network)

auto vmbr0
iface vmbr0 inet static
        address         172.31.0.1/16

        bridge-ports    none
        bridge-stp      off
        bridge-fd       0

        post-up         echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up         iptables -t nat -A POSTROUTING -s \"172.31.0.0/16\" -o vmbr255 -j MASQUERADE
        post-down       iptables -t nat -D POSTROUTING -s \"172.31.0.0/16\" -o vmbr255 -j MASQUERADE
# VMBR0 Interface (Nat Network)" > /etc/network/interfaces

  # Apply Configuration
  systemctl restart networking.service
}

$1