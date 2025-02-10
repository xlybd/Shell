#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-16

#检查是否有curl命令
if ! which curl &>/dev/null
then
    echo "本机没有安装curl"
    #假设系统为CentOS/RHEL
    yum install -y curl
    if [ $? -ne 0 ]
    then
        echo "curl没有安装成功"
        exit 1
    fi
fi

code=$(curl --connect-timeout 3 -I $1 2>/dev/null | grep 'HTTP' | awk '{print $2}')

if echo $code | grep -qE '^2[0-9][0-9]|^3[0-9][0-9]'
then
    echo "$1访问正常"
else
    echo "$1访问不正常"
fi