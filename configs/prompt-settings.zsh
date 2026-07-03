#!/bin/zsh

# ========== 配置项 ==========

# === 设置提示符样式 ===
MY_COLORFUL_PROMPT_TYPE=10

# === 提示符使用的颜色组合的行号 ===
MY_COLORFUL_PROMPT_COLOR_NUMBER=34

# === 提示符中时间是否刷新 ===
MY_COLORFUL_PROMPT_REFRESH_DATETIME=0

# === 定义菜单项 ===
# MENU_ITEMS: 左侧，菜单项
# ORDER_ITEMS: 右侧，菜单项对应的命令
# === 菜单项名称:层数:类型
MENU_ITEMS=(
    "System:1:Dir"
        "System Info:2:MenuItem"
        "Disk Usage:2:MenuItem"
        "Memory Status:2:MenuItem"
        "Network Info:2:MenuItem"
        "Running Processes:2:MenuItem"
        "Self-difinition:2:Dir"
            "Show Prompt Style:3:MenuItem"
        "Activity Monitor:2:MenuItem"
    "Files:1:Dir"
        "Dirs & Docs:2:MenuItem"
        "Git Log Graph:2:MenuItem"
)
# <自定义菜单项对应的脚本>
ORDER_ITEMS=(
    "system_info.zsh"
    "disk_usage.zsh"
    "memory_status.zsh"
    "network_info.zsh"
    "running_processes.zsh"
    "show_prompt_style.zsh"
    "activity_monitor.zsh"
    "dirs_and_docs.zsh"
    "git_log_graph.zsh"
)

