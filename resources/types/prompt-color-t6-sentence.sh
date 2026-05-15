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
}

# 命令执行后恢复完整样式
precmd() {

    if [[ $PROMPT_RESET_NEEDED -eq 1 ]];
    then

        # === 重新生成完整提示符 ===
        PROMPT='$(assemble_colorful_prompt)'
        RPROMPT='$(assemble_colorful_prompt_right)'

        PROMPT_RESET_NEEDED=0
    fi
}

# 刷新提示符中时间
if [[ $MY_COLORFUL_PROMPT_REFRESH_DATETIME -eq 1 ]]; then
    refresh_prompt_datetime
fi
