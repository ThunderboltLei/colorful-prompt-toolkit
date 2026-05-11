#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:
# 
# 
# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 

# ===== 公共函数 =====


# Description: 定义 precmd 函数
get_command_status() {
    # 获取上一条命令的返回状态
    local _exit_code_=$?
    
    # 使用返回状态
    if [[ $_exit_code_ -eq 0 ]]; then
        echo "${CORRECT}"
        # echo "${GREEN}"
    else
        echo "${WRONG}"
        # echo "${RED}"
    fi
}


# 
# Description: 输出指定数量的符号
# Params:
#   param1: symbol
#   param2: count
# Result: 
#   example: ----------
# 
symbol_printf() {
    local _symbol=$1
    local _count=$2
    printf "$_symbol%.0s" $(seq 1 $_count); echo
}


# 
# Description: 输出指定数量的符号
# Params:
#   param1: symbol
#   param2: count
# Result: 
# 
sentents_printf() {
    # 遍历所有传入的参数
    for _content in "$@"; do
        printf "%s" "$_content"
    done
    # echo 目的是去掉 printf 多出的 %
    echo
}

