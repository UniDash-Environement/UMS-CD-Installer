#!/usr/bin/bash

rm -rf /var/log/*.[1-999].*
num=1
while [ true ]
do
    logFile=$(ls /var/log/ | cut -d" " -f1 | sed -n ${num}p)

    if [ -z $logFile ]
    then
        exit
    fi

    echo "" > "/var/log/${logFile}"
    if [ $? != 0 ]
    then
        num2=1
        rm -rf /var/log/${logFile}/*.[1-999].*
        while [ true ]
        do
            logFile2=$(ls /var/log/ | cut -d" " -f1 | sed -n ${num2}p)

            if [ -z $logFile2 ]
            then
                break
            fi

            echo "" > "/var/log/${logFile}/${logFile2}"
            num2=$((${num2}+1))
        done
    fi
    num=$((${num}+1))
done