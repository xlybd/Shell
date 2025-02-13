#!/bin/bash
#author: xili
#version: v1
#date: 2023-10-07

#设定语言为英语
LANG=en

#检查sar命令是否存在，不存在则安装
if ! which sar &>/dev/null
then
    echo "没有sar命令, 是用yum安装"
    #安装sysstat包来安装sar命令
    yum install -y sysstat &>/dev/null || (echo "sar命令无法安装";exit 1)
fi

#将网卡1分钟的流量数据写入临时文件/tmp/ens33.log
sar -n DEV 1 60 | grep ens33 > /tmp/ens33.log

#n1为网卡接收数据量
#n2为网卡发送数据量

n1=$(grep -i average /tmp/ens33.log |awk '{print $5}' |sed 's/\.//g')
n2=$(grep -i average /tmp/ens33.log |awk '{print $6}' |sed 's/\.//g')

#删除临时文件
rm -f /tmp/ens33.log

#当接受与发送数据量均为0时，说明网卡存在问题，需重启网卡
if [ $n1 == "000" ] && [ $n2 == "000" ]
then
    echo "网卡ens33存在问题, 需要重启"
    ifdown ens33 && ifup ens33
fi