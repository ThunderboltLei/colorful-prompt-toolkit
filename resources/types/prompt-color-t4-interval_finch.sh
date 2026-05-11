#!/bin/zsh

# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: T4: Interval Finch
# 


# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 


# 组装左提示符
assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color

    # 定义左侧提示符
    print -n " ${E_APPLE} "
    print -n "%F{${colors[COLOR_01]}}${ROUND_LEFT}%f" # 圆角边缘
    # === user ===
    print -n "%K{${colors[COLOR_01]}}%F{${colors[COLOR_06]}} ${E_USER} %n ${colors[RESET]}"
    print -n "%K{${SYSTEM_MODE}}%F{${colors[COLOR_01]}}${RIGHT_ARROW}${colors[RESET]}"
    print -n "%K{${colors[COLOR_02]}}%F{${SYSTEM_MODE}}${RIGHT_ARROW}${colors[RESET]}"
    # === path ===
    print -n "%K{${colors[COLOR_02]}}%F{${colors[COLOR_06]}} ${E_DOCUMENT} %c ${colors[RESET]}"

    # === github ===
    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`
    if [[ "$branch" == "" ]];
    then
        print -n "%K{${SYSTEM_MODE}}%F{${colors[COLOR_02]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_03]}}%F{${SYSTEM_MODE}}${RIGHT_ARROW}${colors[RESET]}"
    else
        print -n "%K{${SYSTEM_MODE}}%F{${colors[COLOR_02]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${SYSTEM_MODE}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}} ${E_GITHUB} git%B${SQUARE_LEFT}%b${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}}$(__git_ps1 "%s")${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}}%B${SQUARE_RIGHT}%b${colors[RESET]}"
        print -n "%K{${SYSTEM_MODE}}%F{${colors[COLOR_04]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_03]}}%F{${SYSTEM_MODE}}${RIGHT_ARROW}${colors[RESET]}"
    fi

    # === datetime ===
    print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_06]}} ${E_WATCH} $(format_time) ${colors[RESET]}"
    print -n "%F{${colors[COLOR_03]}}${ROUND_RIGHT} %f"
    print -n $'\n'
    print -n "%F{${colors[COLOR_05]}}%B${GREATER_THAN}%b%f"
    print -n " "
}

# 组装右提示符
assemble_colorful_prompt_right() {
    # skip over
}

# 设置一个标志变量
PROMPT_RESET_NEEDED=1

# 命令执行前
preexec() {
}

# 命令执行后恢复完整样式
precmd() {
    # === 重新生成完整提示符 ===
    PROMPT='$(assemble_colorful_prompt)'
    RPROMPT='$(assemble_colorful_prompt_right)'
}


# 刷新提示符中时间
refresh_prompt_datetime
