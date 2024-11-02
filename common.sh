# Hello World Program in Bash Shell

#!/bin/bash
userid=$(id -u)
script_name=$(echo $0 | cut -d "." -f1)
time_stamp=$(date +%F-%H-%M-%S)
logfile=/tmp/$script_name-$time_stamp.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2  ***installation Failure*** $N"
        exit 1
    else
        echo -e "$G $2  ***installation Success*** $N"
    fi
}

check_root(){
if [ $userid -ne 0 ]
then
    echo "please run in super user"
    exit 1
else
    echo "you are already a super user"
fi
}