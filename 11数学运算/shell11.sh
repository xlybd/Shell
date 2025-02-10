#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-17

#判断参数是否为两个
if [ $# -ne 2 ]
then
    echo "The number of parameter is not 2, Please useage: ./$0 1 2"
    exit 1
fi

is_int()
{
    if echo "$1" | grep -q '[^0-9]'
    then
    echo "$1 is not integer number."
    exit 1 
    fi
}
#加法
sum()
{
    echo "$1 + $2 = $[$1+$2]"
}
#减法
minus()
{
    echo "$1 - $2 = $[$1+$2]"
}
#乘法
mult()
{
    echo "$1 * $2 = $[$1+$2]"
}
#除法
div()
{
    d=$(echo "scale =2;$1/$2" | bc | xargs printf "%0.2f\n")
    echo "$1 / $2 = $d"
}
is_int $1
is_int $2
sum $1 $2
minus $1 $2
mult $1 $2
div $1 $2


