#!/bin/zsh

# ===== 样式：面包屑 =====

# === 使用 git-prompt.sh ===

# 组装左提示符
assemble_colorful_prompt() {

    # 获取提示符颜色
    get_prompt_color

    # 定义左侧提示符
    echo -n " 🍏 "
    # === user ===
    echo -n "%F{${${colors[COLOR_01]}}}${ROUND_LEFT}%f" # 圆角边缘
    echo -n "%K{${${colors[COLOR_01]}}}%F{${${colors[COLOR_06]}}}👤 %n ${${colors[RESET]}}"
    # === path ===
    echo -n "%K{${${colors[COLOR_02]}}}%F{${${colors[COLOR_01]}}}${RIGHT_ARROW}${${colors[RESET]}}"
    echo -n "%K{${${colors[COLOR_02]}}}%F{${${colors[COLOR_06]}}} 📂 %c ${${colors[RESET]}}"

    # === github ===
    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`
    if [[ "$branch" == "" ]];
    then
        echo -n "%K{${${colors[COLOR_03]}}}%F{${${colors[COLOR_02]}}}${RIGHT_ARROW}${${colors[RESET]}}"
    else
        echo -n "%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_02]}}}${RIGHT_ARROW}${${colors[RESET]}}"
        echo -n "%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_06]}}} 🔀 %B${SQUARE_LEFT}%b${${colors[RESET]}}"
        echo -n "%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_06]}}}$(__git_ps1 "%s")${${colors[RESET]}}"
        echo -n "%K{${${colors[COLOR_04]}}}%F{${${colors[COLOR_06]}}}%B${SQUARE_RIGHT}%b${${colors[RESET]}}"
        echo -n "%K{${${colors[COLOR_03]}}}%F{${${colors[COLOR_04]}}}${RIGHT_ARROW}${${colors[RESET]}}"
    fi

    # === datetime ===
    echo -n "%K{${${colors[COLOR_03]}}}%F{${${colors[COLOR_06]}}} ⏰ $(format_time)${${colors[RESET]}}"
    echo -n "%F{${${colors[COLOR_03]}}}${ROUND_RIGHT} %f"

    echo -n $'\n'

    echo -n "%F{${${colors[COLOR_05]}}}%B${GREATER_THAN}%b%f"
}

# 组装右提示符
assemble_colorful_prompt_right() {
    # skip over
}

# 设置一个标志变量
PROMPT_RESET_NEEDED=1

# 命令执行前
preexec() {
}

# 命令执行后恢复完整样式
precmd() {
    # === 重新生成完整提示符 ===
    PROMPT='$(assemble_colorful_prompt)'
    RPROMPT='$(assemble_colorful_prompt_right)'
}


# 刷新提示符中时间
refresh_prompt_datetime
