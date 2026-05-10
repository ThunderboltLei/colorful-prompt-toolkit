# # ~/.zshrc

# # 启用提示符替换
# setopt prompt_subst

# # 格式化函数
# format_time() {
#     date +"%H:%M:%S"
# }

# # 定义提示符（每次刷新时重新求值）
# PROMPT='%F{cyan}$(format_time)%f %F{green}%n%f@%F{yellow}%m%f:%F{blue}%~%f %(?.%F{green}.%F{red})❯%f '

# # 自动刷新提示符的函数
# update_prompt() {
#     zle reset-prompt
# }

# # 设置定时器（秒为单位）
# TMOUT=1

# # 触发刷新
# TRAPALRM() {
#     update_prompt
#     TMOUT=1  # 重新设置定时器
# }

# # 预执行函数（执行命令前清除定时器）
# preexec() {
#     TMOUT=0
# }

# # 命令执行完成后重新启动定时器
# precmd() {
#     TMOUT=1  # 每次显示新提示符后重新开始倒计时
# }

# ~/.zshrc

format_time() {
    date +"%H:%M:%S"
}

# 将 PROMPT 定义为一个函数
prompt_function() {
    echo -n "%F{cyan}$(format_time)%f "
    echo -n "%F{green}%n%f@%F{yellow}%m%f"
    echo -n ":%F{blue}%~%f "
    echo -n "%(?.%F{green}.%F{red})❯%f "
}

# 在 precmd 中设置 PROMPT
precmd() {
    PROMPT='$(prompt_function)'
}

# 刷新函数（在需要时调用）
refresh_prompt() {
    # zle -R  # 刷新显示
    # 或者
    zle reset-prompt
}

# 设置定时刷新（示例：每秒更新）
TMOUT=1
TRAPALRM() {
    zle reset-prompt 2>/dev/null || {
        # 如果失败，手动更新
        PROMPT='$(prompt_function)'
        # zle -R  # 刷新显示
        # 或者
        zle reset-prompt

    }
    TMOUT=1
}