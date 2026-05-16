#!/bin/zsh


# 
# Description: 当执行 clear 或 history-c 时，清空提示符结束标记
# Params:
#   param1: 
#   param2: 
# Result: 
# 
clear() {
    unset G_ZSH_LAST_COMMAND_START
    unset G_PROMPT_EOL_MARK
    unset G_ZSH_COMMAND_DURATION
    command clear
}
alias history-c=clear


# Description: 检索当前目录下的文件夹列表和文件列表
# Params:
#   param1: 
#   param2: 
# Result: 
# 
ll() {
    {
        # 定义颜色变量
        local RED='\033[0;31m'
        local GREEN='\033[0;32m'
        local YELLOW='\033[1;33m'
        local BLUE='\033[0;34m'
        local CYAN='\033[0;36m'
        local RESET='\033[0m'
        local BOLD='\033[1m'

        printf "${GREEN} >>> ${RED}${BOLD}Directory List:${RESET}\n"
        ([[ -n `ls -ld -- */ 2>/dev/null` ]] && ls -ld -- */ | sort -k6r -k7r -k8r -k9r || printf "No Directory Here ...\n"); # 先列目录
        echo;
        printf "${GREEN} >>> ${CYAN}${BOLD}Document List:${RESET}\n";
        ([[ -n `ls -ld -- *(.) 2>/dev/null` ]] && ls -ld -- *(.) | sort -k6r -k7r -k8r -k9r || printf "No Document Here ...\n"); # 再列文件
    } 2>/dev/null | grep -v '^total'
}


# Description: 将 EPOCHREALTIME 转换为可读格式（高精度）
# Params:
#   param1: 
#   param2: 
# Result: 
# 
epoch_to_datetime() {
    local epoch=$1
    local format=${2:-"%Y-%m-%d %H:%M:%S"}
    
    local seconds=${epoch%.*}
    local nanos=${epoch#*.}
    
    # 使用 strftime（zsh 内置，最快）
    if (( $+functions[strftime] )); then
        local datetime=$(strftime "$format" $seconds)
        echo "${datetime}.${nanos:0:3}"  # 显示毫秒
    else
        # 降级方案：使用 date 命令
        local datetime=$(date -r $seconds +"$format" 2>/dev/null || date -d "@$seconds" +"$format")
        echo "${datetime}.${nanos:0:3}"
    fi
}


# Description: 将日期时间转换为 EPOCHREALTIME
# Params:
#   param1: 
#   param2: 
# Result: 
# 
datetime_to_epoch() {
    local datetime=$1
    local seconds
    
    # macOS
    if [[ "$OSTYPE" == darwin* ]]; then
        seconds=$(date -j -f "%Y-%m-%d %H:%M:%S" "$datetime" +"%s" 2>/dev/null)
    else
        # Linux
        seconds=$(date -d "$datetime" +"%s" 2>/dev/null)
    fi
    
    # 添加纳秒部分（默认 .000000000）
    echo "${seconds}.000000000"
}

# # 使用示例
# epoch_to_datetime $EPOCHREALTIME
# # 输出: 2024-01-13 14:30:56.123

# datetime_to_epoch "2024-01-13 14:30:56"
# # 输出: 1705123456.000000000