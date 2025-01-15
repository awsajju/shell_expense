#!/bin/bash

USERID=$(id -u)

check_root(){
    if [ $? -ne 0 ];then
        echo "You must have the sudo access to execute this"
        exit 1
    fi
}

check_root

validate(){
    if [ $1 -ne 0 ]; then
        echo "$2 installing is failure"
        exit 1
    else
        echo "$2 installing is success"
    fi
}
 
dnf install nginx -y
validate $? "installing nginx"

systemctl enable nginx
validate $? "enabled nginx"

systemctl start nginx
validate $? "started nginx"

rm -rf /usr/share/nginx/html/*
validate $? "removed all the files under html"



curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
validate $? "downloading code"



cd /usr/share/nginx/html
validate $? "changing the directory"

unzip /tmp/frontend.zip
validate $? "unziping the code"

cp /home/ec2-user/shell_expense/frontend.conf /etc/nginx/default.d/frontend.conf

systemctl restart nginx
validate $? "restarted nginx"