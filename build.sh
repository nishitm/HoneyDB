#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "[*] Please run as root"
  exit
fi

docker -v
if [ $? -ne 0 ]
then
  aptitude install docker.io -y
else
  echo "[*] Docker Already Installed"
fi

IP=
while [[ $IP = "" ]]; do
read -p "Enter IP address to which you want to bind your mysql server: "  IP
done

mkdir logs

docker run --name SQLi-mysql -v `pwd`/logs:/home/logs -e MYSQL_ROOT_PASSWORD=root --publish $IP:3306:3306 -d mariadb:latest

docker exec SQLi-mysql chown mysql:adm /home/logs

sleep 60
IP=$(echo "$IP" | xargs)

mysql -u root -proot -h $IP -P 3306 -e 'use mysql;source sqli.sql;'

docker cp my.cnf SQLi-mysql:/etc/mysql/

docker exec SQLi-mysql mkdir /usr/share/mysql/en_US
docker exec SQLi-mysql cp /usr/share/mysql/english/errmsg.sys /usr/share/mysql/en_US/errmsg.sys

docker restart SQLi-mysql

echo "[*] Successfully Build"
