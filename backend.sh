#!/bin/bash

USERID=$(id -u)

check_root(){

if [ $? -ne 0 ];then
    echo "You must have the sudo access to execute this"
    exit 1
fi

}

check_root

validate (){
    if [ $1 -ne 0 ];then
        echo "$2 installing failure"
        exit 1
    else 
        echo "$2 installing Success"
    fi
}

dnf module disable nodejs 
validate $? "disbaled nodejs"

dnf module enable nodejs:20 -y
validate $? "enables nodejs 20"

dnf install nodejs -y
validate $? "installing nodejs"

id Expense
if [ $? -ne 0 ];then
    useradd Expense
    validate $? "creating user"
else
    echo "user already exits"
fi


mkdir -p /app

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
validate $? "downloading code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip
validate $? "unzip the backend"

npm install
validate $? "installing dependencies"

cp /home/ec2-user/shell_expense/backend.service /etc/systemd/system/backend.service

dnf install mysql -y
validate $? "installing mysql"

mysql -h mysql.myfooddy.fun -u root -pExpenseApp@1 < /home/ec2-user/shell_expense/schema/backend.sql
validate $? "setting up the transaction schema and tables"

systemctl daemon-reload
validate $? "Daemon reload"

systemctl enable backend
validate $? "enabling backend"

systemctl restart backend
validate $? "restarting backend"

