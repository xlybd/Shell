#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-20

#进入日志路径
cd /date || exit 1
#删除最旧的日志
if [ -f 1.log.5 ]
then
    rm -f 1.log.5
fi
#倒叙遍历
for i in $(seq 5 -1 2)
do
    #日志存在后缀加1
    if [ -f 1.log.$[$i-1] ]
    then
        mv 1.log.$[$i-1] 1.log.$i
    fi
done

mv 1.log 1.log.1

touch 1.log

