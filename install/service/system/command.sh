#!/usr/bin/bash

function installLVMCommand() {
    cp ./asset/bin/lvm-extend.sh /bin/lvm-extend
    chmod +x /bin/lvm-extend
}

$1