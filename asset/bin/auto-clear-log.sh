#!/bin/bash

while [ true ]
do
    #logLife=$(df -h | grep vg0-var--log | sed "s/  / /g" | sed "s/  / /g" | sed "s/  / /g" | sed "s/  / /g" | sed "s/  / /g" | cut -d" " -f5 | sed "s/>
    logLife=81
    if (( $logLife >= 80 ))
    then
        clear-log
    fi
    sleep 30
done
