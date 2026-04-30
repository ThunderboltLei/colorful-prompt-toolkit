#!/bin/zsh

# ===== 默认样式 =====

# === 使用 git-prompt.sh ===
assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color
    
    # 定义左侧提示符
    PROMPT=" 🐞 "
    PROMPT+="%F{${${colors[LEFT_COLOR]}}}${ROUND_LEFT}%f" # 圆角边缘
    PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[USER_COLOR]}}}%n${${colors[RESET]}}"
    PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[SYMBOL_COLOR]}}}@${${colors[RESET]}}"
    PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[HOST_COLOR]}}}%M${${colors[RESET]}}"
    PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[SYMBOL_COLOR]}}}:${${colors[RESET]}}"
    PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[PATH_COLOR]}}}%c${${colors[RESET]}}"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" == "" ]];
    then
        PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[SYMBOL_COLOR]}}} ${${colors[RESET]}}"
    else
        PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[SYMBOL_COLOR]}}} (${${colors[RESET]}}"
        PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[GIT_COLOR]}}} $(__git_ps1 "%s") ${${colors[RESET]}}"
        PROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[SYMBOL_COLOR]}}}) ${${colors[RESET]}}"
    fi
    PROMPT+="%F{${${colors[RIGHT_COLOR]}}}${RIGHT_ARROW} %f" # 圆角边缘

    # 定义右侧提示符（在命令执行后显示）
    # 或者显示更详细的时间（日期+时间）
    RPROMPT=""
    RPROMPT+="%F{${${colors[LEFT_COLOR]}}}${LEFT_ARROW}%f" # 圆角边缘
    RPROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[SYMBOL_COLOR]}}} $(get_command_status) ${${colors[RESET]}}"
    RPROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[HOST_COLOR]}}}|${${colors[RESET]}}"
    RPROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[PATH_COLOR]}}} $(get_duration) ${${colors[RESET]}}"
    RPROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[HOST_COLOR]}}}|${${colors[RESET]}}"
    RPROMPT+="%K{${${colors[BG_COLOR]}}}%F{${${colors[USER_COLOR]}}} %D{%H:%M:%S}${${colors[RESET]}}"
    RPROMPT+="%F{${${colors[RIGHT_COLOR]}}}${ROUND_RIGHT}%f" # 圆角边缘
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
    # source $MY_COLORFUL_PROMPT_ROOT_PATH/my-colorful-prompt-toolkit.sh

    if [[ $PROMPT_RESET_NEEDED -eq 1 ]];
    then
        # === 计算时间 ===
        if [[ -n "$ZSH_LAST_COMMAND_START" ]]; then
            local end_time=$EPOCHREALTIME
            if command -v bc >/dev/null 2>&1; then
                local duration=$(echo "$end_time - $ZSH_LAST_COMMAND_START" | bc)
            else
                # 降级方案：只取整数部分
                local duration=$((end_time - ZSH_LAST_COMMAND_START))
            fi
            ZSH_COMMAND_DURATION=$(format_duration "$duration")
            ZSH_LAST_COMMAND_START=""
        else
            ZSH_COMMAND_DURATION=""
        fi

        # 重新生成完整提示符
        assemble_colorful_prompt
        PROMPT_RESET_NEEDED=0
    fi
}

