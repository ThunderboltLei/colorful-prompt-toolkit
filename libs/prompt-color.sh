#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:
# 
# 
# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 

# ===== 颜色函数 =====

# Description: 定义颜色输出函数
rgb_fg() {
    local r g b
    # 将 #50FA7B 转换为 RGB
    if [[ $1 =~ ^#([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$ ]]; then
        r=$((16#$match[1]))
        g=$((16#$match[2]))
        b=$((16#$match[3]))
        printf '\033[38;2;%d;%d;%dm' $r $g $b; echo
    fi
}

rgb_bg() {
    local r g b
    if [[ $1 =~ ^#([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})$ ]]; then
        r=$((16#$match[1]))
        g=$((16#$match[2]))
        b=$((16#$match[3]))
        printf '\033[48;2;%d;%d;%dm' $r $g $b; echo
    fi
}

# Description: 反转颜色
# param1: 例, #FFFFFF
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


SYSTEM_MODE=""
if [[ "$.term.mode" == "dark" ]]; then
    # 深色模式配色：使用亮色系
    # echo -e "dark"
    SYSTEM_MODE="#000000"
else
    # 浅色模式配色：使用深色系
    # echo -e "light"
    SYSTEM_MODE="#FFFFFF"
fi
REVERSE_SYSTEM_MODE=`invert_color ${SYSTEM_MODE}`


# Description: 分割颜色字符串并存储到数组
# param1: 要进行分割的字符串
split_colors() {
    local input="$1"
    local -a colors

    # 使用 : 作为分隔符进行分割
    colors=("${(@s/|/)input}")

    echo "${colors[@]}"
}

# Description: 定义去除空格函数（支持多种用法）
# param1: 要去除两端空格的字符串
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


# Description: 获取 color style
# Params:
#   param1: colorful-style.txt
#   param2: 指定的行号
# Result: 返回字符串，如"#BADFDB|#B4D3B2|#D0F0C0|#F4FCD9|#C0E0C0|#1A2F1D"
get_color_style() {
    local _rNo=$1
    local colors=`read_file_content_of_specified_line $MY_COLORFUL_PROMPT_ROOT_PATH/resources/styles/colorful-style.txt $_rNo`
    echo $colors
}


# Description: 获取颜色
# Result: 返回颜色字典
typeset -A colors
get_prompt_color() {
    
    # 颜色格式（可由 AI 生成最佳组合）
    # 用户名 | 主机 | 路径 | Git分支 | 符号 | 背景
    # 举例：_colors_str_="#BADFDB|#B4D3B2|#D0F0C0|#F4FCD9|#C0E0C0|#1A2F1D"
    local _colors_str_="`get_color_style $MY_COLORFUL_PROMPT_COLOR_NUMBER`"

    # 颜色组合列表
    local _splitted_colors_=(`split_colors $_colors_str_`)

    if [[ ${#_splitted_colors_[@]} -ne 8 ]]; then
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

