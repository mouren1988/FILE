#!/bin/bash

# ================= 进程互斥锁 =================
# 确保无论手动执行、Cron还是自动化推送，同一时间只允许1个实例运行
exec 9>/dev/shm/forward_single.lock
flock -n 9 || {
    echo -e "\033[0;33m[警告] 已有 forward_single.sh 实例正在运行，为防止 iptables 冲突，本次跳过。\033[0m"
    exit 1
}
# ==============================================

# 常用命令示例（请根据需要取消注释）
# 清理所有规则：bash $BaseName clean
# 清理指定规则：bash $BaseName clean <端口号>
# 运行过程请不要CTRL+C 取消，也不要同时运行多次此脚本(先取消定时任务再手动执行)

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# 检查iptables命令是否可用
check_iptables_command() {
    if ! command -v iptables &> /dev/null; then
        echo -e "${GREEN}iptables命令不可用，可能需要安装iptables包。请安装后重新运行脚本。${NC}"
        exit 1
    fi
}

# 检查host命令是否可用
check_host_command() {
    if ! command -v host &> /dev/null; then
        echo -e "${GREEN}host命令不可用，可能需要安装bind-utils包。请安装后重新运行脚本。${NC}"
        exit 1
    fi
}

# 执行命令可用性检查
check_iptables_command
check_host_command

# 允许内核转发
echo 1 > /proc/sys/net/ipv4/ip_forward
BaseName=$(basename $BASH_SOURCE)
WorkFile="/dev/shm/$BaseName"

# ================= 定时任务自动添加逻辑 =================
# 定义识别标识，防止重复写入
CRON_MARKER="forward_single.sh"
# 获取当前脚本的绝对路径，确保无论脚本放在哪都能正确执行
SCRIPT_PATH=$(realpath "$0")

# 检查 /etc/crontab 中是否已存在该脚本的任务
if ! grep -q "$CRON_MARKER" /etc/crontab; then
    echo -e "${YELLOW}检测到定时任务未添加，正在自动写入 /etc/crontab...${NC}"
    
    # 使用 tee -a 追加内容，确保格式整齐并换行
    cat << EOF >> /etc/crontab

# 这行负责：开机时立即运行一次转发脚本
@reboot   root  bash $SCRIPT_PATH
# 这行负责：每分钟持续检测并维护转发规则
# * * * * * root  flock -xn /dev/shm/$BaseName.lock -c 'bash $SCRIPT_PATH'
EOF

    echo -e "${GREEN}定时任务已成功添加到 /etc/crontab！${NC}"
    echo -e "${WHITE}脚本路径：$SCRIPT_PATH${NC}"
else
    echo -e "${WHITE}定时任务已存在，无需重复添加。${NC}"
fi
# =======================================================

if [ "$1" = "clean" ]; then
    if [ "$2" ]; then
        # 检查端口规则是否存在
        if [ ! -f "$WorkFile.rule.$2" ]; then
            echo -e "${YELLOW}$2 端口规则不存在，请检查${NC}"
        else
            sed "s|-A|-D|" $WorkFile.rule.$2 | bash
            rm $WorkFile.rule.$2
            echo -e "${RED}$2 端口规则已清除${NC}"
        fi
    else
        # 检查是否有转发规则
        if [ ! "$(ls $WorkFile.rule.* 2>/dev/null)" ]; then
            echo -e "${YELLOW}当前无转发规则，请检查${NC}"
        else
            sed "s|-A|-D|" $WorkFile.rule.* | bash
            rm $WorkFile.rule.*
            echo -e "${RED}全部规则已清除${NC}"
        fi
    fi
    exit
fi

# 以下命令来自动获取本机IP，因环境不同，请先手动执行一下是否获取正确，如果有多个IP，最后可以改为sed -n '3p'|'4p'；适用于本地为动态IP
ip=$(ip a | grep -w inet | awk '{print $2}' | awk -F '/' '{print $1}' | sed -n '2p')

# 单端口转发规则
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
    # "$ip 16016  119.199.246.132  44168"
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



#删除可能遗留的缓存
rm -rf $WorkFile.iptables
rm -rf $WorkFile.hosts

if [ ! "${Single_Rule[*]}" ]; then
    echo -e "${YELLOW}当前无转发规则，请检查${NC}"
    exit
fi

rm -rf $WorkFile.domain

#收集域名进$WorkFile.domain
for list in "${Single_Rule[@]}"; do
    list=($list)
    echo ${list[2]} >> $WorkFile.domain
done

Domain=$(sort $WorkFile.domain | uniq | grep -v -E '([0-9]{1,3}[\.]){3}[0-9]{1,3}')
rm -rf $WorkFile.domain

# 将域名解析结果存入 hosts 文件
for domain in $(echo "$Domain"); do
    {
        domain_ip=$(host -4 -t A -W 1 $domain | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -1)
        if [ "$domain_ip" ]; then 
            echo "$domain $domain_ip" >> $WorkFile.hosts
        fi
    }&
done
wait

#将当前iptables规则表导出
echo "$(iptables -t nat -nL | grep NAT)" > $WorkFile.iptables

#若本地IP变化，则刷新规则
if [ "$ip" ]; then
    if [ ! "$(grep -o $ip $WorkFile.iptables)" ]; then 
        touch $WorkFile.is_changed
    fi
fi

# 单端口转发检测
for rule in "${Single_Rule[@]}"; do
    sleep 0.1s
    {
        rule=($rule)
        if [ ${#rule[*]} == 4 ]; then
            Local_IP=${rule[0]}
            Local_Port=${rule[1]}
            Remote_IP=${rule[2]}
            Remote_Port=${rule[3]}

            # 检查目标是否是 IP，如果是域名则解析
            if [ ! "$(echo $Remote_IP | grep -E -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}')" ]; then
                Remote_IP=$(grep -w $Remote_IP $WorkFile.hosts | awk '{print $2}')
            fi

            if [ "$Remote_IP" ]; then
                # 增加调试输出，查看匹配的规则
                #echo "Checking DNAT rule: dpt:$Local_Port to:$Remote_IP:$Remote_Port"
                
                # 判断规则是否已存在且一致
                ExistingRuleDNAT=$(grep DNAT $WorkFile.iptables | grep -w "dpt:$Local_Port" | grep -w "to:$Remote_IP:$Remote_Port")
                ExistingRuleSNAT=$(grep SNAT $WorkFile.iptables | grep -w "$Remote_IP" | grep -w "dpt:$Remote_Port")
                
                # 输出当前检查到的规则
                #echo "Existing DNAT rule: $ExistingRuleDNAT"
                #echo "Existing SNAT rule: $ExistingRuleSNAT"

                # 如果规则已经存在且一致，跳过
                if [ "$ExistingRuleDNAT" ] && [ "$ExistingRuleSNAT" ]; then
                    echo -e "${WHITE}端口 $Local_Port 转发已存在，跳过${NC}"
                else
                    # 规则变化或不存在，需更新
                    if [ -f "$WorkFile.rule.$Local_Port" ]; then
                        # 先删除已有的规则
                        sed -i "s|-A|-D|" $WorkFile.rule.$Local_Port
                        bash $WorkFile.rule.$Local_Port >/dev/null 2>&1
                    fi

                    # 删除现有的规则，添加新的规则
                    echo "
iptables -t nat -A PREROUTING -p tcp --dport $Local_Port -j DNAT --to-destination $Remote_IP:$Remote_Port
iptables -t nat -A POSTROUTING -d $Remote_IP -p tcp --dport $Remote_Port -j SNAT --to-source $Local_IP
iptables -t nat -A PREROUTING -p udp --dport $Local_Port -j DNAT --to-destination $Remote_IP:$Remote_Port
iptables -t nat -A POSTROUTING -d $Remote_IP -p udp --dport $Remote_Port -j SNAT --to-source $Local_IP
" > $WorkFile.rule.$Local_Port

                    if bash $WorkFile.rule.$Local_Port >/dev/null 2>&1; then
                        # 根据条件输出“更新”或“添加”
                        if [ ! "$ExistingRuleDNAT" ] || [ ! "$ExistingRuleSNAT" ]; then
                            echo -e "${GREEN}端口 $Local_Port 转发已更新${NC}"
                        else
                            echo -e "${YELLOW}端口 $Local_Port 转发已添加${NC}"
                        fi
                    else
                        echo -e "${RED}端口 $Local_Port 转发未成功，请检查${NC}"
                    fi
                fi
            else
                echo -e "${RED}端口 $Local_Port 域名解析失败，请检查${NC}"
            fi
        fi
    }&
done
wait


#删除缓存
rm -rf $WorkFile.iptables
rm -rf $WorkFile.hosts
