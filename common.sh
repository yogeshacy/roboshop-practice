#!/bin/bash

StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo -e "\e[31mFailed\e[0m"
    exit 1
  fi
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
  
  echo Downloading app content
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>> /tmp/${COMPONENT}.log
  cd /home/roboshop &>> /tmp/${COMPONENT}.log
  StatusCheck
  
  echo Cleaning old app content
  rm -rf ${COMPONENT} &>> /tmp/${COMPONENT}.log
  StatusCheck
  
  echo Extracting App archive
  unzip -o /tmp/${COMPONENT}.zip &>> /tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} &>> /tmp/${COMPONENT}.log && cd ${COMPONENT} &>> /tmp/${COMPONENT}.log
  StatusCheck
  
  echo Installing NodeJS  Dependencies
  npm install &>> /tmp/${COMPONENT}.log
  StatusCheck
}