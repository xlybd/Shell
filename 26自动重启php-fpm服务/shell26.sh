#!/bin/bash
#author: xili
#version: v1
#date: 2023-10-12

#日志文件
logfile="/data/logs/www_access.log"

#上一分钟，关键词
last_t=$(date -d "-1 min" +%Y:%H:%M)

#过滤前一分钟日志并从后面截取1万行日志
tail -n 10000 $logfile | grep "/${last_t}:" > /tmp/last.log

#计算上一分钟日志有多少行
last_1min_c=$(wc -l /tmp/last.log | awk '{print $1}')

#计算502日志有多少行
s502_c=$(grep -c '" 502 "' /tmp/last.log)

#计算百分比
p=$(echo "scale=2; ${s502_c}*100/${last_1min_c}" | bc | sed 's/\.//')

if [ $p -gt 2000 ]
then
    echo "$(date) 502日志大于20%，需要重启php-fpm服务" >> /tmp/restart_php-fpm.log
    systemctl restart php-fpm
fi

rm -f /tmp/last.log