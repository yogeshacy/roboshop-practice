#!/bin/bash

#set -e
source common.sh
COMPONENT=redis

echo setup yum repo
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
StatusCheck

echo installing redis
yum install redis-6.2.13 -y &>>${LOG}
StatusCheck

echo start redis
systemctl enable redis &>>${LOG} && systemctl start redis &>>${LOG}
StatusCheck
