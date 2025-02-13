#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-25

#判断pgrep和ss命令是否存在
check_tools()
{
    if ! which pgrep &>/dev/null
    then
        echo "本机没有pgrep命令"
        exit 1
    fi

    if ! which ss &>/dev/null
    then
        echo "本机没有ss命令"
        exit 1
    fi
}

#使用pgrep检测某服务进程是否存在
#返回值0存在，1为不存在
check_ps()
{
    if pgrep "$1" &>/dev/null
    then
        return 0
    else
        return 1
    fi
}

#使用ss -lnp来检测端口是否存在
check_port()
{
    port_n=$(ss -lnp | grep ":$1 " | wc -l)
    if [ $port_n -ne 0 ]
    then
        return 0
    else
        return 1
    fi
}

check_srv()
{
    if check_ps $1 && check_port $2
    then
        echo "$1服务正常"
    else
        echo "$1服务不正常"
    fi
}

check_tools
check_srv nginx 443
check_srv mysql 3006
check_srv redis 6379
check_srv java 8825


