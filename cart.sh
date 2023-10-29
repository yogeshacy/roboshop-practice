#!/bin/bash

echo Setting NodeJS repo
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> /tmp/cart.
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo Installing NodeJS
yum install nodejs -y &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo adding application user
useradd roboshop &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo Downloading app content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>> /tmp/cart.log
cd /home/roboshop &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo Cleaning old app content
rm -rf cart &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo Extracting App archive
unzip -o /tmp/cart.zip &>> /tmp/cart.log
mv cart-main cart &>> /tmp/cart.log
cd cart &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo Installing NodeJS  Dependencies
npm install &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo Config the systemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>> /tmp/cart.log
systemctl daemon-reload &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

echo Startng Cart servcie
systemctl start cart &>> /tmp/cart.log
systemctl enable cart &>> /tmp/cart.log
if [ $? -eq 0 ]; then
  echo -e "\e[32mSuccess\e[0m"
else
  echo -e "\r[31mFailed\e[0m"
fi

