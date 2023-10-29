#!/bin/bash

#set -e
source common.sh
COMPONENT=mysql

echo setup yum mysql repo
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
StatusCheck

echo MySQL Install
yum install mysql-community-server -y &>>${LOG}
StatusCheck

echo Start mysql service
systemctl enable mysqld &>>${LOG} && systemctl start mysqld &>>${LOG}
StatusCheck

echo "show databases;" | grep -uroot -p$MYSQL_PASSWORD &>>${LOG}
if [ $? -ne 0 ]; then
  DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk  '{print $NF}')
  echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWORD';" | mysql -uroot -p${DEFAULT_PASSWORD}
  StatusCheck
fi

#echo "show plugins;" | grep -uroot -p$MYSQL_PASSWORD 2>&1 | grep validate_password &>>${LOG}
#if [ $? -eq 0 ]; then
#  echo Remove password validation plugin
#  echo "uninstall plugin validate_password;" | | mysql -uroot -p$MYSQL_PASSWORD
#  StatusCheck
#fi

#grep temp /var/log/mysqld.log

#mysql_secure_installation

#mysql_secure_installation
# export MYSQL_PASSWORD=RoboShop@1
#> uninstall plugin validate_password;

DOWNLOAD

echo Extract and load Schema
cd /tmp &>>${LOG} && unzip -o mysql.zip &>>${LOG} && cd mysql-main &>>${LOG} && mysql -u root -pRoboShop@1 <shipping.sql
