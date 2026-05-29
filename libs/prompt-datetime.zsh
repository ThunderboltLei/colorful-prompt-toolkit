#!/bin/zsh

# 初始化时加载模块
zmodload zsh/datetime 2>/dev/null


# Description: 显示实时时间
# Params:
#   param1: 
#   param2: 
# Result: 
# 
_cpt_format_time() {
    # 优先使用 EPOCHREALTIME（如果支持）
    if (( $+EPOCHREALTIME )); then
        # zsh 原生方式：使用内置的 strftime
        # 需要加载模块：zmodload zsh/datetime
        strftime "%H:%M:%S" "${EPOCHREALTIME%.*}"
    else
        date +"%H:%M:%S"
    fi
}


# Description: 刷新提示符中时间
# Params:
#   param1: 
#   param2: 
# Result: 
# 
refresh_prompt_datetime() {

    _refresh_loop() {

        zle reset-prompt 2>/dev/null || {
            # === 重新生成完整提示符 ===
            PROMPT='$(assemble_colorful_prompt)'
            RPROMPT='$(assemble_colorful_prompt_right)'
        }

        sched +1 _refresh_loop
    }

    _refresh_loop
}


# 
# Description: 计算命令执行时间，格式化时长（无外部依赖版本）
# Params:
#   param1: 
#   param2: 
# Result: 
# 
# 改进的格式化函数
format_duration() {
    local duration=$1
    
    # 输入验证
    if [[ -z $duration ]] || ! [[ $duration =~ ^[0-9]*\.?[0-9]+$ ]]; then
        echo "0μs"
        return
    fi
    
    # 使用 bc 进行浮点数比较
    local is_ge() {
        (( $(echo "$1 >= $2" | bc 2>/dev/null) ))
    }
    
    if is_ge $duration 3600; then
        # 小时
        local h=$(echo "$duration / 3600" | bc)
        local m=$(echo "($duration % 3600) / 60" | bc)
        local s=$(echo "$duration % 60" | bc)
        if is_ge $m 1 && is_ge $s 1; then
            printf "%dh%dm%.0fs" $h $m $s
        elif is_ge $m 1; then
            printf "%dh%dm" $h $m
        else
            printf "%dh%.0fs" $h $s
        fi
        
    elif is_ge $duration 60; then
        # 分钟
        local m=$(echo "$duration / 60" | bc)
        local s=$(echo "$duration % 60" | bc)
        if is_ge $s 1; then
            printf "%dm%.0fs" $m $s
        else
            printf "%dm" $m
        fi
        
    elif is_ge $duration 1; then
        # 秒（1-59.999）
        printf "%.2fs" $duration
        
    elif is_ge $duration 0.001; then
        # 毫秒
        local ms=$(echo "$duration * 1000" | bc)
        printf "%.0fms" $ms
        
    elif is_ge $duration 0.000001; then
        # 微秒
        local us=$(echo "$duration * 1000000" | bc)
        printf "%.0fμs" $us
        
    else
        echo "<1μs"
    fi
}


# Description: === 计算命令耗时 ===
# Params:
#   param1: 
#   param2: 
# Result: 
# 
calcu_duration(){

    if [[ -n "$G_ZSH_LAST_COMMAND_START" ]]; then
        # 读取：开始时间
        local start_time=$G_ZSH_LAST_COMMAND_START
        # 读取：结束时间
        local end_time=$EPOCHREALTIME
        # 计算耗时
        local duration=$(echo "$end_time - $start_time" | bc)

        # 赋值全局变量：耗时时长
        G_ZSH_COMMAND_DURATION="$(format_duration $duration)"

        # 赋值全局变量：清空开始时间
        G_ZSH_LAST_COMMAND_START=""
    else
        G_ZSH_COMMAND_DURATION=""
    fi
}

# Description: 将 EPOCHREALTIME 转换为可读格式（高精度）
# Params:
#   param1: 
#   param2: 
# Result: 
# 
_cpt_epoch_to_datetime() {
    local epoch=$1
    local format=${2:-"%Y-%m-%d %H:%M:%S"}
    
    local seconds=${epoch%.*}
    local nanos=${epoch#*.}
    
    # 使用 strftime（zsh 内置，最快）
    if (( $+functions[strftime] )); then
        local datetime=$(strftime "$format" $seconds)
        echo "${datetime}.${nanos:0:3}"  # 显示毫秒
    else
        # 降级方案：使用 date 命令
        local datetime=$(date -r $seconds +"$format" 2>/dev/null || date -d "@$seconds" +"$format")
        echo "${datetime}.${nanos:0:3}"
    fi
}


# Description: 将日期时间转换为 EPOCHREALTIME
# Params:
#   param1: 
#   param2: 
# Result: 
# 
_cpt_datetime_to_epoch() {
    local datetime=$1
    local seconds
    
    # macOS
    if [[ "$OSTYPE" == darwin* ]]; then
        seconds=$(date -j -f "%Y-%m-%d %H:%M:%S" "$datetime" +"%s" 2>/dev/null)
    else
        # Linux
        seconds=$(date -d "$datetime" +"%s" 2>/dev/null)
    fi
    
    # 添加纳秒部分（默认 .000000000）
    echo "${seconds}.000000000"
}
