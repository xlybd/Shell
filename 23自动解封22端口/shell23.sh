#!/bin/bash
#author: xili
#version: v1
#date: 2023-10-09

#对iptables规则中，针对22端口进行DROP或REJECT的规则记录到/tmp/drop.txt文件里
/usr/sbin/iptables -nvL --line-number | awk '$12 == "dpt:22" && $4 ~ /REJECT|DROP/ {print $1}' > /tmp/drop.txt

#如果/tmp/drop.txt不为空，则说明22端口已被封禁
if [ -s /tmp/drop.txt ]
then
    for id in $(tac /tmp/drop.txt)
    do
        /usr/sbin/iptables -D INPUT $id
    done
fi

rm -f /tmp/drop.txt