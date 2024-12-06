#!/bin/bash
#开启BBR
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
#下载证书到/etc
#wget --no-check-certificate https://raw.githubusercontent.com/mouren1988/FILE/main/cert.pem -O /etc/cert.pem
#wget --no-check-certificate https://raw.githubusercontent.com/mouren1988/FILE/main/key.pem -O /etc/key.pem
#安装XrayR
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
#下载配置文件config.yml到/etc/XrayR/config.yml
wget --no-check-certificate https://raw.githubusercontent.com/mouren1988/FILE/main/config.yml -O /etc/XrayR/config.yml
