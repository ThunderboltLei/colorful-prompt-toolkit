#!/bin/zsh

# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: 默认样式：Ninja
# 


# Description: 组装左提示符
# Params:
#   param1: 
#   param2: 
# Result: 
# 
assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color
    
    # 定义左侧提示符
    print -n " ${E_LADY_BUG} "
    print -n "%F{${colors[LEFT_COLOR]}}${ROUND_LEFT}%f" # 圆角边缘
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_01]}}%n${colors[RESET]}"
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}}@${colors[RESET]}"
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_02]}}%M${colors[RESET]}"
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}}:${colors[RESET]}"
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_03]}}%c${colors[RESET]}"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" == "" ]]; then
        print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}} ${colors[RESET]}"
    else
        print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}} git(${colors[RESET]}"
        print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_04]}}$(__git_ps1 "%s")${colors[RESET]}"
        print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}}) ${colors[RESET]}"
    fi
    print -n "%F{${colors[RIGHT_COLOR]}}${RIGHT_ARROW} %f" # 圆角边缘

    # print -n " >>> G_ZSH_LAST_COMMAND_START:$G_ZSH_LAST_COMMAND_START \n"
}


# Description: 组装右提示符
# Params:
#   param1: 
#   param2: 
# Result: 
# 
assemble_colorful_prompt_right() {

    # 获取提示符颜色
    get_prompt_color

    # 定义右侧提示符（在命令执行后显示）
    # 或者显示更详细的时间（日期+时间）
    print -n ""
    print -n "%F{${colors[LEFT_COLOR]}}${LEFT_ARROW}%f" # 圆角边缘
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}} $(get_command_status) ${colors[RESET]}"
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_04]}}|${${colors[RESET]}}"
    print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_01]}} ${E_CLOCK} $(format_time)${colors[RESET]}"
    print -n "%F{${colors[RIGHT_COLOR]}}${ROUND_RIGHT}%f" # 圆角边缘
}


assemble_prompt_eol_mark() {
    if [[ -n "$G_ZSH_COMMAND_DURATION" ]]; then
        G_PROMPT_EOL_MARK="\n%B%F{$PROMPT_EOL_MARK_MOD}$(symbol_printf "-" 15) Cost: $G_ZSH_COMMAND_DURATION $(symbol_printf "-" 15) ↩%f%b\n"
        print -P $G_PROMPT_EOL_MARK
    fi
}


# Description: 命令执行前
# Params:
#   param1: 
#   param2: 
# Result: 
# 
preexec() {
    
    # === 显示命令耗时：起始时间 ===
    G_ZSH_LAST_COMMAND_START=$EPOCHREALTIME

    # echo "DEBUG: preexec 被调用"
    # echo "DEBUG: 命令 = $1"
    # echo "DEBUG: 旧开始时间 = $G_ZSH_LAST_COMMAND_START"
    # G_ZSH_LAST_COMMAND_START=$EPOCHREALTIME
    # echo "DEBUG: 新开始时间 = $G_ZSH_LAST_COMMAND_START"
    # echo "---"
}


# Description: 命令执行后恢复完整样式
# Params:
#   param1: 
#   param2: 
# Result: 
# 
precmd() {

    # echo "DEBUG: precmd 被调用"

    # === 显示命令耗时：计算 ===
    calcu_duration
    
    # === 重新生成完整提示符 ===
    PROMPT='$(assemble_colorful_prompt)'
    RPROMPT='$(assemble_colorful_prompt_right)'

    # === 提示符：命令结束后显示耗时 === 
    # config_prompt_eol_mark
    assemble_prompt_eol_mark

    # echo "DEBUG: 计算后 duration = $G_ZSH_COMMAND_DURATION"
    # echo "==="
}


# Description: 刷新提示符中时间
# Params:
#   param1: 
#   param2: 
# Result: 
#
if [[ $MY_COLORFUL_PROMPT_REFRESH_DATETIME -eq 1 ]]; then
    refresh_prompt_datetime
fi
