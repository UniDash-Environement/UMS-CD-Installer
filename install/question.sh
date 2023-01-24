#!/usr/bin/bash

function backendOrFrontendQuestion() {
  backendOrFrontend=""
  while [[ $backendOrFrontend != "Back" && $backendOrFrontend != "Front" ]]; do
    clear

    echo "Votre serveur est un [Back] ou un [Front] ?"
    read -p "$ " backendOrFrontend
  done
}


function questionReseaux() {
  serverIp=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
  serverGateway=$(/sbin/ip route | awk '/default/ { print $3 }')
  serverMask=$(ip -f inet -o addr|cut -d\  -f 7 | grep $serverIp | cut -d/ -f 2)
  serverInterface=$(ip -br a | grep $serverIp | cut -d " " -f 1)

  superNodeIp=""
  while [[ $superNodeIp == "" ]]; do
    clear

    echo "Quel est l'ip de la super node que vous souaiter?"
    read -p "$ " superNodeIp
  done
}


function serverNumQuestion() {
  serverNum=""

  while [[ ! $serverNum =~ ^[0-9]+$ || $serverNum == "" ]]; do
    clear

    echo "Quel est le numéro de votre serveur?"
    read -p "$ " serverNum
  done
}


function infraNameQuestion() {
  infraName="UMS-CD"
  lowerInfraName="ums-cd"
}


function questionTimeshift () {
  timeshiftUUID=$(blkid | grep vg0-mnt--timeshift | cut -d "\"" -f 2 )

  if [[ $timeshiftUUID == "" ]]; then
    timeshiftUUID=$(blkid | grep sda1 | cut -d "\"" -f 2)
  fi
}


function questionUserName () {
  userName=""

  while [[ $userName == "" ]]; do
    clear

    echo "Quel est le nouveau nom d'utilisateur que vous souaiter?"
    read -p "$ " userName

    if [ $userName != "" ]; then
        userName=$(echo $userName | tr '[A-Z]' '[a-z]')
    fi
  done
}


function questionUser () {
  questionUserName

  userPass=""
  while [[ $userPass == "" || $userPass2 == "" || $userPass != $userPass2 ]]; do
    clear

    echo "Quel est sont mots de pass?"
    read -s -p "$ " userPass
    clear

    echo "Répter le."
    read -s -p "$ " userPass2
  done
}


function questionRoot () {
  rootPass=""

  while [[ $rootPass == "" || $rootPass2 == "" || $rootPass != $rootPass2 ]]; do
    clear

    echo "Quel est le nouveau mots de pass root que vous souaiter?"
    read -s -p "$ " rootPass
    clear

    echo "Répter le."
    read -s -p "$ " rootPass2
  done
}


function allQuestion() {
  # Execute auto Question
  questionRoot
  questionUser
  infraNameQuestion
  questionReseaux
  questionTimeshift

  # Execute manual Question
  serverNumQuestion
  backendOrFrontendQuestion

  # Create Conf file
  rm -rf /etc/ums-cd
  mkdir /etc/ums-cd
  touch /etc/ums-cd/install.conf

  # Write Conf file
  echo -e "backendOrFrontend=${backendOrFrontend}" > /etc/ums-cd/install.conf
  echo -e "serverIp=${serverIp}" >> /etc/ums-cd/install.conf
  echo -e "superNodeIp=${superNodeIp}" >> /etc/ums-cd/install.conf
  echo -e "serverInterface=${serverInterface}" >> /etc/ums-cd/install.conf
  echo -e "serverGateway=${serverGateway}" >> /etc/ums-cd/install.conf
  echo -e "serverMask=${serverMask}" >> /etc/ums-cd/install.conf
  echo -e "serverNum=${serverNum}" >> /etc/ums-cd/install.conf
  echo -e "lowerInfraName=${lowerInfraName}" >> /etc/ums-cd/install.conf
  echo -e "infraName=${infraName}" >> /etc/ums-cd/install.conf
  echo -e "timeshiftUUID=${timeshiftUUID}" >> /etc/ums-cd/install.conf
  echo -e "userName=${userName}" >> /etc/ums-cd/install.conf
  echo -e "userPass=${userPass}" >> /etc/ums-cd/install.conf
  echo -e "rootPass=${rootPass}" >> /etc/ums-cd/install.conf

  echo -e "backendOrFrontend=${backendOrFrontend}" > /etc/ums-cd/config.conf
  echo -e "serverNum=${serverNum}" >> /etc/ums-cd/config.conf
  echo -e "lowerInfraName=${lowerInfraName}" >> /etc/ums-cd/config.conf
  echo -e "infraName=${infraName}" >> /etc/ums-cd/config.conf

  # Set permission to conf file
  chmod +x /etc/ums-cd/install.conf
  chmod +x /etc/ums-cd/config.conf
}

function start() {
  # Check if conf file exist or if -f is set
  echo $1
  if [[ ! -f /etc/ums-cd/install.conf || $1 == "-f" ]]; then
    echo "test"
    allQuestion
  fi
}

start $1