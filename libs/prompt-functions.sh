#!/bin/zsh

# ===== 公共函数 =====

invert_color() {
  local hex=${1#"#"}
  local r=${hex:0:2}
  local g=${hex:2:2}
  local b=${hex:4:2}
  local r_inv=$(( 255 - 16#${r} ))
  local g_inv=$(( 255 - 16#${g} ))
  local b_inv=$(( 255 - 16#${b} ))
  echo "#%02X%02X%02X\n" $r_inv $g_inv $b_inv
}

# 分割颜色字符串并存储到数组
split_colors() {
    local input="$1"
    local -a colors

    # 使用 : 作为分隔符进行分割
    colors=("${(@s/|/)input}")

    echo "${colors[@]}"
}

# 定义去除空格函数（支持多种用法）
trim() {
    local str="$1"
    
    # 如果没有参数，从标准输入读取
    if [[ -z "$str" ]]; then
        str="$(cat)"
    fi
    
    # 去除首尾空白字符（空格、制表符、换行等）
    # ${var##pattern}  去除最长的匹配前缀
    # ${var%%pattern}  去除最长的匹配后缀
    str="${str##*([[:space:]])}"
    str="${str%%*([[:space:]])}"

    echo "$str"
}


# # 从每行的第一个 # 开始读取内容
# read_colorful_style_infos() {
#     local file="$1"
    
#     if [[ ! -f "$file" ]];
#     then
#         echo "错误: 文件 $file 不存在" >&2
#         return 1
#     fi
    
#     local _r = 0
#     while IFS= read -r line;
#     do
#         # 查找第一个 # 的位置
#         if [[ "$line" =~ \# ]];
#         then
#             # 提取从第一个 # 开始的内容（包括 #）
#             local result="${line#*#}"
#             result="#$result"  # 重新加上 # 号
#             echo "$result"
#         fi
#     done < "$file"
# }

# 从文件的第二行开始读取，支持按行号获取数据
read_colorful_style_infos() {
    local file="$1"
    local target_line="$2"  # 可选：要获取的行号
    
    # 检查文件是否存在
    if [[ ! -f "$file" ]]; then
        echo "错误: 文件 $file 不存在" >&2
        return 1
    fi
    
    # 检查文件是否至少有一行
    local line_count=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
    if [[ $line_count -lt 1 ]]; then
        echo "错误: 文件 $file 为空" >&2
        return 1
    fi
    
    # 检查第一行是否为标题行（非空）
    local header_line=$(head -n 1 "$file")
    if [[ -z "$header_line" ]]; then
        echo "错误: 文件 $file 的第一行为空，需要有标题行" >&2
        return 1
    fi
    
    # 如果没有指定行号，返回总行数（不包括标题行）
    if [[ -z "$target_line" ]]; then
        echo $((line_count - 1))  # 返回数据行数
        return 0
    fi
    
    # 检查行号是否为有效数字
    if [[ ! "$target_line" =~ ^[0-9]+$ ]]; then
        echo "错误: 行号必须是正整数" >&2
        return 1
    fi
    
    # 检查行号是否超出范围
    if [[ $target_line -gt $line_count ]]; then
        echo "错误: 行号 $target_line 超出范围，共有 $line_count 行数据" >&2
        return 1
    fi
    
    # 读取指定行
    local line=$(sed -n "$((target_line + 1))p" "$file")
    
    # # 提取从第一个 # 开始的内容
    # if [[ "$line" =~ \# ]]; then
    #     # 提取从第一个 # 开始的内容（包括 #）
    #     local result="${line#*#}"
    #     result="#$result"  # 重新加上 # 号
    #     echo "$result"
    #     return 0
    # else
    #     # 如果没有 #，返回整行
    #     echo "$line"
    #     return 0
    # fi
    echo $line
    return 0
}

# 获取 color style
get_color_style() {
    local _rNo=$1
    local colors=`read_colorful_style_infos $MY_COLORFUL_PROMPT_ROOT_PATH/styles/colorful-style.txt $_rNo`
    echo $colors
}

# 定义 precmd 函数
get_command_status() {
    # 获取上一条命令的返回状态
    local _exit_code_=$?
    
    # 使用返回状态
    if [[ $_exit_code_ -eq 0 ]]; then
        echo "${CORRECT}"
        # echo "🟢"
    else
        echo "${WRONG}"
        # echo "🔴"
    fi
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
        echo "⏰ ${hours}h${minutes}m"
    elif [[ $int_part -ge 60 ]]; then
        local minutes=$((int_part / 60))
        local seconds=$((int_part % 60))
        echo "⏰ ${minutes}m${seconds}s"
    elif [[ $int_part -ge 1 ]]; then
        echo "⏰ ${int_part}.${frac_part:0:1}s"
    elif [[ $duration != 0.* ]]; then
        local ms=$(printf "%.0f" $(echo "$duration * 1000" | bc 2>/dev/null || echo "0"))
        if [[ $ms -gt 0 ]]; then
            echo "⏰ ${ms}ms"
        else
            local us=$(printf "%.0f" $(echo "$duration * 1000000" | bc 2>/dev/null || echo "0"))
            echo "⏰ ${us}μs"
        fi
    else
        echo "⏰ <1ms"
    fi
}

# 获取时长的函数
get_duration() {

    if [[ -z $ZSH_COMMAND_DURATION ]];
    then
        echo "⏱️ <1ms"
    else
        echo "$ZSH_COMMAND_DURATION"
    fi
}

# 获取颜色
typeset -A colors
get_prompt_color() {
    

    # 颜色格式（可由 AI 生成最佳组合）
    # 用户名 | 主机 | 路径 | Git分支 | 符号 | 背景
    # 举例：_colors_str_="#BADFDB|#B4D3B2|#D0F0C0|#F4FCD9|#C0E0C0|#1A2F1D"
    local _colors_str_="`get_color_style $MY_COLORFUL_PROMPT_COLOR_NUMBER`"

    # 颜色组合列表
    local _splitted_colors_=(`split_colors $_colors_str_`)

    if [[ ${#_splitted_colors_[@]} -ne 8 ]];
    then
        # 默认颜色
        colors[COLOR_01]="magenta"
        colors[COLOR_02]="cyan"
        colors[COLOR_03]="#079992"
        colors[COLOR_04]="#98FB98}"
        colors[COLOR_05]="#C74D55"
        colors[COLOR_06]="#FFFDCB}" # bg_color
        colors[LEFT_COLOR]="#FFFDCB"
        colors[RIGHT_COLOR]="#FFFDCB"
        colors[RESET]="%f%k"
    else
        # 动态颜色
        colors[COLOR_01]="$(trim ${_splitted_colors_[3]})"
        colors[COLOR_02]="$(trim ${_splitted_colors_[4]})"
        colors[COLOR_03]="$(trim ${_splitted_colors_[5]})"
        colors[COLOR_04]="$(trim ${_splitted_colors_[6]})"
        colors[COLOR_05]="$(trim ${_splitted_colors_[7]})"
        colors[COLOR_06]="$(trim ${_splitted_colors_[8]})"
        colors[LEFT_COLOR]="$(trim ${_splitted_colors_[8]})"
        colors[RIGHT_COLOR]="$(trim ${_splitted_colors_[8]})"
        colors[RESET]="%f%k"
    fi

    return 0
}