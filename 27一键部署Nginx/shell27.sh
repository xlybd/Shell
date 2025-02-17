#!/bin/bash
#author: xili
#version: v1
#date: 2023-10-13

ck_ok()
{
    if [ $? -ne 0 ]
    then
        echo "$1 error."
        exit 1
    fi
}

download_ng()
{
    cd /usr/local/src || exit 1
    if [ -f nginx-1.24.0.tar.gz ]
    then
        echo "当前目录已存在nginx安装包"
    else
        sudo curl -O https://nginx.org/download/nginx-1.24.0.tar.gz
        ck_ok "下载Nginx"
    fi
}

install_ng()
{
    cd /usr/local/src || exit 1
    echo "解压Nginx"
    sudo tar zxvf nginx-1.24.0.tar.gz
    ck_ok "解压Nginx"
    cd nginx-1.24.0 || exit 1

    echo "安装依赖"
    if which yum >/dev/null 2>&1
    then
        #RHEL/Rocky
        for pkg in gcc make pcre-devel zlib-devel openssl-devel
        do
            if ! rpm -q $pkg >/dev/null 2>&1
            then
                sudo yum install -y $pkg
                ck_ok "yum 安装$pkg"
            else
                echo "$pkg已经安装"
            fi
        done
    fi

    if which apt >/dev/null 2>&1
    then
        #Ubuntu/Debian 
        for pkg in make libpcre++-dev libssl-dev zlib1g-dev
        do
            if ! dpkg -l $pkg >/dev/null 2>&1
            then
                sudo apt install -y $pkg
                ck_ok "apt 安装$pkg"
            else
                echo "$pkg已经安装"
            fi
        done
    fi

    echo "configure Nginx"
    sudo ./configure --prefix=/usr/local/nginx --with-http_ssl_module
    ck_ok "Configure Nginx"

    echo "编译与安装"
    sudo make && sudo make install
    ck_ok "编译与安装"

    echo "编辑systemd服务管理脚本"

    cat > /tmp/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/sh -c "/bin/kill -s HUP \$(/bin/cat /usr/local/nginx/logs/nginx.pid)"
ExecStop=/bin/sh -c "/bin/kill -s TERM \$(/bin/cat /usr/local/nginx/logs/nginx.pid)"

[Install]
WantedBy=multi-user.target
EOF

    sudo /bin/mv /tmp/nginx.service /lib/systemd/system/nginx.service
    ck_ok "编辑nginx.service"

    echo "加载服务"
    sudo systemctl unmask nginx.service
    sudo systemctl daemon-reload
    sudo systemctl enable nginx
    echo "启动Nginx"
    sudo systemctl start nginx
    ck_ok "启动Nginx"

}

download_ng
install_ng