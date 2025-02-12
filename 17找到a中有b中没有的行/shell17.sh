#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-23

#检查c.txt文件
[ -f c.txt ] && rm -f c.txt

#遍历a.txt文件
cat a.txt | while read line
do
    if ! grep -q "^${line}$" b.txt
    then
        echo ${line} >>c.txt
    fi
done
#计算行数
wc -l c.txt