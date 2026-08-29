#!/bin/zsh

# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: T4: Interval Finch
# 


# Description: 组装左提示符
# Params:
#   param1: 
#   param2: 
# Result: 
# 
assemble_colorful_prompt() {

    # 获取提示符颜色
    _cpt_get_prompt_color

    # 定义左侧提示符
    # print -n "${EMPTY}${E_GREEN_APPLE}${EMPTY}"
    print -n "${EMPTY}"
    print -n "%F{${colors[COLOR_01]}}${ROUND_LEFT}%f" # 圆角边缘
    # === user ===
    print -n "%K{${colors[COLOR_01]}}%F{${REVERSE_SYSTEM_MODE}}${APPLE}${EMPTY}%n${EMPTY}${colors[RESET]}"
    print -n "%K{${colors[COLOR_02]}}%F{${colors[COLOR_01]}}${RIGHT_ARROW}${colors[RESET]}"
    print -n "%K{${colors[COLOR_03]}}%F{${colors[COLOR_02]}}${RIGHT_ARROW}${colors[RESET]}"
    # === path ===
    # print -n "%K{${colors[COLOR_03]}}%F{${REVERSE_SYSTEM_MODE}}${EMPTY}${DOCUMENT}${EMPTY}%c${EMPTY}${colors[RESET]}"
    print -n "%K{${colors[COLOR_03]}}%F{${REVERSE_SYSTEM_MODE}}${EMPTY}${DOCUMENT}${EMPTY}$(_cpt_clickable_pwd)${EMPTY}${colors[RESET]}"

    # === github ===
    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`
    if [[ "$branch" == "" ]]; then
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_03]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_04]}}${RIGHT_ARROW}${colors[RESET]}"
    else
        print -n "%K{${colors[COLOR_04]}}%F{${colors[COLOR_03]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_05]}}%F{${colors[COLOR_04]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_05]}}%F{${REVERSE_SYSTEM_MODE}}${EMPTY}${GITHUB}${EMPTY}git%B${SQUARE_LEFT}%b${colors[RESET]}"
        print -n "%K{${colors[COLOR_05]}}%F{${REVERSE_SYSTEM_MODE}}$(__git_ps1 "%s")${colors[RESET]}"
        print -n "%K{${colors[COLOR_05]}}%F{${REVERSE_SYSTEM_MODE}}%B${SQUARE_RIGHT}%b${colors[RESET]}"
        print -n "%K{${colors[COLOR_01]}}%F{${colors[COLOR_05]}}${RIGHT_ARROW}${colors[RESET]}"
        print -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_01]}}${RIGHT_ARROW}${colors[RESET]}"
    fi

    # === datetime ===
    print -n "%K{${colors[COLOR_06]}}%F{${REVERSE_SYSTEM_MODE}}${EMPTY}${WATCH}${EMPTY}$(_cpt_format_time)${EMPTY}${colors[RESET]}"
    print -n "%F{${colors[COLOR_06]}}${ROUND_RIGHT}${EMPTY}%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}}%B${ANGLE_RIGHT}%b%f"
    print -n "${EMPTY}"
}


# Description: 组装右提示符
# Params:
#   param1: 
#   param2: 
# Result: 
# 
assemble_colorful_prompt_right() {
    # skip over
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
        G_PROMPT_EOL_MARK+="%F{$PROMPT_EOL_MARK_MOD}$(_cpt_symbol_printf "$SNOW" 15)%f"
        G_PROMPT_EOL_MARK+="%F{$REVERSE_SYSTEM_MODE} Cost: $G_ZSH_COMMAND_DURATION %f"
        G_PROMPT_EOL_MARK+="%F{$PROMPT_EOL_MARK_MOD}$(_cpt_symbol_printf "$SNOW" 15) ↩%f"
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
    PROMPT="$(assemble_colorful_prompt)"
    RPROMPT="$(assemble_colorful_prompt_right)"

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
