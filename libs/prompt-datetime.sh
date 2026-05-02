# 5. 实时时间显示
format_time() {
    # 优先使用 EPOCHREALTIME（如果支持）
    if (( $+EPOCHREALTIME )); then
        date -r ${(z)EPOCHREALTIME//.*/} +"%Y-%m-%d %H:%M:%S"
    else
        date +"%H:%M:%S"
    fi
}

refresh_prompt_datetime() {
    
    # 自动刷新提示符的函数
    refresh_prompt() {
        # 刷新显示
        zle reset-prompt
    }

    # 设置定时器（秒为单位）
    TMOUT=1
    # 触发刷新
    TRAPALRM() {
        zle reset-prompt 2>/dev/null || {
            # === 重新生成完整提示符 ===
            PROMPT='$(assemble_colorful_prompt)'
            RPROMPT='$(assemble_colorful_prompt_right)'

            # 刷新显示
            zle reset-prompt
        }

        TMOUT=1  # 重新设置定时器
    }
}