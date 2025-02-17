#!/bin/bash
#author: xili
#version: v1
#date: 2023-10-11

#Mysql_c="mysql -uroot -p123456"
Mysql_c="mysql -uroot -p123456 -h127.0.0.1 -P3307"

#登录MySQL并执行命令分别输出到不同的文件
$Mysql_c -e "show processlist" >/tmp/mysql_pro.log 2>/tmp/mysql_log.err

#删除已知告警信息
sed -i '/Using a password on the command line interface can be insecure/d' /tmp/mysql_log.err

#如果err日志不为空，则服务不正常
if [ -s /tmp/mysql_log.err ]
then
    echo "MySQL服务不正常，错误信息为："
    cat /tmp/mysql_log.err
    rm -f /tmp/mysql_pro.log /tmp/mysql_log.err
    exit 1
else
    #将show slave status的输出信息写入到临时文件
    $Mysql_c -e "show slave status\G" >/tmp/mysql_s.log 2>/dev/null

    #如果临时文件不为空，则认为是从，否则主
    if [ -s /tmp/mysql_s.log ]
    then
        #判断主从状态是否正常，看Slave_IO_Running和Slave_SQL_Running这两行值是否为Yes
        y1=$(grep 'Slave_IO_Running:' /tmp/mysql_s.log | awk -F : '{print $2}' | sed 's/ //g')

        y2=$(grep 'Slave_SQL_Running:' /tmp/mysql_s.log | awk -F : '{print $2}' | sed 's/ //g')

        #y1 y2都为Yes则正常
        if [ $y1 == 'Yes' ] && [ $y2 == 'Yes' ]
        then
            echo "从状态正常"
        else
            echo "从状态不正常"
        fi
    fi
fi