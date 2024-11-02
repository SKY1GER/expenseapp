#!/bin/bash


source ./common.sh

check_root

dnf install nginx -y 
VALIDATE $? "installing nginx"

systemctl enable nginx
VALIDATE $? "enabling nginx"

systemctl start nginx
VALIDATE $? "starting nginx server"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "Download the frontend content"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip
VALIDATE $? "Extract the frontend content"

cp /home/ec2-user/expense-shell/expense.conf  /etc/nginx/default.d/expense.conf &>>$logfile

systemctl restart nginx
VALIDATE $? "restaring the nginx"