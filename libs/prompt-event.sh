#!/usr/bin/env zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: 定义事件函数



# === Function Description Format ===
# 
# Description: 创建可点击的用户名（使用 OSC 8 转义序列）
# Params:
#   param1: 无
#   param2: 无
# Result: 显示菜单
function show_menu() {
    # echo  -n ">>> show_menu"
    # 构建 command:// 协议的 URL
    # 注意：实际支持取决于终端；这里作为示例
    $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-menu.sh
    # zle reset-prompt

    # url="command://echo 'Clicked user: $USER'"
    # text="$USER"
    
    # # 输出可点击的用户名
    # # echo -ne "\033]8;;$url\\"
    # # echo -ne "\033[1;32m$USER\033[0m"  # 绿色粗体显示
    # # echo -ne "\033]8;;\\"
    # echo -n $'%{\e]8;;'"$url"$'\e\\%}'
    # echo -n "%F{green}$text%f"
    # echo -n $'%{\e]8;;\e\\%}'
}