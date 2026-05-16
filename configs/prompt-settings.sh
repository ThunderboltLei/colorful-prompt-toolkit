#!/bin/zsh

# ========== 配置项 ==========

# === 设置提示符样式 ===
MY_COLORFUL_PROMPT_TYPE=7

# === 提示符使用的颜色组合的行号 ===
MY_COLORFUL_PROMPT_COLOR_NUMBER=9

# === 提示符中时间是否刷新 ===
MY_COLORFUL_PROMPT_REFRESH_DATETIME=0

# === 定义菜单项 ===
# MENU_ITEMS: 左侧，菜单项
# ORDER_ITEMS: 右侧，菜单项对应的命令
MENU_ITEMS=(
    # "<自定义菜单项名称>"
    "System Info"
    "Disk Usage"
    "Memory Status"
    "Network Info"
    "Running Processes"
    "Show Prompt Style"
    "Dirs & Docs"
)
ORDER_ITEMS=(
    # "<自定义菜单项对应的脚本>"
    "system_info.sh"
    "disk_usage.sh"
    "memory_status.sh"
    "network_info.sh"
    "running_processes.sh"
    "show_prompt_style.sh"
    "dirs_and_docs.sh"
)

