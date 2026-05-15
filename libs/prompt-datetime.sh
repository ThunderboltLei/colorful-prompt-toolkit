#!/bin/zsh

# 初始化时加载模块
zmodload zsh/datetime 2>/dev/null


# 显示实时时间
format_time() {
    # 优先使用 EPOCHREALTIME（如果支持）
    if (( $+EPOCHREALTIME )); then
        # zsh 原生方式：使用内置的 strftime
        # 需要加载模块：zmodload zsh/datetime
        strftime "%H:%M:%S" "${EPOCHREALTIME%.*}"
    else
        date +"%H:%M:%S"
    fi
}


# 刷新提示符中时间
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


# 计算命令执行时间
# 格式化时长（无外部依赖版本）
format_duration() {
    local duration=$1
    local int_part=${duration%.*}
    local frac_part=${duration#*.}
    
    if [[ $int_part -ge 3600 ]]; then
        local hours=$((int_part / 3600))
        local minutes=$(((int_part % 3600) / 60))
        echo "${E_CLOCK} ${hours}h${minutes}m"
    elif [[ $int_part -ge 60 ]]; then
        local minutes=$((int_part / 60))
        local seconds=$((int_part % 60))
        echo "${E_CLOCK} ${minutes}m${seconds}s"
    elif [[ $int_part -ge 1 ]]; then
        echo "${E_CLOCK} ${int_part}.${frac_part:0:1}s"
    elif [[ $duration != 0.* ]]; then
        local ms=$(printf "%.0f" $(echo "$duration * 1000" | bc 2>/dev/null || echo "0"))
        if [[ $ms -gt 0 ]]; then
            echo "${E_CLOCK} ${ms}ms"
        else
            local us=$(printf "%.0f" $(echo "$duration * 1000000" | bc 2>/dev/null || echo "0"))
            echo "${E_CLOCK} ${us}μs"
        fi
    else
        echo "${E_CLOCK} <1ms"
    fi
}


# 获取时长的函数
get_duration() {
    if [[ -z $ZSH_COMMAND_DURATION ]]; then
        echo "${E_WATCH} <1ms"
    else
        echo "$ZSH_COMMAND_DURATION"
    fi
}


# === 计算命令耗时 ===
calu_duration(){
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
}
