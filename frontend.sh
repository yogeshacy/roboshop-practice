#!/bin/bash

#Front end setup
source common.sh

COMPONENT=frontend

echo Installing  Nginx
yum install nginx -y &>>&{LOG}
StatusCheck

DOWNLOAD

echo cleaning old content
cd /usr/share/nginx/html && rm -rf * &>>&{LOG}
StatusCheck

echo Extract Downloaded Coneten
unzip -o /tmp/frontend.zip &>>&{LOG} && mv frontend-main/static/* . && mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
StatusCheck

echo start Nginx service
systemctl restart nginx &>>&{LOG} && systemctl enable nginx &>>&{LOG}
StatusCheck

