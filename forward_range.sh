#!/bin/bash

# 允许内核转发
echo 1 > /proc/sys/net/ipv4/ip_forward

# 获取本地机器的内网IP地址
local_ip=$(hostname -I | awk '{print $1}')
if [[ -z "$local_ip" ]]; then
    echo -e "\033[31m错误：未能获取到本地内网 IP 地址！\033[0m"
    exit 1
fi

# 设置目标主机 IP 和端口范围
target_ip="152.67.206.12"
min_port="50000"
max_port="60000"

# 验证 IP 地址格式
validate_ip() {
    local ip=$1
    local valid_ip_pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if [[ ! $ip =~ $valid_ip_pattern ]]; then
        echo -e "\033[31m错误：IP 地址 '$ip' 格式不正确！\033[0m"
        exit 1
    fi
    # 验证每一段 IP 是否在 0-255 范围内
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
        if ((octet < 0 || octet > 255)); then
            echo -e "\033[31m错误：IP 地址 '$ip' 的某段不在 0 到 255 范围内！\033[0m"
            exit 1
        fi
    done
}

# 验证端口范围
validate_ports() {
    local min=$1
    local max=$2
    if ! [[ "$min" =~ ^[0-9]+$ ]] || ! [[ "$max" =~ ^[0-9]+$ ]]; then
        echo -e "\033[31m错误：端口范围必须为数字！\033[0m"
        exit 1
    fi
    if ((min < 1 || min > 65535)); then
        echo -e "\033[31m错误：最小端口 '$min' 必须在 1 到 65535 之间！\033[0m"
        exit 1
    fi
    if ((max < 1 || max > 65535)); then
        echo -e "\033[31m错误：最大端口 '$max' 必须在 1 到 65535 之间！\033[0m"
        exit 1
    fi
    if ((min > max)); then
        echo -e "\033[31m错误：最小端口 '$min' 不能大于最大端口 '$max'！\033[0m"
        exit 1
    fi
}

# 检查现有规则是否与当前规则相同
check_existing_rules() {
    # 获取当前 iptables -t nat 表中的所有规则
    existing_rules=$(iptables -t nat -S)

    # 检查是否已经存在相同的规则
    if [[ "$existing_rules" == *"PREROUTING"* && "$existing_rules" == *"--dport $min_port:$max_port"* && "$existing_rules" == *"--to-destination $target_ip:$min_port-$max_port"* && "$existing_rules" == *"POSTROUTING"* && "$existing_rules" == *"--to-source $local_ip"* ]]; then
        echo -e "\033[37m端口范围 $min_port 到 $max_port 转发已存在, 跳过\033[0m"
        return 0
    fi
    return 1
}

# 检查现有规则并跳过
if check_existing_rules; then
    exit 0
fi

# 删除旧的规则
delete_old_rules() {
    iptables -t nat -C PREROUTING -p tcp --dport $min_port:$max_port -j DNAT --to-destination $target_ip:$min_port-$max_port 2>/dev/null && iptables -t nat -D PREROUTING -p tcp --dport $min_port:$max_port -j DNAT --to-destination $target_ip:$min_port-$max_port
    iptables -t nat -C PREROUTING -p udp --dport $min_port:$max_port -j DNAT --to-destination $target_ip:$min_port-$max_port 2>/dev/null && iptables -t nat -D PREROUTING -p udp --dport $min_port:$max_port -j DNAT --to-destination $target_ip:$min_port-$max_port

    iptables -t nat -C POSTROUTING -p tcp -d $target_ip --dport $min_port:$max_port -j SNAT --to-source $local_ip 2>/dev/null && iptables -t nat -D POSTROUTING -p tcp -d $target_ip --dport $min_port:$max_port -j SNAT --to-source $local_ip
    iptables -t nat -C POSTROUTING -p udp -d $target_ip --dport $min_port:$max_port -j SNAT --to-source $local_ip 2>/dev/null && iptables -t nat -D POSTROUTING -p udp -d $target_ip --dport $min_port:$max_port -j SNAT --to-source $local_ip
}

# 调用 IP 和端口验证函数
validate_ip "$local_ip"
validate_ip "$target_ip"
validate_ports "$min_port" "$max_port"

# 删除旧的规则
delete_old_rules

# 端口转发规则：将本地端口范围转发到目标主机
iptables -t nat -A PREROUTING -p tcp --dport $min_port:$max_port -j DNAT --to-destination $target_ip:$min_port-$max_port
iptables -t nat -A PREROUTING -p udp --dport $min_port:$max_port -j DNAT --to-destination $target_ip:$min_port-$max_port

# 修改返回流量的源地址为本地IP
iptables -t nat -A POSTROUTING -p tcp -d $target_ip --dport $min_port:$max_port -j SNAT --to-source $local_ip
iptables -t nat -A POSTROUTING -p udp -d $target_ip --dport $min_port:$max_port -j SNAT --to-source $local_ip

echo -e "\033[32m端口范围 $min_port 到 $max_port 转发已更新\033[0m"


# 以下是原代码
# echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
# sysctl -p
# echo '
#!/bin/bash
# myip=172.31.6.129
# wlip=172.31.55.137
# 1000以上端口转发
# iptables -t nat -A PREROUTING -p tcp --dport 1000:65535 -j DNAT --to-destination $wlip:1000-65535
# iptables -t nat -A POSTROUTING -p tcp -d $wlip --dport 1000:65535 -j SNAT --to-source $myip

#23转发WL的22端口
# iptables -t nat -A PREROUTING -p tcp --dport 23 -j DNAT --to-destination $wlip:22
# iptables -t nat -A POSTROUTING -p tcp -d $wlip --dport 22 -j SNAT --to-source $myip
# '>>/etc/rc.local
# chmod +x /etc/rc.local
# /etc/rc.local
