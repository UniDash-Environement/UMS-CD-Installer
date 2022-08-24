#!/usr/bin/bash

function installLVMCommand() {
    cp ./asset/bin/lvm-extend.sh /bin/lvm-extend
    chmod +x /bin/lvm-extend

    cp ./asset/bin/lvm-retract.sh /bin/lvm-retract
    chmod +x /bin/lvm-retract
}

$1