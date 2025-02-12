#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-24

#创建脚本使用帮助函数
useage()
{
    echo "Please useage: $0 -i 网卡名字 or $0 -I ip地址"
}

#检测参数数量
if [ $# -ne 2 ]
then
    useage
    exit
fi

#获取网卡名字，录入临时文件
ip addr | awk -F ":" '$1 ~ /^[1-9]/ {print $2}' | sed 's/ //g' > /tmp/eths.txt

#文件是否存在,如果存在将其删除
[ -f /tmp/eth_ip.log ] && rm -f /tmp/eth_ip.log

#遍历网卡
for eth in $(cat /tmp/eths.txt)
do
    ip=$(ip addr | grep -A2 ": $eth" | grep inet | awk '{print $2}' | cut -d '/' -f 1)
    echo "$eth:$ip" >> /tmp/eth_ip.log
done

#删除临时文件函数
del_tmp_file()
{
    [ -f /tmp/eths.txt ] && rm -f /tmp/eths.txt
    [ -f /tmp/eth_ip.log ] && rm -f /tmp/eth_ip.log
}

#名字错误报错
wrong_eth()
{
    if ! awk -F ':' '{print $1}' /tmp/eth_ip.log | grep -qw "^$1$"
    then
        echo "请指定正确的网卡名字"
        del_tmp_file
        exit
    fi
}

#IP错误报错
wrong_ip()
{
    if ! awk -F ':' '{print $2}' /tmp/eth_ip.log | grep -qw "^$1$"
    then
        echo "请指定正确的IP地址"
        del_tmp_file
        exit
    fi
}

#根据第一个参数决定执行对应指令
case $1 in
    -i)
    wrong_eth $2
    grep -w $2 /tmp/eth_ip.log | awk -F ':' '{print $2}'
    ;;
    -I)
    wrong_ip $2
    grep -w $2 /tmp/eth_ip.log |awk -F ':' '{print $1}'
    ;;
    *)
    useage
    del_tmp_file
    exit
    ;;
esac

del_tmp_file


