#!/bin/bash

#set -e
COMPONENT=rabbitmq
source common.sh

yum install python36 gcc python3-devel -y

useradd roboshop

cd /home/roboshop
rm -rf payment
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
unzip -o /tmp/payment.zip
mv payment-main payment

cd /home/roboshop/payment
pip3 install -r requirements.txt

mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment
systemctl start payment

