#!/bin/zsh

# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: T7: Skaro
# 
# 
# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 

assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color
    
    # 定义左侧提示符
    print -n "%B"
    print -n "%F{${colors[COLOR_01]}}${LEFT_CEILING}%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}}${SQUARE_LEFT}%f"
    print -n "%F{${colors[COLOR_02]}}%~%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}}${SQUARE_RIGHT}%f"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" != "" ]]; then
        print -n "%F{${colors[COLOR_01]}} ${TRANSVERSE_LINE} %f"
        print -n "%F{${REVERSE_SYSTEM_MODE}}${SQUARE_LEFT}%f"
        print -n "%F{${colors[COLOR_03]}}$(__git_ps1 "%s")%f"
        print -n "%F{${REVERSE_SYSTEM_MODE}}${SQUARE_RIGHT}%f"
    fi
    print -n "%F{${colors[COLOR_01]}} ${TRANSVERSE_LINE} %f"
    print -n "%F{${REVERSE_SYSTEM_MODE}}${SQUARE_LEFT}%f"
    print -n "%F{${colors[COLOR_04]}}$(format_time)%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}}${SQUARE_RIGHT}%f"

    print -n "\n"
    print -n "%F{${colors[COLOR_01]}}${LEFT_FLOOR}%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}}${ANGLE_RIGHT}%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}}${TRIANGLE_RIGHT} %f"
    print -n "%b"
}

# 组装右提示符
assemble_colorful_prompt_right() {
    # skip over
}

# 命令执行前
preexec() {

    # === 显示命令耗时：起始时间 ===
    G_ZSH_LAST_COMMAND_START=$EPOCHREALTIME
}

# 命令执行后恢复完整样式
precmd() {
    # === 显示命令耗时：计算 ===
    calu_duration $G_ZSH_LAST_COMMAND_START

    # === 重新生成完整提示符 ===
    PROMPT='$(assemble_colorful_prompt)'
    RPROMPT='$(assemble_colorful_prompt_right)'

    # === 提示符：命令结束后显示耗时 === 
    config_prompt_eol_mark
}

# 刷新提示符中时间
if [[ $MY_COLORFUL_PROMPT_REFRESH_DATETIME -eq 1 ]]; then
    refresh_prompt_datetime
fi

