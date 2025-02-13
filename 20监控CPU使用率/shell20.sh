#!/bin/bash
#author: xili
#version:v1
#date: 2023-09-28

while true :
do
    #获取CPU idle的值
    idle=$(top -bn1 |sed -n '3p' |awk -F 'ni,' '{print $2}' |cut -d "." -f1 |sed 's/ //g')
    use=$[100-$idle]
    if [ $use -gt 90 ]
    then
        echo "CPU use percent too high."
        #邮件发送省略
    fi
    sleep 10
done