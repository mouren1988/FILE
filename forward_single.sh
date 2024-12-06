#!/bin/bash
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

# 定时任务添加
if [ ! "`ls -lh /etc|grep $BaseName`" ]; then
    mv $0 /etc
    echo -e "${YELLOW}已将该脚本移动至/etc/$BaseName${NC}"
    echo -e "${YELLOW}若需要转发动态域名，请再执行下方命令${NC}"
    echo -e "${YELLOW}echo \"* * * * * root flock -xn /dev/shm/$BaseName.lock -c 'bash /etc/$BaseName'\" >> /etc/crontab${NC}"
fi

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
    # "$ip 6001  192.168.1.1  9527"
    # "$ip 6002  192.168.1.1  9527"
    # "$ip 6003  192.168.1.1  9527"
    # "$ip 6004  192.168.1.1  9527"
    # "$ip 6005  192.168.1.1  9527"
    # "$ip 6006  192.168.1.1  9527"
    # "$ip 6007  192.168.1.1  9527"
    # "$ip 6008  192.168.1.1  9527"
    # "$ip 6009  192.168.1.1  9527"
    # "$ip 6010  192.168.1.1  9527"
    # "$ip 6011  192.168.1.1  9527"
    # "$ip 6012  192.168.1.1  9527"
    # "$ip 6013  192.168.1.1  9527"
    # "$ip 6014  192.168.1.1  9527"
    # "$ip 6015  192.168.1.1  9527"
    # "$ip 6016  192.168.1.1  9527"
    # "$ip 6017  192.168.1.1  9527"
    # "$ip 6018  192.168.1.1  9527"
    # "$ip 6019  192.168.1.1  9527"
    # "$ip 6020  192.168.1.1  9527"
    # "$ip 6021  192.168.1.1  9527"
    # "$ip 6022  192.168.1.1  9527"
    # "$ip 6023  192.168.1.1  9527"
    # "$ip 6024  192.168.1.1  9527"
    # "$ip 6025  192.168.1.1  9527"
    # "$ip 6026  192.168.1.1  9527"
    # "$ip 6027  192.168.1.1  9527"
    # "$ip 6028  192.168.1.1  9527"
    # "$ip 6029  192.168.1.1  9527"
    # "$ip 6030  192.168.1.1  9527"
    # "$ip 6031  192.168.1.1  9527"
    # "$ip 6032  192.168.1.1  9527"
    # "$ip 6033  192.168.1.1  9527"
    # "$ip 6034  192.168.1.1  9527"
    # "$ip 6035  192.168.1.1  9527"
    # "$ip 6036  192.168.1.1  9527"
    # "$ip 6037  192.168.1.1  9527"
    # "$ip 6038  192.168.1.1  9527"
    # "$ip 6039  192.168.1.1  9527"
    # "$ip 6040  192.168.1.1  9527"
    # "$ip 6041  192.168.1.1  9527"
    # "$ip 6042  192.168.1.1  9527"
    # "$ip 6043  192.168.1.1  9527"
    # "$ip 6044  192.168.1.1  9527"
    # "$ip 6045  192.168.1.1  9527"
    # "$ip 6046  192.168.1.1  9527"
    # "$ip 6047  192.168.1.1  9527"
    # "$ip 6048  192.168.1.1  9527"
    # "$ip 6049  192.168.1.1  9527"
    # "$ip 6050  192.168.1.1  9527"
    # "$ip 6051  192.168.1.1  9527"
    # "$ip 6052  192.168.1.1  9527"
    # "$ip 6053  192.168.1.1  9527"
    # "$ip 6054  192.168.1.1  9527"
    # "$ip 6055  192.168.1.1  9527"
    # "$ip 6056  192.168.1.1  9527"
    # "$ip 6057  192.168.1.1  9527"
    # "$ip 6058  192.168.1.1  9527"
    # "$ip 6059  192.168.1.1  9527"
    # "$ip 6060  192.168.1.1  9527"
    # "$ip 6061  192.168.1.1  9527"
    # "$ip 6062  192.168.1.1  9527"
    # "$ip 6063  192.168.1.1  9527"
    # "$ip 6064  192.168.1.1  9527"
    # "$ip 6065  192.168.1.1  9527"
    # "$ip 6066  192.168.1.1  9527"
    # "$ip 6067  192.168.1.1  9527"
    # "$ip 6068  192.168.1.1  9527"
    # "$ip 6069  192.168.1.1  9527"
    # "$ip 6070  192.168.1.1  9527"
    # "$ip 6071  192.168.1.1  9527"
    # "$ip 6072  192.168.1.1  9527"
    # "$ip 6073  192.168.1.1  9527"
    # "$ip 6074  192.168.1.1  9527"
    # "$ip 6075  192.168.1.1  9527"
    # "$ip 6076  192.168.1.1  9527"
    # "$ip 6077  192.168.1.1  9527"
    # "$ip 6078  192.168.1.1  9527"
    # "$ip 6079  192.168.1.1  9527"
    # "$ip 6080  192.168.1.1  9527"
    # "$ip 6081  192.168.1.1  9527"
    # "$ip 6082  192.168.1.1  9527"
    # "$ip 6083  192.168.1.1  9527"
    # "$ip 6084  192.168.1.1  9527"
    # "$ip 6085  192.168.1.1  9527"
    # "$ip 6086  192.168.1.1  9527"
    # "$ip 6087  192.168.1.1  9527"
    # "$ip 6088  192.168.1.1  9527"
    # "$ip 6089  192.168.1.1  9527"
    # "$ip 6090  192.168.1.1  9527"
    # "$ip 6091  192.168.1.1  9527"
    # "$ip 6092  192.168.1.1  9527"
    # "$ip 6093  192.168.1.1  9527"
    # "$ip 6094  192.168.1.1  9527"
    # "$ip 6095  192.168.1.1  9527"
    # "$ip 6096  192.168.1.1  9527"
    # "$ip 6097  192.168.1.1  9527"
    # "$ip 6098  192.168.1.1  9527"
    # "$ip 6099  192.168.1.1  9527"
    # "$ip 6100  192.168.1.1  9527"
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
