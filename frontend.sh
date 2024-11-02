#!/bin/bash

userid=$(id -u)
scriptname=$(echo $0 | cut -d "." -f1)
timestamp=$(date +%F-%H-%M-%S)
logfile=$scriptname-$timestamp.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
echo "please enter the password"
read -s password

if [ $userid -ne 0 ]
then
    echo -e "$R ***Please run the script in super user*** $N"
else
    echo -e "$G ***You are a super user*** $N"
fi   

validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R *****$2 Installation Failure****$N"
        exit 1
    else
        echo -e "$G *****$2 Installation Success*****$N"
    fi
}

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