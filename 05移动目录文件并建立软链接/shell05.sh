#!/bin/bash
#author: xili
#version: v1
#date: 2023-09-11

main()
{
    cd /data/att || exit 1
    #遍历一层目录
    for dir in *;
    do
        #遍历二层，find近一年的子目录
        for dir2 in $(find $dir -maxdepth 1 -type d -mtime +365);
        do
            #文件同步
            rsync -aR "$dir2"/ /data1/att/
            if [ $? -eq 0 ]
            then
                rm -rf "$dir2"
                echo "/data/att/$dir2 移动成功"
                #做软链接
                ln -s /data1/att/"$dir2" /data/att/"$dir2" && echo "/data/att/$dir2成功创建软连接"
                echo
            else
                echo "/data/att/$dir 未移动成功"
            fi
        done
    done
}
#输出日志
main &> /tmp/move_old_data_"$(date +%F)".log