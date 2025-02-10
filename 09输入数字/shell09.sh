#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-15

while true:
do
    read -p "Please input a number:(Input "end" to quit) " n
    #wc -c空输出标记1个字符
    num=$(echo $n | sed -r 's/[0-9]//g' | wc -c)
    if [ $n == 'end' ]
    then
        exit
    fi
    if [ $num -ne 1 ]
    then
        echo "not a number, try again!"
    else
        echo "The number you entered is : $n"
    fi
done 