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
  curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> /tmp/cart.
  StatusCheck

  echo Installing NodeJS
  yum install nodejs -y &>> /tmp/cart.log
  StatusCheck

  id roboshop &>> /tmp/cart.log
  if [ $? -ne 0 ]; then
    echo adding application user
    useradd roboshop &>> /tmp/cart.log
    StatusCheck
  fi
}