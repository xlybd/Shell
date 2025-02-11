#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-19

#创建生成随机数函数
create_number()
{
    while true :
    do
        #使用RANDOM生成随机数
        nu=$[$RANDOM%99+1]

        n=$(awk -F ':' -v NUMBER=$nu '$2 == NUMBER' /tmp/name.log | wc -l)
        if [ $n -gt 0 ]
        then
            continue
        else
            echo $nu
            break
        fi
    done
}

while true :
do
    read -p "Please input a name:(输出exit退出)" name

    if [ $name == exit ]
    then
        exit 1
    else
        if [ ! -f /tmp/name.log ]
        then
            #脚本第一次执行直接打印
            number=$[$RANDOM%99+1]
            echo "Your number is: $number"
            echo "$name:$number" > /tmp/name.log
        else
            n=$(awk -F ':' -v NAME=$name '$1 == NAME' /tmp/name.log | wc -l)
            if [ $n -gt 0 ]
            then
                echo "The name already exist."
                awk -F ':' -v NAME=$name '$1 == NAME' /tmp/name.log
                continue
            else
                number=$(create_number)
            fi
            echo "Your number is: $number"
            echo "$name:$number" >> /tmp/name.log
    fi
    fi
done
