#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:

# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 


# 
# Description: 将 hex 转换成 ansi
# Params:
#   param1: 颜色的 hex 形式
#   param2: 
# Result: 输出 ansi 形式
# 
hex_to_ansi() {
    local hex=${1#\#}  # 移除 #
    printf "$BEGIN%d;%d;%dm%s${RESET}" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}" "$1"
}


# 
# Description: 处理每行颜色内容
# Params:
#   param1: 行内容
#   param2: 
# Result: 输出带 ansi 形式的行内容
# 
process_color_line() {
    local line=$1
    local parts=("${(@s:|:)line}")
    local output=""
    local i=0
    
    for part in "${parts[@]}"; do
        if [[ $part =~ '^#[0-9A-Fa-f]{6}$' ]]; then
            # 添加颜色并保留原始十六进制值
            part=$(hex_to_ansi "$part")
        fi

        if [[ $i -eq 0 ]]; then
            output="$part"
        elif [[ $i -eq 1 ]]; then
            output="$output|$part\t"
        else
            output="$output|$part"
        fi

        ((i++))
    done
    
    print -P "$output"
}

# 
# Description: 处理文件内容
# Params:
#   param1: 文件路径
#   param2: 
# Result: 
# 
process_file_content() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        print -P "错误: 文件 $file 不存在"
        return 1
    fi
    
    # 逐行读取并处理
    while IFS= read -r line; do
        # 跳过空行
        [[ -z "$line" ]] && continue
        
        # # 调试输出
        # echo "处理行: $line" >&2
        
        # 处理每行内容
        process_color_line "$line"
        
        # 行间分隔符
        symbol_printf "-" 80
        
    done < "$file"
}


menu_function() {

    # 确保变量存在
    if [[ -z "$MY_COLORFUL_PROMPT_ROOT_PATH" ]]; then
        echo "错误: MY_COLORFUL_PROMPT_ROOT_PATH 未设置" >&2
        return 1
    fi
    
    local style_file="$MY_COLORFUL_PROMPT_ROOT_PATH/resources/styles/colorful-style.txt"
    
    if [[ ! -f "$style_file" ]]; then
        echo "错误: 样式文件不存在: $style_file" >&2
        return 1
    fi

    # 只在文件存在时source
    [[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.zsh"
    [[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh"
    [[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh"
    [[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-file.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-file.zsh"
    [[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-color.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-color.zsh"

    local _colors_str_="`_cpt_get_color_style $MY_COLORFUL_PROMPT_COLOR_NUMBER`"
    printf " $E_APPLE 当前配色方案：$(process_color_line $_colors_str_)\n\n"

    process_file_content "$style_file"
}


# # 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi