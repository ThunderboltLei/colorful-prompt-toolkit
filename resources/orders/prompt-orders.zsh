#!/bin/zsh


# Description: 当执行 clear 或 history-c 时，清空提示符结束标记
# Params:
#   param1: 
#   param2: 
# Result: 
# 
_cpt_clear() {
    unset G_ZSH_LAST_COMMAND_START
    unset G_PROMPT_EOL_MARK
    unset G_ZSH_COMMAND_DURATION
    command clear
}
alias clear=_cpt_clear

_cpt_clean_history() {
    # 清除记录
    fc -p

    _cpt_clear
}
alias history-c=_cpt_clean_history


# Description: 检索当前目录下的文件夹列表和文件列表
# Params:
#   param1: 
#   param2: 
# Result: 
# 
_cpt_list() {
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
alias ll=_cpt_list


