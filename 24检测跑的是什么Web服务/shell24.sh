#!/bin/bash
#author: xili
#version: v1
#date: 2023-10-10

#定义检测web服务是什么函数
what_web()
{
    case $1 in
        httpd)
            echo "web服务为httpd."
            ;;
        nginx)
            echo "web服务为nginx."
            ;;
        *)
            echo "web服务为其他."
            ;;
    esac
}

#检查是否监听80端口
port_n=$(ss -lntp | grep ':80 ' | wc -l)
if [ ${port_n} -eq 0 ]
then
    echo "没有开启web服务"
    exit;
fi

#将监听80端口的进程去重写入临时文件
ss -lntp |grep ':80 ' |awk -F '"' '{print $2}' |sort |uniq > /tmp/web.txt

line=$(wc -l /tmp/web.txt |awk '{print $1}')

#遍历所有进程
if [ $line -gt 1 ]
then
    for web in $(cat /tmp/web.txt)
    do
        what_web $web
    done
else
    web=$(cat /tmp/web.txt)
    what_web $web
fi

rm -f /tmp/web.txt