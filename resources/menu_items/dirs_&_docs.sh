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

menu_function() {
    local info="$({
        # 定义颜色变量
        local RED='\e[0;31m'
        local GREEN='\e[0;32m'
        local YELLOW='\e[1;33m'
        local BLUE='\e[0;34m'
        local CYAN='\e[0;36m'
        local RESET='\e[0m'
        local BOLD='\e[1m'

        printf "${GREEN} >>> ${RED}${BOLD}Directory List:${RESET}\n"
        # 使用 ls -lt 按时间排序目录
        if ls -ld -- */ 2>/dev/null | grep -q .; then
            ls -lt -- */ 2>/dev/null | grep -v '^total'
        else
            printf "No Directory Here ...\n"
        fi

        echo

        printf "${GREEN} >>> ${CYAN}${BOLD}Document List:${RESET}\n"
        # 使用 ls -lt 按时间排序文件
        if ls -l -- *(.) 2>/dev/null | grep -q .; then
            ls -lt -- *(.) 2>/dev/null | grep -v '^total'
        else
            printf "No Document Here ...\n"
        fi
    } 2>/dev/null | grep -v '^total')"

    printf "%s\n" $info
}

# 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi