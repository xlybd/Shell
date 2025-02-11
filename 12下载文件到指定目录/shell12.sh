#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-18

#创建目录
while true :
do
    if [ -d $2 ]
    then
        break
    else
        #目录不存在，询问是否创建
        read -p "目录不存在是否创建，（y/n）" yn
        case $yn in
            y|Y)
                mkdir -p $2
                break;;
            n|N)
                exit 2;;
            *)
                echo "只能输入y或n"
                continue
                ;;
        esac
    fi
done

cd $2

wget $1

if [ $? -eq 0 ]
then
    echo "下载成功"
    exit 0
else
    echo "下载失败"
    exit 1
fi