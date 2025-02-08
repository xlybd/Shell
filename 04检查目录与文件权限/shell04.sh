#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-09

cd /root || exit 1

for f in $(find .);do
    #查看目录权限、所有者、属主
    f_p=$(stat -c %a $f)
    f_u=$(stat -c %U $f)
    f_g=$(stat -c %G $f)

    #判断是否为目录
    if [ -d $f ]
    then
        [ $f_p != '755' ] && chmod 755 $f
    else
        [ $f_p != '644' ] && chmod 644 $f
    fi

    [ $f_u != 'xili' ] && chown xili $f
    [ $f_g != 'root' ] && chown :root $f
done