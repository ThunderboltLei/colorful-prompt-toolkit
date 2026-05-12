#!/bin/zsh

lst() {
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