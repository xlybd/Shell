#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-07

#判断文件是否存在
if [ -f /tmp/userinfo.txt ]
then
    rm -f /tmp/userinfo.txt
fi

#判断mkpasswd命令是否存在
if ! which mkpasswd
then
    yum install -y expect
fi

#用seq命令生成1到5个数的队列
for i in $(seq -w 1 5);do
    #生成15位随机字符串，使用三个特殊字符
    p=$(mkpasswd -l 15 -s 3)
    #添加用户设置密码，并保存到文件
    useradd "user_{i}" && echo "${p}" | passwd --stdin user_${i}
    echo "user_${i} ${p}" >> /tmp/userinfo.txt
done