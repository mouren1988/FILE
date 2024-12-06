#!/bin/bash

#设置字体颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

#删除相关项
  cd
  rm -rf "$(pwd)"/gost
  rm -rf "$(pwd)"/gost.service
  rm -rf "$(pwd)"/gost.json
  rm -rf "$(pwd)"/config.json
  rm -rf /usr/bin/gost  
  rm -rf /etc/systemd/system/gost.service  
  rm -rf /etc/gost
  rm -rf /usr/lib/systemd/system/gost.service
  
#开启bbr
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

#更新apt
apt update -y

#apt安装
apt-get install sudo wget curl vim iptables -y

#自定义变量
IP=$(curl ipv4.ip.sb)

#下载gost
wget --no-check-certificate https://github.com/ginuerzh/gost/releases/download/v2.11.4/gost-linux-amd64-2.11.4.gz

#解压gost
gunzip -f gost-linux-amd64-2.11.4.gz

#重命名为gost
mv gost-linux-amd64-2.11.4 gost

#移动gost到系统变量
mv gost /usr/bin

#设置文件权限
chmod 777 /usr/bin/gost

#下载service到/etc/systemd/system
wget -P /etc/systemd/system --no-check-certificate https://raw.githubusercontent.com/mouren1988/FILE/main/gost.service

#设置文件权限
chmod 777 /etc/systemd/system/gost.service

#下载配置文件到root
wget -P /root --no-check-certificate https://raw.githubusercontent.com/mouren1988/FILE/main/gost.json

#设置文件权限
chmod 777 /root/gost.json

#设置开机自启
systemctl enable gost 

#启动服务
systemctl restart gost 

echo -e "${green}gost v2.11.4 安装完成，已设置开机自启${plain}"
echo ""
echo -e "${green}gost 重启成功${plain}"
echo ""
echo "soga 管理脚本使用方法: "
echo "------------------------------------------"
echo "systemctl start gost         - 启动 gost"
echo "systemctl stop gost          - 停止 gost"
echo "systemctl restart gost       - 重启 gost"
echo "systemctl status gost        - 查看 gost 状态"
echo "systemctl enable gost        - 设置 gost 开机自启"
echo "systemctl disable gost       - 取消 gost 开机自启"
echo "--------------------------------------------------"

echo ""
echo ""
echo -e "${green}Socks5${plain}"
echo -e "${green}IP: $IP${plain}"
echo -e "${green}端口：6666${plain}"
echo -e "${green}账户：mouren${plain}"
echo -e "${green}密码：mouren${plain}"
echo ""
