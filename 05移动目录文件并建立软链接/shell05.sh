#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-11

main()
{
    cd /data/att || exit 1

    for dir in *;
    do
        for dir2 in $(find $dir -maxdepth 1 -type d -mtime +365);
        do
            rsync -aR "$dir2"/ /data1/att/
            if [ $? -eq 0 ]
            then
                rm -rf "$dir2"
                echo "/data/att/$dir2 移动成功"

                ln -s /data1/att/"$dir2" /data/att/"$dir2" && echo "/data/att/$dir2成功创建软连接"
                echo
            else
                echo "/data/att/$dir 未移动成功"
            fi
        done
    done
}