#!/bin/bash

source common.sh
COMPONENT=cart
NODEJS

echo Config the systemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>> /tmp/cart.log && systemctl daemon-reload &>> /tmp/cart.log
StatusCheck

echo Startng Cart servcie
systemctl start cart &>> /tmp/cart.log && systemctl enable cart &>> /tmp/cart.log
StatusCheck

