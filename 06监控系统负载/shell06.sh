#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-12

#查看/opt/logs目录是否存在，不在则创建
[ -d /opt/logs ] || mkdir -p /opt/logs

while true:
do
    #获取系统一分钟负载
    load=$(uptime | awk -F 'load average: ' '{print $2}' | cut -d',' -f1)
    if [ $load -gt 10 ]
    then
        #记录日志
        top -bn1 |head -n 100 > /opt/logs/top.$(date +$s)
        vmstat 1 10 > /opt/logs/vmstat.$(date +%s)
        ss -an > /opt/logs/ss.$(date +%s)
    fi
    #休眠20s
    sleep 20
    #删除30以上的日志
    find /opt/logs \(-name "top*" -o -name "vmstat*" -o -name "ss*" \) -mtime +30 | xargs rm -f
done