#!/bin/bash
#author: xili
#version: v1
#date: 2023-10-15

mysql_url="https://downloads.mysql.com/archives/get/p/23/file/mysql-8.0.40-linux-glibc2.28-x86_64.tar.xz"
mysql_base_dir="/usr/local/mysql"
mysql_data_dir="/data/mysql"

mysql_root_pwd="xililinux.com"

ck_ok()
{
    if [ $? -ne 0 ]
    then
        echo "$1 error."
        exit 1
    fi
}


download_mysql()
{
    #判断当前目录是否已经下载过
    cd /usr/local || exit 1
    if [ -f mysql-8.0.40-linux-glibc2.28-x86_64.tar.xz ]
    then
        echo "当前目录已经存在mysql-8.0.40-linux-glibc2.28-x86_64.tar.xz"
    else
        sudo wget ${mysql_url}
        ck_ok "下载mysql"
    fi 
}

install_mysql()
{
    cd /usr/local || exit 1
    echo "解压mysql"
    sudo tar zxvf mysql-8.0.40-linux-glibc2.28-x86_64.tar.xz
    ck_ok "解压mysql"
    if [ -d ${mysql_base_dir} ]
    then
        echo "${mysql_base_dir}已经存在，备份"
        sudo /bin/mv ${mysql_base_dir} ${mysql_base_dir}-$(date +%s)
    fi
    sudo mv mysql-8.0.40-linux-glibc2.28-x86_64 mysql
    if id mysql &>/dev/null
    then
        echo "系统已存在mysql用户，跳过创建"
    else
        echo "创建mysql用户"
        sudo useradd -s /bin/nologin mysql
    fi

    if [ -d ${mysql_data_dir} ]
    then
        echo "${mysql_data_dir}已存在，备份"
        sudo /bin/mv ${mysql_data_dir} ${mysql_data_dir}-$(date +%s)
    fi
    echo "创建mysql datadir"
    sudo mkdir -p ${mysql_data_dir}
    sudo chown -R mysql ${mysql_data_dir}
    if [ -f ${mysql_base_dir}/my.cnf ]
    then
        echo "删除已存在的配置文件"
        sudo rm -f ${mysql_base_dir}/my.cnf
    fi
    echo "创建配置文件my.cnf"
    cat > /tmp/my.cnf <<EOF
[mysqld]
user = mysql
port = 3306
server_id = 1
basedir = ${mysql_base_dir}
datadir = ${mysql_data_dir}
socket = /tmp/mysql.sock
pid-file = ${mysql_data_dir}/mysqld.pid
log-error = ${mysql_data_dir}/mysql.err
EOF
    sudo /bin/mv /tmp/my.cnf ${mysql_base_dir}/my.cnf

    echo "安装依赖"
    sudo yum install -y ncurses-compat-libs libaio-devel

    echo "初始化"
    sudo ${mysql_base_dir}/bin/mysqld --console --datadir=${mysql_data_dir}  --initialize-insecure --user=mysql

    ck_ok "初始化"

    if [ -f /usr/lib/systemd/system/mysqld.service ]
    then
        echo "mysql服务管理脚本已存在，备份"
        sudo /bin/mv /usr/lib/systemd/system/mysqld.service /usr/lib/systemd/system/mysqld.service-`date +%s`
    fi

    echo "创建服务启动脚本"
    cat > /tmp/mysqld.service <<EOF
[Unit]
Description=MYSQL server
After=network.target
[Install]
WantedBy=multi-user.target
[Service]
Type=forking
TimeoutSec=0
PermissionsStartOnly=true
ExecStart=${mysql_base_dir}/bin/mysqld --defaults-file=${mysql_base_dir}/my.cnf --daemonize $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
ExecStop=/bin/kill =QUIT $MAINPID
KillMode=process
LimitNOFILE=65535
Restart=on-failure
RestartSec=10
RestartPreverntExitStatus=1
PrivateTmp=false
EOF
    sudo /bin/mv /tmp/mysqld.service /usr/lib/systemd/system/mysqld.service
    sudo systemctl unmask mysqld
    sudo systemctl enable mysqld
    echo "启动mysql"
    sudo systemctl start mysqld
    ck_ok "启动mysql"

    echo "设置mysql密码"
    ${mysql_base_dir}/bin/mysqladmin -S /tmp/mysql.sock -uroot password "${mysql_root_pwd}"

    ck_ok "设置MySQL密码"
}

main()
{
    download_mysql
    install_mysql
}

main