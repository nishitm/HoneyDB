#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "[*] Please run as root"
  exit
fi

lxc-ls

if [ $? -ne 0 ]
then
  aptitude install lxc lxc-templates lxc-dev -y
fi

lxc-create -t ubuntu -n db-server

if [ $? -ne 0 ]
then
  echo "[*] ERROR in lxc-create!!"
  echo "[*] Trying to re-create if exist"
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

python3 --version

if [ $? -ne 0 ]
then
  aptitude install python3 python3-pip -y
fi

aptitude install python3-lxc -y

python3 lxc-script.py

if [ $? -ne 0 ]
then
  echo "[*] Error in Python Script!!\n"
  exit
fi

echo "[*] Successfully Build"
