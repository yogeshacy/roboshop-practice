#!/bin/bash

#set -e
source common.sh
COMPONENT=mongodb

echo Setup mongo repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
StatusCheck

echo Install MongoDB
yum install -y mongodb-org &>>${LOG}
StatusCheck

echo Start MongoDB Servce
systemctl enable mongod &>>${LOG} && systemctl start mongod &>>${LOG}
StatusCheck

DOWNLOAD

echo Extract schema files
cd /tmp && unzip -o mongodb.zip &>>${LOG}
StatusCheck

echo Load Schhema
cd mongodb-main &>>${LOG} && mongo < catalogue.js &>>${LOG} && mongo < users.js &>>${LOG}
StatusCheck