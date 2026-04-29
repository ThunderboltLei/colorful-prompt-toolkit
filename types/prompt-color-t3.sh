#!/bin/zsh

# ===== 样式：面包屑 =====

# 加载公共函数
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-functions.sh

PROMPT=' 🐞 '
RPROMPT=''

# ===== 使用 git-prompt.sh =====
assemble_colorful_prompt() {

    P1="$1"
    echo "P1: $P1"

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
    # PROMPT=' 🐞 '
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
    # RPROMPT=''
    RPROMPT+='%F{${SYMBOL_COLOR}}${LEFT_ARROW}%f' # 左三角边缘
    # RPROMPT+='%K{${SYMBOL_COLOR}}%F{${BG_COLOR}} %D{%Y-%m-%d %H:%M:%S} $(get_command_status)${RESET}'
    RPROMPT+='%K{${SYMBOL_COLOR}}%F{${BG_COLOR}} %D{%Y-%m-%d %H:%M:%S} $P1${RESET}'
    RPROMPT+='%F{${SYMBOL_COLOR}}${ROUND_RIGHT}%f' # 圆角边缘
}

# 重新生成完整提示符
assemble_colorful_prompt "🎨"

# 设置一个标志变量
PROMPT_RESET_NEEDED=1

# # 命令执行前
# preexec() {

#     PROMPT_RESET_NEEDED=1

#     last_cmd=$(fc -ln -1)
#     echo -e "上一条命令：$last_cmd"
#     output=$(eval "$last_cmd" 2>&1)
#     exit_code=$(get_command_status)
    

#     local status_text="$1"
#     local status_color="$2"
    
#     # 保存光标位置
#     tput sc
#     # 向上移动一行
#     tput cuu1
#     # 清除当前行
#     tput el
#     # 输出状态
#     RPROMPT=''
#     RPROMPT+='%F{${SYMBOL_COLOR}}${LEFT_ARROW}%f' # 左三角边缘
#     RPROMPT+='%K{${SYMBOL_COLOR}}%F{${BG_COLOR}} %D{%Y-%m-%d %H:%M:%S} $(get_command_status)${RESET}'
#     RPROMPT+='%F{${SYMBOL_COLOR}}${ROUND_RIGHT}%f' # 圆角边缘
#     # echo "$exit_code"
#     # 恢复光标位置
#     tput rc
# }

# # 命令执行后恢复完整样式
# precmd() {
    
#     if [[ $PROMPT_RESET_NEEDED -eq 1 ]];
#     then

#         # # 重新生成完整提示符
#         # assemble_colorful_prompt

#         PROMPT_RESET_NEEDED=0

#     fi
# }

# ===== demo 01 =====
# typeset -g _last_command_status=""

# # 预执行钩子：在命令执行前更新提示符
# preexec() {
#     local cmd="$1"
    
#     # 保存当前命令到全局变量
#     _last_command_status="[$(date +%H:%M:%S)] $cmd"
    
#     # 使用转义序列向上移动一行并覆盖
#     print -n "\033[1A\033[K"  # 向上移动一行并清除
#     echo -n "▶ 执行中: $cmd"
#     print -n "\033[1B"        # 向下移动回来
# }

# # 命令执行后的钩子
# precmd() {
#     # 再次覆盖上一行的状态
#     print -n "\033[1A\033[K"
#     last_cmd=$(fc -ln -1)
#     echo -e "上一条命令：$last_cmd"
#     output=$(eval "$last_cmd" 2>&1)
#     exit_code=$?
#     echo -e "exit_code: $exit_code "
#     if [[ $exit_code -eq 0 ]];
#     then
#         echo -n "✅ 完成: $_last_command_status"
#     else
#         echo -n "❌ 失败: $_last_command_status"
#     fi
#     print -n "\033[1B"
    
#     # 正常显示新的提示符
#     # 这里保持原有的提示符逻辑
# }

# ===== demo 02 =====
# # 全局变量
# typeset -g _current_command=""
# typeset -g _command_start_time=""
# typeset -g _command_pid=""

# # 自定义提示符（示例）
# PROMPT='%{$fg[cyan]%}%n@%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%} $(git_branch)%{$reset_color%}
# %{$fg[green]%}❯%{$reset_color%} '

# # 获取 Git 分支（示例函数）
# git_branch() {
#     local branch=$(git branch 2>/dev/null | grep '^*' | sed 's/* //')
#     if [[ -n "$branch" ]]; then
#         echo "%{$fg[blue]%}($branch)%{$reset_color%}"
#     fi
# }

# # 更新上一行状态
# update_status_line() {
#     local status_text="$1"
#     local status_color="$2"
    
#     # 保存光标位置
#     tput sc
#     # 向上移动一行
#     tput cuu1
#     # 清除当前行
#     tput el
#     # 输出状态
#     echo -n "%{$fg[$status_color]%}$status_text%{$reset_color%}"
#     # 恢复光标位置
#     tput rc
# }

# # 命令执行前的钩子
# preexec() {
#     _current_command="$1"
#     _command_start_time=$(date +%s)
    
#     # 更新状态为"运行中"
#     update_status_line "⚡ 运行中: $_current_command" "yellow"
# }

# # 命令执行后的钩子
# precmd() {
#     local exit_code=$?
#     local duration=$(($(date +%s) - _command_start_time))
    
#     # 格式化耗时
#     local duration_str=""
#     if [[ $duration -lt 60 ]]; then
#         duration_str="${duration}s"
#     elif [[ $duration -lt 3600 ]]; then
#         duration_str="$((duration/60))m $((duration%60))s"
#     else
#         duration_str="$((duration/3600))h $(((duration%3600)/60))m"
#     fi
    
#     # 根据退出码确定状态
#     if [[ $exit_code -eq 0 ]]; then
#         update_status_line "✅ 完成: $_current_command (耗时: $duration_str)" "green"
#     else
#         update_status_line "❌ 失败: $_current_command (退出码: $exit_code, 耗时: $duration_str)" "red"
#     fi
    
#     # 重置变量
#     _current_command=""
#     _command_start_time=""
# }

# ===== demo 03 =====
# 美观的右提示符配置
update_right_prompt() {
    local exit_code=$?
    
    # 时间戳（24小时制）
    local time_str="%F{240}%T%f"
    
    # 命令状态
    if [[ $exit_code -eq 0 ]]; then
        # 成功：绿色的对勾
        local status_str="%F{green}❯%f"
    else
        # 失败：红色的叉号和错误码
        local status_str="%F{red}✗ $exit_code%f"
    fi
    
    # 合并右提示符
    RPROMPT="${status_str} ${time_str}"
}

# 可选：显示命令执行时间但不超过3秒的优雅显示
preexec() {
    cmd_start_time=$(date +%s%N)
}

update_right_prompt_with_duration() {
    local exit_code=$?
    local duration=""
    
    # 计算执行时间
    if [[ -n $cmd_start_time ]]; then
        local end_time=$(date +%s%N)
        local elapsed=$(((end_time - cmd_start_time) / 1000000))  # 转换为毫秒
        
        if [[ $elapsed -ge 1000 ]]; then
            local sec=$((elapsed / 1000))
            local ms=$((elapsed % 1000))
            if [[ $sec -ge 60 ]]; then
                local min=$((sec / 60))
                sec=$((sec % 60))
                duration="%F{244}${min}m${sec}s%f "
            elif [[ $sec -ge 1 ]]; then
                duration="%F{244}${sec}.${ms}s%f "
            else
                duration="%F{244}${elapsed}ms%f "
            fi
        elif [[ $elapsed -gt 10 ]]; then
            duration="%F{244}${elapsed}ms%f "
        fi
        unset cmd_start_time
    fi
    
    # 时间
    local time_str="%F{240}%T%f"
    
    # 状态
    if [[ $exit_code -eq 0 ]]; then
        local status_str="%F{green}●%f"
    else
        local status_str="%F{red}● $exit_code%f"
    fi
    
    RPROMPT="${duration}${status_str} ${time_str}"
}

# 选择使用哪个版本
autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd update_right_prompt_with_duration



