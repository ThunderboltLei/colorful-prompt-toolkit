#!/bin/zsh

# ===== 样式：面包屑 =====

# === 使用 git-prompt.sh ===
assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color

    # 定义左侧提示符
    PROMPT=" 🐞 "
    PROMPT+="%F{${${colors[USER_COLOR]}}}${ROUND_LEFT}%f" # 圆角边缘

    PROMPT+="%K{${${colors[USER_COLOR]}}}%F{${${colors[BG_COLOR]}}}%n ${${colors[RESET]}}"
    PROMPT+="%K{${${colors[HOST_COLOR]}}}%F{${${colors[USER_COLOR]}}}${RIGHT_ARROW}${${colors[RESET]}}"

    PROMPT+="%K{${${colors[HOST_COLOR]}}}%F{${${colors[BG_COLOR]}}} %M ${${colors[RESET]}}"
    PROMPT+="%K{${${colors[PATH_COLOR]}}}%F{${${colors[HOST_COLOR]}}}${RIGHT_ARROW}${${colors[RESET]}}"

    PROMPT+="%K{${${colors[PATH_COLOR]}}}%F{${${colors[BG_COLOR]}}} %c ${${colors[RESET]}}"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" == "" ]];
    then
        PROMPT+="%F{${${colors[PATH_COLOR]}}}${RIGHT_ARROW} %f"
    else
        PROMPT+="%K{${${colors[GIT_COLOR]}}}%F{${${colors[PATH_COLOR]}}}${RIGHT_ARROW}${${colors[RESET]}}"
        PROMPT+="%K{${${colors[GIT_COLOR]}}}%F{${${colors[BG_COLOR]}}}%B [%b${${colors[RESET]}}"
        PROMPT+="%K{${${colors[GIT_COLOR]}}}%F{${${colors[BG_COLOR]}}} $(__git_ps1 "%s") ${${colors[RESET]}}"
        PROMPT+="%K{${${colors[GIT_COLOR]}}}%F{${${colors[BG_COLOR]}}}%B] %b${${colors[RESET]}}"
        PROMPT+="%F{${${colors[GIT_COLOR]}}}${RIGHT_ARROW} %f"  # 右三角边缘
    fi

    # 定义右侧提示符（在命令执行后显示）
    # 或者显示更详细的时间（日期+时间）
    RPROMPT=""
    RPROMPT+="%F{${${colors[SYMBOL_COLOR]}}}${LEFT_ARROW}%f" # 左三角边缘
    RPROMPT+="%K{${${colors[SYMBOL_COLOR]}}}%F{${${colors[BG_COLOR]}}} $(get_command_status) ${${colors[RESET]}}"

    RPROMPT+="%K{${${colors[SYMBOL_COLOR]}}}%F{${${colors[PATH_COLOR]}}}${LEFT_ARROW}${${colors[RESET]}}"
    RPROMPT+="%K{${${colors[PATH_COLOR]}}}%F{${colors[USER_COLOR]}}} $(get_duration $ZSH_COMMAND_START_TIME) ${${colors[RESET]}}"

    RPROMPT+="%K{${${colors[PATH_COLOR]}}}%F{${${colors[USER_COLOR]}}}${LEFT_ARROW}${${colors[RESET]}}"
    RPROMPT+="%K{${${colors[USER_COLOR]}}}%F{${${colors[BG_COLOR]}}} %D{%H:%M:%S}${${colors[RESET]}}"
    # RPROMPT+="%K{${${colors[USER_COLOR]}}}%F{${${colors[BG_COLOR]}}} %D{%Y-%m-%d %H:%M:%S} ${${colors[RESET]}}"
    RPROMPT+="%F{${${colors[USER_COLOR]}}}${ROUND_RIGHT}%f" # 圆角边缘
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

