#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "[*] Please run as root"
  exit
fi

lxc-ls

if [ $? -ne 0 ]
then
  aptitude install lxc lxc-templates lxc-dev lxc-common -y
fi

lxc-create -t ubuntu -n db-server

if [ $? -ne 0 ]
then
  echo "[*] ERROR in lxc-create!!"
  echo "[*] Trying to re-create if exist"
  aptitude install debootstrap -y
  lxc-create -t ubuntu -n db-server
  lxc-info -n db-server
  if [ $? -ne 0 ]
  then
    echo "[*] Container not exist" 
    exit
  else
    lxc-stop -n db-server
    lxc-destroy -n db-server
    lxc-create -t ubuntu -n db-server
  fi
fi
sleep 5
lxc-stop -n db-server
sleep 5
lxc-start -n db-server

if [ $? -ne 0 ]
then
  echo "[*] Error in Container Starting"
  exit
fi

sleep 5
lxc-attach -n db-server -- apt-get install aptitude -y

if [ $? -ne 0 ]
then
  echo "[*] Error in lxc-attach (apt-get install aptitude -y)!!"
    exit
fi

lxc-attach -n db-server -- aptitude install debconf-utils -y

if [ $? -ne 0 ]
then
  echo "[*] Error in lxc-attach (aptitude install debconf-utils -y)!!"
    exit
fi

lxc-attach -n db-server -- debconf-set-selections <<< 'mariadb-server mariadb-server/root_password password n0tActualD13'

if [ $? -ne 0 ]
then
  echo "[*] Error in lxc-attach (debconf-set-selections <<< 'mariadb-server mariadb-server/root_password password n0tActualD13')!!"
    exit
fi

lxc-attach -n db-server -- debconf-set-selections <<< 'mariadb-server mariadb-server/root_password_again password n0tActualD13'

if [ $? -ne 0 ]
then
  echo "[*] Error in lxc-attach (debconf-set-selections <<< 'mariadb-server mariadb-server/root_password_again password n0tActualD13')!!"
    exit
fi

lxc-attach -n db-server -- aptitude install mariadb-server -y

if [ $? -ne 0 ]
then
  echo "[*] Error in lxc-attach (aptitude install mariadb-server -y)!!"
    exit
fi


echo "[*] Successfully Build"
