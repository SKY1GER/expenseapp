#!/bin/bash



source ./common.sh

check_root

echo "please enter mysql password"
read -s my_sql_password

dnf module disable nodejs -y &>>$logfile
VALIDATE $? "$G sccessfully disabled $N"

dnf module enable nodejs:20 -y &>>$logfile
VALIDATE $? "$G enabled nodejs:20 $N"

dnf install nodejs -y &>>$logfile
VALIDATE $? "$G installed nodejs:20 $N"

id expense &>>$logfile
if [ $? -ne 0 ]
then
    useradd expense &>>$logfile
    VALIDATE $? "$G user expense added $N"
else
    echo -e "$G ***userexpense already present*** $Y ***Skipping*** $N"
fi

mkdir -p /app &>>$logfile

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$logfile
VALIDATE $? "$Y ***downling backend code*** $N"


cd /app &>>$logfile
rm -rf /app/*
unzip /tmp/backend.zip &>>$logfile
VALIDATE $? "$Y ***unzipping backend file*** $N"

cd /app &>>$logfile
npm install &>>$logfile
VALIDATE $? "$G ***installing npm*** $N"

cp /home/ec2-user/expense-shell/backend.service  /etc/systemd/system/backend.service &>>$logfile
VALIDATE $? "copied backend service"

systemctl daemon-reload &>>$logfile
VALIDATE $? "daemon-reload"

systemctl start backend &>>$logfile
VALIDATE $? "start backend"

systemctl enable backend &>>$logfile
VALIDATE $? "enable backend"


dnf install mysql-server -y &>>$logfile
VALIDATE $? "mysql-server"

mysql -h db.daws79s.online -uroot -p${my_sql_password} < /app/schema/backend.sql &>>$logfile
VALIDATE $? "loading schema"
#sudo cat /app/schema/backend.sql

systemctl restart backend &>>$logfile
VALIDATE $? "restating backend"

#systemctl status backend