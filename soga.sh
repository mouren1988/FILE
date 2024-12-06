#!/bin/bash
cp -f /usr/local/soga/soga@.service  /etc/systemd/system/

if [ ! "`grep -w auto_out_ip /usr/local/soga/soga.conf`" ];then 
	echo "auto_out_ip=true" >> /usr/local/soga/soga.conf
fi
if [ ! "`grep -w listen= /usr/local/soga/soga.conf`" ];then 
	echo "listen=" >> /usr/local/soga/soga.conf
fi

if [[ "$1" =~ "conf="* ]];then
	for i in $*
	do
		#如果配置是 conf... 复制配置
		if [[ "$i" =~ "conf="* ]];then
			conf=`echo $i|awk -F '=' '{print $2}'`
			cp  /usr/local/soga/soga.conf  /etc/soga/$conf.conf
		#如果不是，正常替换配置
		else
			A=`echo $i|awk -F '=' '{print $1}'`
			sed -i "s|$A.*|$i|g" /etc/soga/$conf.conf
		fi
	done
	systemctl start soga@$conf
	systemctl enable soga@$conf
	echo '部署完毕，等待5秒将显示服务状态'
	sleep 5
	systemctl status soga@$conf
else echo "参数有误"
fi
