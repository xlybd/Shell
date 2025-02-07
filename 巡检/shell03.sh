#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-08

for mount_p in $(df | sed '1d' | grep -v 'tmpfs' | awk '{print $NF}');do
    touch $mount_p/testfile && rm -f $mount_p/testfile
    if [ $? -ne 0 ]
    then
        ehco "$mount_p 读写有问题"
    else
        echo "$mount_p 读写正常"
    fi
done