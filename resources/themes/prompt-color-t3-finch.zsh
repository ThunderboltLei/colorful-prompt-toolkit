#!/bin/zsh


# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: T3: Finch
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

    # === 第一行 ===
    # 定义左侧提示符
    print -n " ${APPLE} "
    # === user ===
    print -n "%F{${colors[COLOR_01]}}${ROUND_LEFT}%f" # 圆角边缘
    print -n "%K{${colors[COLOR_01]}}%F{${colors[COLOR_06]}} ${E_USER} %n ${colors[RESET]}"
    # === path ===
    print -n "%K{${colors[COLOR_02]}}%F{${colors[COLOR_01]}}${RIGHT_ARROW}${colors[RESET]}"
    print -n "%K{${colors[COLOR_02]}}%F{${colors[COLOR_06]}} ${E_DOCUMENT} %c ${colors[RESET]}"

    # === github ===
    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`
    if [[ "$branch" == "" ]]; then
        print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_02]}}${RIGHT_ARROW}${colors[RESET]}"
    else
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_02]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}} ${E_GITHUB} git%B${SQUARE_LEFT}%b${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}}$(__git_ps1 "%s")${colors[RESET]}"
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_06]}}%B${SQUARE_RIGHT}%b${colors[RESET]}"
        print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_04]}}${RIGHT_ARROW}${colors[RESET]}"
    fi

    # === datetime ===
    print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_06]}} ${E_CLOCK} $(format_time)${colors[RESET]}"
    print -n "%F{${colors[COLOR_03]}}${ROUND_RIGHT} %f"

    # === 第二行 ===
    print -n $'\n'
    print -n " %F{${colors[COLOR_05]}}%B${ANGLE_RIGHT}${TRIANGLE_RIGHT}%b%f"
    print -n " "
}


# Description: 组装右提示符
# Params:
#   param1: 
#   param2: 
# Result: 
# 
assemble_colorful_prompt_right() {
}


# Description: 组装耗时内容
# Params:
#   param1: 
#   param2: 
# Result: 
# 
assemble_prompt_eol_mark() {
    if [[ -n "$G_ZSH_COMMAND_DURATION" ]]; then
        G_PROMPT_EOL_MARK="\n"
        G_PROMPT_EOL_MARK+="%B"
        G_PROMPT_EOL_MARK+="%F{$PROMPT_EOL_MARK_MOD}$(symbol_printf "$SNOW" 15)%f"
        G_PROMPT_EOL_MARK+="%F{$REVERSE_SYSTEM_MODE} Cost: $G_ZSH_COMMAND_DURATION %f"
        G_PROMPT_EOL_MARK+="%F{$PROMPT_EOL_MARK_MOD}$(symbol_printf "$SNOW" 15) ↩%f"
        G_PROMPT_EOL_MARK+="%b"
        G_PROMPT_EOL_MARK+="\n"
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
}


# Description: 命令执行后恢复完整样式
# Params:
#   param1: 
#   param2: 
# Result: 
#
precmd() {
    # === 显示命令耗时：计算 ===
    calcu_duration

    # === 重新生成完整提示符 ===
    PROMPT='$(assemble_colorful_prompt)'

    # === 提示符：命令结束后显示耗时 === 
    assemble_prompt_eol_mark
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
