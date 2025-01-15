#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
check_root(){
if [ $? -ne 0 ];then
    echo -e "$R You must have the sudo access to execute this $N"
    exit 1
fi
}

check_root

validate(){
    if [ $1 -ne 0 ];then
        echo -e "$2 $R --- installing failure $N"
        exit 1
    else 
        echo -e "$2 $G --- installing successful $N"
    fi
}

dnf install mysql-server -y
validate $? "installing mysql"

systemctl enbale mysqld 
validate $? "Enabling mysql server"

systemctl start mysqld
validate $? "starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1
validate $? "set the root password"



