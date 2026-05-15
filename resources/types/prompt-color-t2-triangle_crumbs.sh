#!/bin/zsh

# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: T2: triangle crumbs
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
    print -n "\n"
    print -n " ${E_LADY_BUG} "
    print -n "%F{${${colors[COLOR_01]}}}${ROUND_LEFT}%f" # 圆角边缘

    print -n "%K{${colors[COLOR_01]}}%F{${colors[COLOR_06]}}%n ${colors[RESET]}"
    print -n "%K{${colors[COLOR_02]}}%F{${colors[COLOR_01]}}${RIGHT_ARROW}${colors[RESET]}"

    print -n "%K{${colors[COLOR_02]}}%F{${colors[COLOR_06]}} %M ${${colors[RESET]}}"
    print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_02]}}${RIGHT_ARROW}${colors[RESET]}"

    print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_06]}} %c ${colors[RESET]}"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" == "" ]]; then
        print -n "%F{${colors[COLOR_03]}}${RIGHT_ARROW} %f"
    else
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_03]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}} git%B[%b${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}} $(__git_ps1 "%s") ${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}}%B] %b${colors[RESET]}"
        print -n "%F{${colors[COLOR_04]}}${RIGHT_ARROW} %f"  # 右三角边缘
    fi

}

# 组装右提示符
assemble_colorful_prompt_right() {

    # 获取提示符颜色
    get_prompt_color

    # 定义右侧提示符（在命令执行后显示）
    # 或者显示更详细的时间（日期+时间）
    print -n ""
    print -n "%F{${colors[COLOR_05]}}${LEFT_ARROW}%f" # 左三角边缘
    print -n "%K{${colors[COLOR_05]}}%F{${colors[COLOR_06]}} $(get_command_status) ${colors[RESET]}"

    print -n "%K{${colors[COLOR_05]}}%F{${colors[COLOR_04]}}${LEFT_ARROW}${colors[RESET]}"
    # === 显示命令耗时：显示 ===
    print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}} $(get_duration $ZSH_COMMAND_START_TIME) ${colors[RESET]}"

    print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_03]}}${LEFT_ARROW}${colors[RESET]}"
    print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_06]}} ${CLOCK} $(format_time)${colors[RESET]}"
    # print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_06]}} %D{%Y-%m-%d %H:%M:%S} ${colors[RESET]}"
    print -n "%F{${colors[COLOR_03]}}${ROUND_RIGHT}%f" # 圆角边缘
    
}

# 设置一个标志变量
PROMPT_RESET_NEEDED=1

# 命令执行前
preexec() {
    PROMPT_RESET_NEEDED=1

    # # === 显示命令耗时：起始时间 ===
    # ZSH_LAST_COMMAND_START=$EPOCHREALTIME
}

# 命令执行后恢复完整样式
precmd() {
    
    if [[ $PROMPT_RESET_NEEDED -eq 1 ]]; then
        # # === 显示命令耗时：计算 ===
        # calu_duration $ZSH_LAST_COMMAND_START

        # === 重新生成完整提示符 ===
        PROMPT='$(assemble_colorful_prompt)'
        RPROMPT='$(assemble_colorful_prompt_right)'

        PROMPT_RESET_NEEDED=0
    fi
}

# 刷新提示符中时间
if [[ $MY_COLORFUL_PROMPT_REFRESH_DATETIME -eq 1 ]]; then
    refresh_prompt_datetime
fi
