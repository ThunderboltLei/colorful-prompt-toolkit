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
)
ORDER_ITEMS=(
    "$(uname -a; printf '\n'; cat /etc/os-release 2>/dev/null | head -n 3)"

    "$(df -h)"

    "$(free -h 2>/dev/null || vm_stat 2>/dev/null || echo 'free/vm_stat not available')"

    "IP Addresses: $(ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}')"

    "$(ps aux | head -n 15)"

    "$(cat $MY_COLORFUL_PROMPT_ROOT_PATH/styles/colorful-style.txt)"
)