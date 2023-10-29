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
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
  StatusCheck

}

APP_USER_SEUP() {
  id roboshop &>>${LOG}
    if [ $? -ne 0 ]; then
      echo adding application user
      useradd roboshop &>>${LOG}
      StatusCheck
    fi
}

APP_CLEAN() {
  echo Cleaning old app content
  cd /home/roboshop &>>${LOG} && rm -rf ${COMPONENT} &>>${LOG}
  StatusCheck

  echo Extracting App archive
  unzip -o /tmp/${COMPONENT}.zip &>>${LOG} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG} && cd ${COMPONENT} &>>${LOG}
  StatusCheck
}

SYSTEMD() {
  echo Config the systemD service
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG} && systemctl daemon-reload &>>${LOG}
    StatusCheck

    echo Startng ${COMPONENT} servcie
    systemctl start ${COMPONENT} &>>${LOG} && systemctl enable ${COMPONENT} &>>${LOG}
    StatusCheck
}

NODEJS() {
  echo Setting NodeJS repo
  curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>>${LOG}
  StatusCheck

  echo Installing NodeJS
  yum install nodejs -y &>>${LOG}
  StatusCheck

  APP_USER_SEUP

  DOWNLOAD

  APP_CLEAN

  echo Installing NodeJS  Dependencies
  npm install &>>${LOG}
  StatusCheck
  
  SYSTEMD
}

JAVA() {
  echo Install maven
  yum install maven -y &>>${LOG}
  StatusCheck

  APP_USER_SEUP
  DOWNLOAD
  APP_CLEAN

  echo Make app claenup
  mvn clean package &>>${LOG} && mv target/shipping-1.0.jar shipping.jar &>>${LOG}

  SYSTEMD
}

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31m You should run this script root or sudo user\e[0m"
  exit 1
fi

LOG=/tmp/${COMPONENT}.log
rm -rf ${LOG}