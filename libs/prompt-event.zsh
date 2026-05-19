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
_cpt_show_menu() {
    # echo  -n ">>> show_menu"
    # 构建 command:// 协议的 URL
    # 注意：实际支持取决于终端；这里作为示例
    $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-menu.zsh
    # zle reset-prompt

    # url="command://echo 'Clicked user: $USER'"
    # text="$USER"
}

# 绑定到 F1 键或某个组合键
_cpt_run_menu_widget() {
    # 记录第一次按下的时间
    if [[ -z $_h_time ]] || (( EPOCHSECONDS - _h_time > 0.8 )); then
        _h_time=$EPOCHSECONDS
        zle self-insert
        return
    fi
    
    # 0.8秒内第二次按下 -> 双击
    unset _h_time
    zle backward-delete-char  # 删除第一次的h
    _cpt_show_menu   # 执行脚本
    zle reset-prompt
}
zle -N _cpt_run_menu_widget
bindkey 'h' _cpt_run_menu_widget # shift+u 键