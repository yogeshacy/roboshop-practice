#!/bin/bash

#set -e
COMPONENT=rabbitmq
source common.sh

if [ -z "$APP_RABBITMQ_PASSWORD" ]; then
   echo -e "\e[33m env app password needed \e[0m"
   exit 1
fi

echo Setup yum repo
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
StatusCheck

echo Install Earlang and Rabbitmq
yum install erlang -y &>>${LOG}

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}

yum install erlang -y &>>${LOG}
StatusCheck

echo Start rabbitmq service
systemctl enable rabbitmq-server &>>${LOG} && systemctl start rabbitmq-server &>>${LOG}
StatusCheck

echo Add app user in rmq
rabbitmqctl add_user roboshop $APP_RABBITMQ_PASSWORD &>>${LOG} && rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
StatusCheck
