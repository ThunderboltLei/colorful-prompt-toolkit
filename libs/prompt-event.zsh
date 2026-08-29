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


# 
# Description: 目录处点击弹出窗口的功能
# Params:
#   param1: symbol
#   param2: count
# Result: 
# 
function _cpt_clickable_pwd() {
    local url="file://${PWD}"
    local display_name="${PWD##*/}"
    [[ -z "$display_name" ]] && display_name="/"

    ### 说明：\e\\不能显示出${EMPTY}这个空格，同时在命令补全时会多出第一个字母。
    # print -n "%{\e]8;;file://${PWD}\e\\%}%U$display_name%u%{\e]8;;\e\\%}"
    ### 备注：\a使用此语句，不会出现上述问题。
    print -n "%{\e]8;;file://${PWD}\a%}%U$display_name%u%{\e]8;;\a%}"
}


