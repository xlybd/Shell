#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-22

#生成三位随机数函数
get_number()
{
    random_number=$((RANDOM%900+100))
    echo "随机数为：$random_number"
}
#判断参数是否为1个
if [ $# -gt 1 ]
then
    echo "The number of your parameters can only be 1."
    echo "example: bash $0 5"
    exit
fi
#判断参数是否为数字
if [ $# -eq 1 ]
then
    m=$(echo $1 | sed 's/[0-9]//g')
    if [ -n "$m" ]
    then
        echo "Usage bash $0 n, n is a number, example: bash $0 5"
        exit
    else
        echo "The numbers are:"
        for i in $(seq $1)
        do
            get_number
        done
    fi
else
    get_number
fi