#!/bin/zsh


# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: T8: Skaro Doublet


# Description: 组装右提示符
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
    print -n "%F{${colors[COLOR_01]}}${LEFT_CEILING_DOUBLET}%f"
    print -n "%F{${colors[COLOR_06]}}${MEDIUM_LEFT_DOUBLET}%f"
    print -n "%F{${colors[COLOR_02]}}%~%f"
    print -n "%F{${colors[COLOR_06]}}${MEDIUM_RIGHT_DOUBLET}%f"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" != "" ]]; then
        print -n "%F{${colors[COLOR_01]}} ${TRANSVERSE_LINE} %f"
        print -n "%F{${colors[COLOR_06]}}${MEDIUM_LEFT_DOUBLET}%f"
        print -n "%F{${colors[COLOR_03]}}$(__git_ps1 "%s")%f"
        print -n "%F{${colors[COLOR_06]}}${MEDIUM_RIGHT_DOUBLET}%f"
    fi
    print -n "%F{${colors[COLOR_01]}} ${TRANSVERSE_LINE} %f"
    print -n "%F{${colors[COLOR_06]}}${MEDIUM_LEFT_DOUBLET}%f"
    print -n "%F{${colors[COLOR_04]}}$(format_time)%f"
    print -n "%F{${colors[COLOR_06]}}${MEDIUM_RIGHT_DOUBLET}%f"

    print -n "\n"
    print -n "%F{${colors[COLOR_01]}}${LEFT_FLOOR_DOUBLET}%f"
    print -n "%F{${colors[COLOR_06]}}${MEDIUM_LEFT_DOUBLET}%f"
    print -n "%F{${colors[COLOR_05]}}${SNOW}%f"
    print -n "%F{${colors[COLOR_06]}}${MEDIUM_RIGHT_DOUBLET} %f"

    print -n "%b"
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
        G_PROMPT_EOL_MARK+="%F{$PROMPT_EOL_MARK_MOD}$(symbol_printf "$LEFT" 15)%f"
        G_PROMPT_EOL_MARK+="%F{$REVERSE_SYSTEM_MODE} Cost: $G_ZSH_COMMAND_DURATION %f"
        G_PROMPT_EOL_MARK+="%F{$PROMPT_EOL_MARK_MOD}$(symbol_printf "$RIGHT" 15) ↩%f"
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
    RPROMPT='$(assemble_colorful_prompt_right)'

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
