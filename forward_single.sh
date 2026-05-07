#!/bin/bash

# ================= 1. 转发规则配置 (请在此修改) =================
# 获取本机出网IP (供下面 Single_Rule 使用)
ip=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+')

Single_Rule=(
     "$ip 16001  220.92.101.154  44168"
     "$ip 16002  138.2.112.115  44168"
     "$ip 16003  138.2.117.168  44168"
     "$ip 16004  115.16.132.75  44168"
     "$ip 16005  115.7.190.181  44168"
     "$ip 16006  119.199.246.132  44168"
     "$ip 16007  61.75.250.84  44168"
     "$ip 16008  115.16.132.127  44168"
     "$ip 16009  115.16.132.4  44168"
     "$ip 16010  183.124.223.47  44168"
     "$ip 16011  115.15.153.223 44168"
     "$ip 16012  175.243.241.25 44168"
     "$ip 16013  175.243.241.164  44168"
     "$ip 16014  61.75.106.205  44168"
     "$ip 16015  175.243.241.64  44168"
    # "$ip 16016  192.168.1.1  44168"
    # "$ip 16017  192.168.1.1  44168"
    # "$ip 16018  192.168.1.1  44168"
    # "$ip 16019  192.168.1.1  44168"
    # "$ip 16020  192.168.1.1  44168"	
    # "$ip 16021  192.168.1.1  44168"
    # "$ip 16022  192.168.1.1  44168"
    # "$ip 16023  192.168.1.1  44168"
    # "$ip 16024  192.168.1.1  44168"
    # "$ip 16025  192.168.1.1  44168"
    # "$ip 16026  192.168.1.1  44168"
    # "$ip 16027  192.168.1.1  44168"
    # "$ip 16028  192.168.1.1  44168"
    # "$ip 16029  192.168.1.1  44168"
    # "$ip 16030  192.168.1.1  44168"
    # "$ip 16031  192.168.1.1  44168"
    # "$ip 16032  192.168.1.1  44168"
    # "$ip 16033  192.168.1.1  44168"
    # "$ip 16034  192.168.1.1  44168"
    # "$ip 16035  192.168.1.1  44168"
    # "$ip 16036  192.168.1.1  44168"
    # "$ip 16037  192.168.1.1  44168"
    # "$ip 16038  192.168.1.1  44168"
    # "$ip 16039  192.168.1.1  44168"
    # "$ip 16040  192.168.1.1  44168"
    # "$ip 16041  192.168.1.1  44168"
    # "$ip 16042  192.168.1.1  44168"
    # "$ip 16043  192.168.1.1  44168"
    # "$ip 16044  192.168.1.1  44168"
    # "$ip 16045  192.168.1.1  44168"
    # "$ip 16046  192.168.1.1  44168"
    # "$ip 16047  192.168.1.1  44168"
    # "$ip 16048  192.168.1.1  44168"
    # "$ip 16049  192.168.1.1  44168"
    # "$ip 16050  192.168.1.1  44168"
    # "$ip 16051  192.168.1.1  44168"
    # "$ip 16052  192.168.1.1  44168"
    # "$ip 16053  192.168.1.1  44168"
    # "$ip 16054  192.168.1.1  44168"
    # "$ip 16055  192.168.1.1  44168"
    # "$ip 16056  192.168.1.1  44168"
    # "$ip 16057  192.168.1.1  44168"
    # "$ip 16058  192.168.1.1  44168"
    # "$ip 16059  192.168.1.1  44168"
    # "$ip 16060  192.168.1.1  44168"
    # "$ip 16061  192.168.1.1  44168"
    # "$ip 16062  192.168.1.1  44168"
    # "$ip 16063  192.168.1.1  44168"
    # "$ip 16064  192.168.1.1  44168"
    # "$ip 16065  192.168.1.1  44168"
    # "$ip 16066  192.168.1.1  44168"
    # "$ip 16067  192.168.1.1  44168"
    # "$ip 16068  192.168.1.1  44168"
    # "$ip 16069  192.168.1.1  44168"
    # "$ip 16070  192.168.1.1  44168"
    # "$ip 16071  192.168.1.1  44168"
    # "$ip 16072  192.168.1.1  44168"
    # "$ip 16073  192.168.1.1  44168"
    # "$ip 16074  192.168.1.1  44168"
    # "$ip 16075  192.168.1.1  44168"
    # "$ip 16076  192.168.1.1  44168"
    # "$ip 16077  192.168.1.1  44168"
    # "$ip 16078  192.168.1.1  44168"
    # "$ip 16079  192.168.1.1  44168"
    # "$ip 16080  192.168.1.1  44168"
    # "$ip 16081  192.168.1.1  44168"
    # "$ip 16082  192.168.1.1  44168"
    # "$ip 16083  192.168.1.1  44168"
    # "$ip 16084  192.168.1.1  44168"
    # "$ip 16085  192.168.1.1  44168"
    # "$ip 16086  192.168.1.1  44168"
    # "$ip 16087  192.168.1.1  44168"
    # "$ip 16088  192.168.1.1  44168"
    # "$ip 16089  192.168.1.1  44168"
    # "$ip 16090  192.168.1.1  44168"
    # "$ip 16091  192.168.1.1  44168"
    # "$ip 16092  192.168.1.1  44168"
    # "$ip 16093  192.168.1.1  44168"
    # "$ip 16094  192.168.1.1  44168"
    # "$ip 16095  192.168.1.1  44168"
    # "$ip 16096  192.168.1.1  44168"
    # "$ip 16097  192.168.1.1  44168"
    # "$ip 16098  192.168.1.1  44168"
    # "$ip 16099  192.168.1.1  44168"
    # "$ip 16100  192.168.1.1  44168"
)

# ================= 2. 进程互斥锁 =================
exec 9>/dev/shm/forward_single.lock
flock -w 15 9 || {
    echo -e "\033[0;33m[警告] 已有实例运行且超过15秒未释放，本次跳过。\033[0m"
    exit 1
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[0;37m'
NC='\033[0m' 

# 环境检查
if ! command -v iptables &> /dev/null; then echo -e "${RED}未安装 iptables！${NC}"; exit 1; fi
if ! command -v host &> /dev/null; then echo -e "${RED}未安装 host (bind-utils)！${NC}"; exit 1; fi

# 允许内核转发
echo 1 > /proc/sys/net/ipv4/ip_forward

# ================= 3. 状态持久化与定时任务 =================
BaseName=$(basename $BASH_SOURCE)
WorkDir="/root/.forward_cache"
mkdir -p "$WorkDir"
WorkFile="$WorkDir/$BaseName"

SCRIPT_PATH=$(realpath "$0")
if ! grep -q "$BaseName" /etc/crontab; then
    cat << EOF >> /etc/crontab

# [节点转发] 开机自动恢复
@reboot   root  bash $SCRIPT_PATH
# * * * * * root  bash $SCRIPT_PATH
EOF
    echo -e "${GREEN}定时任务已同步至 /etc/crontab${NC}"
fi

# ================= 4. 业务功能 (clean/解析/执行) =================
# 清理功能
if [ "$1" = "clean" ]; then
    if [ "$2" ]; then
        [ -f "$WorkFile.rule.$2" ] && { sed "s|-A|-D|" $WorkFile.rule.$2 | bash; rm -f $WorkFile.rule.$2; echo -e "${RED}端口 $2 规则已清除${NC}"; }
    else
        ls $WorkFile.rule.* &>/dev/null && { sed "s|-A|-D|" $WorkFile.rule.* | bash; rm -f $WorkFile.rule.*; echo -e "${RED}全部规则已清除${NC}"; }
    fi
    exit
fi

# 域名解析转换
rm -rf $WorkFile.hosts $WorkFile.domain
for list in "${Single_Rule[@]}"; do list=($list); echo ${list[2]} >> $WorkFile.domain; done
Domain=$(sort $WorkFile.domain | uniq | grep -v -E '([0-9]{1,3}[\.]){3}[0-9]{1,3}')
for d in $Domain; do
    d_ip=$(host -4 -t A -W 1 $d | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -1)
    [ "$d_ip" ] && echo "$d $d_ip" >> $WorkFile.hosts
done

# 导出快照比对
echo "$(iptables -t nat -nL | grep NAT)" > $WorkFile.iptables

# 构造混合排序列表
ALL_PORTS=$( { 
    for r in "${Single_Rule[@]}"; do r=($r); echo "${r[1]}"; done; 
    ls $WorkFile.rule.* 2>/dev/null | awk -F '.' '{print $NF}' | grep -E '^[0-9]+$'; 
} | sort -uV )

for p in $ALL_PORTS; do
    MATCH_RULE=""
    for r in "${Single_Rule[@]}"; do
        temp_r=($r)
        if [ "${temp_r[1]}" == "$p" ]; then
            MATCH_RULE="$r"
            break
        fi
    done

    if [ -z "$MATCH_RULE" ]; then
        if [ -f "$WorkFile.rule.$p" ]; then
            sed "s|-A|-D|" $WorkFile.rule.$p | sed "s|iptables|iptables -w|g" | bash >/dev/null 2>&1
            rm -f $WorkFile.rule.$p
            echo -e "${RED}端口 $p 规则失效，已清除${NC}"
        fi
    else
        rule=($MATCH_RULE)
        Local_IP=${rule[0]}; Local_Port=${rule[1]}; Remote_IP=${rule[2]}; Remote_Port=${rule[3]}
        
        if [[ ! "$Remote_IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            Remote_IP=$(grep -w $Remote_IP $WorkFile.hosts | awk '{print $2}')
        fi

        if [ "$Remote_IP" ]; then
            ExistingRuleDNAT=$(grep DNAT $WorkFile.iptables | grep -w "dpt:$Local_Port" | grep -w "to:$Remote_IP:$Remote_Port")
            ExistingRuleSNAT=$(grep SNAT $WorkFile.iptables | grep -w "$Remote_IP" | grep -w "dpt:$Remote_Port")
            
            if [ "$ExistingRuleDNAT" ] && [ "$ExistingRuleSNAT" ]; then
                echo -e "${WHITE}端口 $Local_Port 规则一致，已跳过${NC}"
                
                # 【新增补丁】：针对从旧版升级过来的情况，如果规则一致但缺失缓存，则默默补齐
                if [ ! -f "$WorkFile.rule.$Local_Port" ]; then
                    echo "
iptables -w -t nat -A PREROUTING -p tcp --dport $Local_Port -j DNAT --to-destination $Remote_IP:$Remote_Port
iptables -w -t nat -A POSTROUTING -d $Remote_IP -p tcp --dport $Remote_Port -j SNAT --to-source $Local_IP
iptables -w -t nat -A PREROUTING -p udp --dport $Local_Port -j DNAT --to-destination $Remote_IP:$Remote_Port
iptables -w -t nat -A POSTROUTING -d $Remote_IP -p udp --dport $Remote_Port -j SNAT --to-source $Local_IP
" > $WorkFile.rule.$Local_Port
                fi

            else
                # 变动更新
                [ -f "$WorkFile.rule.$Local_Port" ] && { sed "s|-A|-D|" $WorkFile.rule.$Local_Port | bash >/dev/null 2>&1; }
                echo "
iptables -w -t nat -A PREROUTING -p tcp --dport $Local_Port -j DNAT --to-destination $Remote_IP:$Remote_Port
iptables -w -t nat -A POSTROUTING -d $Remote_IP -p tcp --dport $Remote_Port -j SNAT --to-source $Local_IP
iptables -w -t nat -A PREROUTING -p udp --dport $Local_Port -j DNAT --to-destination $Remote_IP:$Remote_Port
iptables -w -t nat -A POSTROUTING -d $Remote_IP -p udp --dport $Remote_Port -j SNAT --to-source $Local_IP
" > $WorkFile.rule.$Local_Port
                
                if bash $WorkFile.rule.$Local_Port >/dev/null 2>&1; then
                    echo -e "${GREEN}端口 $Local_Port 规则变化，已更新${NC}"
                else
                    echo -e "${RED}端口 $Local_Port 更新失败${NC}"
                fi
            fi
        else
            echo -e "${RED}端口 $Local_Port 域名解析失败，已跳过${NC}"
        fi
    fi
done

rm -f $WorkFile.iptables $WorkFile.hosts $WorkFile.domain