#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-13

#日志文件名
d=$(date +%Y%m%d%H%M)
basedir=/data/web/attachment

#查找5分钟内更改的文件,写入文件
find $basedir/ -type -f -mmin -5 > /tmp/newf.txt

#如果文件不为空，则更改文件名
if [ -s /tmp/newf.txt ];
then
    /bin/mv /tmp/newf.txt /tmp/$d
fi