#!/bin/zsh

# ===== 样式：面包屑 =====

# === 使用 git-prompt.sh ===
assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color

    # 定义左侧提示符
    # === user ===
    PROMPT="%F{${${colors[COLOR_01]}}}${ROUND_LEFT}%f" # 圆角边缘
    PROMPT+="%K{${${colors[COLOR_01]}}}%F{${${colors[COLOR_06]}}}🍏 %n ${${colors[RESET]}}"
    # === path ===
    PROMPT+="%K{${${colors[COLOR_02]}}}%F{${${colors[COLOR_01]}}}${RIGHT_ARROW}${${colors[RESET]}}"
    PROMPT+="%K{${${colors[COLOR_02]}}}%F{${${colors[COLOR_06]}}} %c ${${colors[RESET]}}"

    # === github ===
    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`
    if [[ "$branch" == "" ]];
    then
        PROMPT+="%K{${${colors[COLOR_03]}}}%F{${${colors[COLOR_02]}}}${RIGHT_ARROW}${${colors[RESET]}}"
    else
        PROMPT+="%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_02]}}}${RIGHT_ARROW}${${colors[RESET]}}"
        PROMPT+="%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_06]}}}%B${SQUARE_LEFT}%b${${colors[RESET]}}"
        PROMPT+="%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_06]}}}$(__git_ps1 "%s")${${colors[RESET]}}"
        PROMPT+="%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_06]}}}%B${SQUARE_RIGHT}%b${${colors[RESET]}}"
        PROMPT+="%K{${${colors[COLOR_03]}}}%F{${${colors[COLOR_04]}}}${RIGHT_ARROW}${${colors[RESET]}}"
    fi

    # === datetime ===
    PROMPT+="%K{${${colors[COLOR_03]}}}%F{${${colors[COLOR_06]}}} ⏰ %D{%H:%M:%S}${${colors[RESET]}}"
    PROMPT+="%F{${${colors[COLOR_03]}}}${ROUND_RIGHT} %f"

    PROMPT+=$'\n'

    PROMPT+="%F{${${colors[COLOR_05]}}}%B${GREATER_THAN}%b%f"
}

# 设置一个标志变量
PROMPT_RESET_NEEDED=1

# 命令执行前
preexec() {
    PROMPT_RESET_NEEDED=1

    # === 计算时间 ===
    ZSH_LAST_COMMAND_START=$EPOCHREALTIME
}

# 命令执行后恢复完整样式
precmd() {
    
    if [[ $PROMPT_RESET_NEEDED -eq 1 ]];
    then

        # === 计算时间 ===
        if [[ -n "$ZSH_LAST_COMMAND_START" ]]; then
            local end_time=$EPOCHREALTIME
            if command -v bc >/dev/null 2>&1; then
                local duration=$(echo "$end_time - $ZSH_LAST_COMMAND_START" | bc)
            else
                # 只取整数部分
                local duration=$((end_time - ZSH_LAST_COMMAND_START))
            fi
            ZSH_COMMAND_DURATION=$(format_duration "$duration")
            ZSH_LAST_COMMAND_START=""
        else
            ZSH_COMMAND_DURATION=""
        fi

        # === 重新生成完整提示符 ===
        assemble_colorful_prompt

        PROMPT_RESET_NEEDED=0
    fi
}

