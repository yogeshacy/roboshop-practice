#!/bin/bash

StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo -e "\e[31mFailed\e[0m"
    exit 1
  fi
}

DOWNLOAD() {
  echo Downloading ${COMPONENT} app content
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> /tmp/${COMPONENT}.log
  StatusCheck

}

NODEJS() {
  echo Setting NodeJS repo
  curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> /tmp/${COMPONENT}.log
  StatusCheck

  echo Installing NodeJS
  yum install nodejs -y &>> /tmp/${COMPONENT}.log
  StatusCheck

  id roboshop &>> /tmp/${COMPONENT}.log
  if [ $? -ne 0 ]; then
    echo adding application user
    useradd roboshop &>> /tmp/${COMPONENT}.log
    StatusCheck
  fi

  DOWNLOAD

  echo Cleaning old app content
   cd /home/roboshop &>> /tmp/${COMPONENT}.log && rm -rf ${COMPONENT} &>> /tmp/${COMPONENT}.log
  StatusCheck
  
  echo Extracting App archive
  unzip -o /tmp/${COMPONENT}.zip &>> /tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} &>> /tmp/${COMPONENT}.log && cd ${COMPONENT} &>> /tmp/${COMPONENT}.log
  StatusCheck
  
  echo Installing NodeJS  Dependencies
  npm install &>> /tmp/${COMPONENT}.log
  StatusCheck
  
  echo Config the systemD service
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> /tmp/${COMPONENT}.log && systemctl daemon-reload &>> /tmp/${COMPONENT}.log
  StatusCheck
  
  echo Startng ${COMPONENT} servcie
  systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log && systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
  StatusCheck
}

USER_ID=&(id -u)
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m You should run this script root or sudo user\e[0m"
  exit 1
fi

LOG=/tmp/${COMPONENT}.log
rm -rf ${LOG}