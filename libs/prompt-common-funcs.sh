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
