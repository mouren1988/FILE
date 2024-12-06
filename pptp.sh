#!/bin/sh
#设置字体颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
IP=$(curl ipv4.ip.sb)

if [ `id -u` -ne 0 ] 
then
  echo "please run it by root"
  exit 0
fi

apt-get -y update

apt-get -y install pptpd || {
  echo "could not install pptpd" 
  exit 1
}

cat >/etc/ppp/options.pptpd <<END
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
lock
nobsdcomp 
novj
novjccomp
nologfd
END

cat >/etc/pptpd.conf <<END
option /etc/ppp/options.pptpd
logwtmp
localip 192.168.2.1
remoteip 192.168.2.10-100
END

cat >> /etc/sysctl.conf <<END
net.ipv4.ip_forward=1
END

sysctl -p

iptables-save > /etc/iptables.down.rules

iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o eth0 -j MASQUERADE

iptables -I FORWARD -s 192.168.2.0/24 -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1300

iptables-save > /etc/iptables.up.rules

cat >>/etc/ppp/pptpd-options<<EOF
pre-up iptables-restore < /etc/iptables.up.rules
post-down iptables-restore < /etc/iptables.down.rules
EOF

cat >/etc/ppp/chap-secrets <<END
mouren pptpd mouren *
END

service pptpd restart

netstat -lntp

echo -e "${green}pptp 安装完成，已设置开机自启${plain}"
echo ""
echo -e "${green}pptp 重启成功${plain}"
echo ""
echo "pptp 管理脚本使用方法: "
echo "------------------------------------------"
echo "service pptpd start         - 启动 pptp"
echo "service pptpd stop          - 停止 pptp"
echo "service pptpd restart       - 重启 pptp"
echo "--------------------------------------------------"

echo ""
echo ""
echo -e "${green}pptp${plain}"
echo -e "${green}IP: $IP${plain}"
echo -e "${green}账户：mouren${plain}"
echo -e "${green}密码：mouren${plain}"
echo ""

exit 0
