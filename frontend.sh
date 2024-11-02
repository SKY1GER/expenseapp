#!/bin/bash


source ./common.sh

check_root

dnf install nginx -y 
validate $? "installing nginx"

systemctl enable nginx
validate $? "enabling nginx"

systemctl start nginx
validate $? "starting nginx server"

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
validate $? "Download the frontend content"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip
validate $? "Extract the frontend content"

cp /home/ec2-user/expense-shell/expense.conf  /etc/nginx/default.d/expense.conf &>>$logfile

systemctl restart nginx
validate $? "restaring the nginx"