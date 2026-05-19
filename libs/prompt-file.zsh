#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description: 文件操作函数
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

# ===== 文件操作函数 =====

# Description: 从文件的第二行开始读取，支持按行号获取数据
# Params
#   Param1: filepath
#   Param2: row number
# Result: row content
_cpt_read_file_content_of_specified_line() {
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
    
    # 返回行内容
    echo $line
    return 0
}


# Description: 从每行的第一个 # 开始读取内容
# Param
#   Param1: file path
# Result: file content
_cpt_read_colorful_style_infos() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo "错误: 文件 $file 不存在" >&2
        return 1
    fi
    
    local _r=0
    while IFS= read -r line; do
        # 查找第一个 # 的位置
        if [[ "$line" =~ \# ]]; then
            # 提取从第一个 # 开始的内容（包括 #）
            local result="${line#*#}"
            result="#$result"  # 重新加上 # 号
            echo "$result"
        fi
    done < "$file"
}

