#!/bin/zsh

# ===== 样式：面包屑 =====

# === 使用 git-prompt.sh ===
assemble_colorful_prompt() {

    # 颜色格式（可由 AI 生成最佳组合）
    # 用户名 | 主机 | 路径 | Git分支 | 符号 | 背景
    # 举例：_colors_str_="#BADFDB|#B4D3B2|#D0F0C0|#F4FCD9|#C0E0C0|#1A2F1D"
    _colors_str_="`get_prompt_color $MY_COLORFUL_PROMPT_COLOR_NUMBER`"
    # 颜色组合列表
    _colors_=(`split_colors $_colors_str_`)

    if [[ ${#_colors_[@]} -ne 8 ]];
    then
        # 默认样式
        USER_COLOR="%K{magenta}"
        HOST_COLOR="%K{cyan}"
        PATH_COLOR="%K{#079992}"
        GIT_COLOR="%K{#98FB98}"
        SYMBOL_COLOR="%K{#C74D55}"
        BG_COLOR="%F{#FFFDCB}"
        LEFT_COLOR="%K{#FFFDCB}"
        RIGHT_COLOR="%K{#FFFDCB}"
        RESET="%f%k"
    else
        # 动态颜色 
        USER_COLOR="$(trim ${_colors_[3]})"
        HOST_COLOR="$(trim ${_colors_[4]})"
        PATH_COLOR="$(trim ${_colors_[5]})"
        GIT_COLOR="$(trim ${_colors_[6]})"
        SYMBOL_COLOR="$(trim ${_colors_[7]})"
        BG_COLOR="$(trim ${_colors_[8]})"
        LEFT_COLOR="$(trim ${_colors_[3]})"
        RIGHT_COLOR="$(trim ${_colors_[3]})"
        RESET="%f%k"

    fi

    # 定义颜色和形状字符
    LEFT_ARROW=""  # 向左实心箭头
    RIGHT_ARROW=""  # 向右实心箭头 (需要 Powerline 字体)
    ROUND_LEFT=""   # 左侧圆角左边缘
    ROUND_RIGHT=""  # 右侧圆角右边缘

    # 定义左侧提示符
    PROMPT=' 🐞 '
    PROMPT+='%F{${LEFT_COLOR}}${ROUND_LEFT}%f' # 圆角边缘

    PROMPT+='%K{${USER_COLOR}}%F{${BG_COLOR}}%n ${RESET}'
    PROMPT+='%K{${HOST_COLOR}}%F{${USER_COLOR}}${RIGHT_ARROW}${RESET}'

    PROMPT+='%K{${HOST_COLOR}}%F{${BG_COLOR}} %M ${RESET}'
    PROMPT+='%K{${PATH_COLOR}}%F{${HOST_COLOR}}${RIGHT_ARROW}${RESET}'

    PROMPT+='%K{${PATH_COLOR}}%F{${BG_COLOR}} %c ${RESET}'

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" == "" ]];
    then
        PROMPT+='%F{${PATH_COLOR}}${RIGHT_ARROW} %f'
    else
        PROMPT+='%K{${GIT_COLOR}}%F{${PATH_COLOR}}${RIGHT_ARROW}${RESET}'
        PROMPT+='%K{${GIT_COLOR}}%F{${BG_COLOR}}%B [%b${RESET}'
        PROMPT+='%K{${GIT_COLOR}}%F{${BG_COLOR}} $(__git_ps1 "%s") ${RESET}'
        PROMPT+='%K{${GIT_COLOR}}%F{${BG_COLOR}}%B] %b${RESET}'
        PROMPT+='%F{${GIT_COLOR}}${RIGHT_ARROW} %f'  # 右三角边缘
    fi

    # 定义右侧提示符（在命令执行后显示）
    # 或者显示更详细的时间（日期+时间）
    RPROMPT=''
    RPROMPT+='%F{${SYMBOL_COLOR}}${LEFT_ARROW}%f' # 左三角边缘
    RPROMPT+='%K{${SYMBOL_COLOR}}%F{${BG_COLOR}} $(get_command_status) ${RESET}'

    RPROMPT+='%K{${SYMBOL_COLOR}}%F{${PATH_COLOR}}${LEFT_ARROW}${RESET}'
    RPROMPT+='%K{${PATH_COLOR}}%F{${USER_COLOR}} $(get_duration $ZSH_COMMAND_START_TIME) ${RESET}'

    RPROMPT+='%K{${PATH_COLOR}}%F{${USER_COLOR}}${LEFT_ARROW}${RESET}'
    RPROMPT+='%K{${USER_COLOR}}%F{${BG_COLOR}} %D{%H:%M:%S}${RESET}'
    # RPROMPT+='%K{${USER_COLOR}}%F{${BG_COLOR}} %D{%Y-%m-%d %H:%M:%S} ${RESET}'
    RPROMPT+='%F{${USER_COLOR}}${ROUND_RIGHT}%f' # 圆角边缘
}

# 设置一个标志变量
PROMPT_RESET_NEEDED=1

# # 初始化
# zmodload zsh/datetime 2>/dev/null
# typeset -g ZSH_COMMAND_DURATION=""
# typeset -g ZSH_LAST_COMMAND_START=""

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

