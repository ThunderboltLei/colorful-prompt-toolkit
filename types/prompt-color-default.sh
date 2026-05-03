#!/bin/zsh

# ===== 默认样式 =====

# === 使用 git-prompt.sh ===

# 组装左提示符
assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color
    
    # 定义左侧提示符
    echo -n " 🐞 "
    echo -n "%F{${colors[LEFT_COLOR]}}${ROUND_LEFT}%f" # 圆角边缘
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_01]}}%n${colors[RESET]}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}}@${colors[RESET]}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_02]}}%M${colors[RESET]}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}}:${colors[RESET]}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_03]}}%c${colors[RESET]}"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" == "" ]];
    then
        echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}} ${colors[RESET]}"
    else
        echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}} (${colors[RESET]}"
        echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_04]}} $(__git_ps1 "%s") ${colors[RESET]}"
        echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}}) ${colors[RESET]}"
    fi
    echo -n "%F{${colors[RIGHT_COLOR]}}${RIGHT_ARROW} %f" # 圆角边缘
}

# 组装右提示符
assemble_colorful_prompt_right() {

    # 获取提示符颜色
    get_prompt_color

    # 定义右侧提示符（在命令执行后显示）
    # 或者显示更详细的时间（日期+时间）
    echo -n ""
    echo -n "%F{${colors[LEFT_COLOR]}}${LEFT_ARROW}%f" # 圆角边缘
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_05]}} $(get_command_status) ${colors[RESET]}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_04]}}|${${colors[RESET]}}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_02]}} $(get_duration) ${colors[RESET]}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_04]}}|${${colors[RESET]}}"
    echo -n "%K{${colors[COLOR_06]}}%F{${colors[COLOR_01]}} ⏰ $(format_time)${colors[RESET]}"
    echo -n "%F{${colors[RIGHT_COLOR]}}${ROUND_RIGHT}%f" # 圆角边缘
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
                # 降级方案：只取整数部分
                local duration=$((end_time - ZSH_LAST_COMMAND_START))
            fi
            ZSH_COMMAND_DURATION=$(format_duration "$duration")
            ZSH_LAST_COMMAND_START=""
        else
            ZSH_COMMAND_DURATION=""
        fi

        # === 重新生成完整提示符 ===
        PROMPT='$(assemble_colorful_prompt)'
        RPROMPT='$(assemble_colorful_prompt_right)'

        PROMPT_RESET_NEEDED=0
    fi
}

# 刷新提示符中时间
refresh_prompt_datetime
