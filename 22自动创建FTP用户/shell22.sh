#!/bin/bash
#author: xili
#version: v1
#date:adsf 2023-10-08

ftpudir="/etc/vsftpd/ftpuser"

#提示没有参数
if [ -z "$1" ]
then
    echo "ERROR, 请带上用户名字, 例如sh $0 username" >&2
    exit 1
fi

#如果配置文件已存在，则用户已存在，同样报错
if [ -f $ftpudir/$1 ]
then
    echo "ERROR, 用户名已存在, 请重新定义用户" >&2
    exit 1
fi

#项目名与用户名一致
pro=$1

if ! which mkpasswd &>/dev/null
then
    echo "mkpasswd命令不存在需要安装"
    yum install -y expect &>/dev/null && echo "mkpasswd安装成功" || { echo "mkpasswd安装失败"; exit 1; }
fi
ftp_p=$(mkpasswd -s 0 -l 12)

cd $ftpudir || exit 1
cp aaa $pro || exit 1
sed -i "s/aaa/$pro/" $pro
systemctl restart vsftpd || exit 1

echo "新用户创建完成, 密码为$ftp_p"

echo -e "$pro\n$ftp_p" >> /etc/login.txt
db_load -T -t hash -f /etc/login.txt /etc/vsftpd/vsftpd_login.db