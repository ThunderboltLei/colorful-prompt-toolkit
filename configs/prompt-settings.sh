#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:

# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 

# ========== 配置项 ==========

# === 使用何种样式 ===
MY_COLORFUL_PROMPT_TYPE=7

# === 使用颜色组合的行号 ===
MY_COLORFUL_PROMPT_COLOR_NUMBER=9

# === 定义菜单项 ===
# MENU_ITEMS: 左侧，菜单项
# ORDER_ITEMS: 右侧，菜单项对应的命令
MENU_ITEMS=(
    "System Info"
    "Disk Usage"
    "Memory Status"
    "Network Info"
    "Running Processes"
    "Show Prompt Style"
    "Documents"
)
ORDER_ITEMS=(
    "$(uname -a; printf '\n'; cat /etc/os-release 2>/dev/null | head -n 3)"

    "$(df -h)"

    "$(free -h 2>/dev/null || vm_stat 2>/dev/null || echo 'free/vm_stat not available')"

    "IP Addresses: $(ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}')"

    "$(ps aux | head -n 15)"
 
    "$(cat $MY_COLORFUL_PROMPT_ROOT_PATH/styles/colorful-style.txt)"

    # "$(ls -l | awk 'NR>1 {
    #     # 定义月份映射
    #     m["Jan"]=1; m["Feb"]=2; m["Mar"]=3; m["Apr"]=4;
    #     m["May"]=5; m["Jun"]=6; m["Jul"]=7; m["Aug"]=8;
    #     m["Sep"]=9; m["Oct"]=10; m["Nov"]=11; m["Dec"]=12;
    #     # 输出添加数字月份的新记录
    #     print $1, $2, $3, $4, m[$6], $7, $8, $9, $0
    # }' | sort -k2nr -k5nr -k6nr -k7nr -k8r | cut -d' ' -f9-)"

    "$({
        # 定义颜色变量
        local RED='\e[0;31m'
        local GREEN='\e[0;32m'
        local YELLOW='\e[1;33m'
        local BLUE='\e[0;34m'
        local CYAN='\e[0;36m'
        local RESET='\e[0m'
        local BOLD='\e[1m'

        printf "${GREEN} >>> ${RED}${BOLD}Directory List:${RESET}\n";
        ([[ -n `ls -ld -- */ 2>/dev/null` ]] && ls -ld -- */ | sort -k6r -k7r -k8r -k9r || printf "No Directory Here ...\n"); # 先列目录
        echo;
        printf "${GREEN} >>> ${CYAN}${BOLD}Document List:${RESET}\n";
        ([[ -n `ls -ld -- *(.) 2>/dev/null` ]] && ls -ld -- *(.) | sort -k6r -k7r -k8r -k9r || printf "No Document Here ...\n"); # 再列文件
    } 2>/dev/null | grep -v '^total')"
)