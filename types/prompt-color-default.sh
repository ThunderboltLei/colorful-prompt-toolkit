#!/bin/zsh

# ===== 默认样式 =====

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
        # 默认颜色
        USER_COLOR="%F{magenta}"
        HOST_COLOR="%F{cyan}"
        PATH_COLOR="%F{#079992}"
        GIT_COLOR="%F{#98FB98}"
        SYMBOL_COLOR="%F{#C74D55}"
        BG_COLOR="%K{#FFFDCB}"
        LEFT_COLOR="%F{#FFFDCB}"
        RIGHT_COLOR="%F{#FFFDCB}"
        RESET="%f%k"
    else
        # 动态颜色
        USER_COLOR="%F{$(trim ${_colors_[3]})}"
        HOST_COLOR="%F{$(trim ${_colors_[4]})}"
        PATH_COLOR="%F{$(trim ${_colors_[5]})}"
        GIT_COLOR="%F{$(trim ${_colors_[6]})}"
        SYMBOL_COLOR="%F{$(trim ${_colors_[7]})}"
        BG_COLOR="%K{$(trim ${_colors_[8]})}"
        LEFT_COLOR="%F{$(trim ${_colors_[8]})}"
        RIGHT_COLOR="%F{$(trim ${_colors_[8]})}"
        RESET="%f%k"
    fi

    # 定义颜色和形状字符
    LEFT_ARROW=""  # 向左实心箭头
    RIGHT_ARROW=""  # 向右实心箭头 (需要 Powerline 字体)
    ROUND_LEFT=""   # 左侧圆角左边缘
    ROUND_RIGHT=""  # 右侧圆角右边缘

    # 定义左侧提示符
    PROMPT=' 🐞 '
    PROMPT+='${LEFT_COLOR}${ROUND_LEFT}%f' # 圆角边缘
    PROMPT+='${BG_COLOR}${USER_COLOR}%n${RESET}'
    PROMPT+='${BG_COLOR}${SYMBOL_COLOR}@${RESET}'
    PROMPT+='${BG_COLOR}${HOST_COLOR}%M${RESET}'
    PROMPT+='${BG_COLOR}${SYMBOL_COLOR}:${RESET}'
    PROMPT+='${BG_COLOR}${PATH_COLOR}%c${RESET}'

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" == "" ]];
    then
        PROMPT+='${BG_COLOR}${SYMBOL_COLOR} ${RESET}'
    else
        PROMPT+='${BG_COLOR}${SYMBOL_COLOR} (${RESET}'
        PROMPT+='${BG_COLOR}${GIT_COLOR} $(__git_ps1 "%s") ${RESET}'
        PROMPT+='${BG_COLOR}${SYMBOL_COLOR}) ${RESET}'
    fi
    PROMPT+='${RIGHT_COLOR}${RIGHT_ARROW} %f' # 圆角边缘

    # 定义右侧提示符（在命令执行后显示）
    # 或者显示更详细的时间（日期+时间）
    RPROMPT=''
    RPROMPT+='${LEFT_COLOR}${LEFT_ARROW}%f' # 圆角边缘
    RPROMPT+='${BG_COLOR}${SYMBOL_COLOR} $(get_command_status) ${RESET}'
    RPROMPT+='${BG_COLOR}${HOST_COLOR}|${RESET}'
    RPROMPT+='${BG_COLOR}${PATH_COLOR} $(get_duration) ${RESET}'
    RPROMPT+='${BG_COLOR}${HOST_COLOR}|${RESET}'
    RPROMPT+='${BG_COLOR}${USER_COLOR} %D{%H:%M:%S}${RESET}'
    RPROMPT+='${RIGHT_COLOR}${ROUND_RIGHT}%f' # 圆角边缘
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

