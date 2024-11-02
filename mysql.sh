#!/bin/bash

source ./common.sh

check_root();

dnf install mysql-server -y &>>$logfile
VALIDATE $? "mysql-server"

systemctl enable mysqld &>>$logfile
VALIDATE $? "enabling mysql-server"

systemctl start mysqld &>>$logfile
VALIDATE $? "staring mysql-server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logfile
# VALIDATE $? "setting up root password for mysql-server"

mysql -h db.daws79s.online -uroot -p${my_sql_password} -e 'SHOW DATABASES;'
if [ $? -ne 0 ]
then
    echo -e "$Y *** installing My Sql *** $N"
    mysql_secure_installation --set-root-pass ${my_sql_password} &>>$logfile
    VALIDATE $? "setting up root password for mysql-server"
else
    echo -e "$G My Sql root password already setup $Y *** Skipping *** $N"
fi