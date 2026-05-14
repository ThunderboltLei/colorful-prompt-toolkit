#!/bin/zsh


# === File Description ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: T6: Sentence
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
    print -n "\n"
    print -n "%B ${E_LADY_BUG} "
    print -n "%F{${colors[COLOR_01]}}%n%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}} @%f"
    print -n "%F{${colors[COLOR_02]}} %M%f"
    print -n "%F{${REVERSE_SYSTEM_MODE}} in%f"
    print -n "%F{${colors[COLOR_03]}} %~%f"

    local branch=""
    # 不在 Git 仓库时静默返回空
    branch=`__git_ps1 "%s" 2>/dev/null`

    if [[ "$branch" != "" ]];
    then
        print -n "%F{${REVERSE_SYSTEM_MODE}} on git:%f"
        print -n "%F{${colors[COLOR_04]}}$(__git_ps1 "%s")%f"
    fi
    print -n "%F{${REVERSE_SYSTEM_MODE}} as%f"
    print -n "%F{${colors[COLOR_05]}} ${SQUARE_LEFT}$(format_time)${SQUARE_RIGHT}%f"

    print -n "\n"
    print -n "%F{${REVERSE_SYSTEM_MODE}} ${TRIANGLE_RIGHT} %f"

    print -n "%b"
}

# 组装右提示符
assemble_colorful_prompt_right() {
    # skip over
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

        # echo -e "$(assemble_colorful_prompt)"

        PROMPT_RESET_NEEDED=0
    fi
}

# 刷新提示符中时间
refresh_prompt_datetime
