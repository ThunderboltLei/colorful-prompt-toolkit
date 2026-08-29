#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: prompt-common-funcs.zsh
# Description: common functions


# Description: 定义 precmd 函数
# Params:
#   param1: 
#   param2: 
# Result: 
#   example: ----------
# 
_cpt_get_command_status() {
    # 获取上一条命令的返回状态
    local _exit_code=$1
    
    # 使用返回状态
    if [[ $_exit_code -eq 0 ]]; then
        print -n "%F{green}${CORRECT}%f"
    else
        print -n "%F{red}${WRONG}%f"
    fi
}


# Description: 输出指定数量的符号
# Params:
#   param1: symbol
#   param2: count
# Result: 
#   example: ----------
# 
_cpt_symbol_printf() {
    local _symbol=$1
    local _count=$2
    printf "$_symbol%.0s" $(seq 1 $_count); print -P
}

 
# Description: 定义颜色输出函数
# Params:
#   param1: symbol
#   param2: count
# Result: 
#   example: ----------
# 
_cpt_print_color() {
    local color_code=$1
    local message=$2
    print -P "\033[${color_code}m${message}\033[0m"; echo
}


# Description: 简单显示
# Params:
#   param1: symbol
#   param2: count
# Result: 
#   example: ----------
# 
_cpt_simple_print() {
    local color_code=$1
    print -n -- "$1"; echo
}


# 
# Description: 输出指定数量的符号
# Params:
#   param1: symbol
#   param2: count
# Result: 
# 
_cpt_sentents_printf() {
    # 遍历所有传入的参数
    for _content in "$@"; do
        printf "%s" "$_content"
    done
    # echo 目的是去掉 printf 多出的 %
    echo
}


# 
# Description: 输出指定数量的符号
# Params:
#   param1: symbol
#   param2: count
# Result: 
# 
function _cpt_clickable_pwd() {
    local url="file://${PWD}"
    local display_name="${PWD##*/}"
    [[ -z "$display_name" ]] && display_name="/"

    # print -n "$display_name"
    # printf "%s" "$display_name"
    print -n "%{\e]8;;file://${PWD}\e\ %}%U$display_name%u %{\e]8;;\e\ %}"
}
