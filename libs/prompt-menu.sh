#!/bin/zsh

# 检查 zsh 版本
if [[ $ZSH_VERSION != 5.9* ]]; then
    echo "Warning: designed for zsh 5.9, current version $ZSH_VERSION"
fi

source $MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.sh

# 定义每个菜单项对应的详细内容 (使用 zsh 兼容的关联数组)
typeset -A details
# 使用索引遍历
for i in {1..${#MENU_ITEMS[@]}}; do
    details["${MENU_ITEMS[i]}"]="${ORDER_ITEMS[i]}"
done

# 滚动状态变量
scroll_offset_x=0          # 横向滚动偏移量
scroll_offset_y=0          # 纵向滚动偏移量
detail_lines=()            # 存储分解成行的详细内容
max_line_length=0          # 最长行的长度

# 终端尺寸变量
current_term_height=0
current_term_width=0

# 全局变量保存当前选中的菜单项
selected=1

# 优化的清屏函数 - 无闪烁
optimized_clear() {
    # 使用更高效的清屏方式
    printf '\033[2J'      # 清空整个屏幕
    printf '\033[H'       # 移动光标到首页
}

# 清理屏幕缓冲区（包括滚动缓冲区）
clear_buffer() {
    # 清空主屏幕缓冲区
    printf '\033[2J'
    printf '\033[H'
    
    # 清空滚动缓冲区（扩展终端功能）
    printf '\033[3J'
    
    # 重置光标位置
    printf '\033[1;1H'
}

# 完全重置屏幕（无闪烁版本）
full_screen_reset() {
    # 保存屏幕状态
    printf '\033[?1049h'
    
    # 清空屏幕
    printf '\033[2J\033[H'
    
    # 清空滚动缓冲区
    printf '\033[3J'
    
    # 重置所有属性
    printf '\033[0m'
    
    # 隐藏光标（临时）
    printf '\033[?25l'
}

# 恢复屏幕状态
restore_screen() {
    # 显示光标
    printf '\033[?25h'
    
    # 恢复屏幕状态
    printf '\033[?1049l'
}

# 将详细内容分解为多行
prepare_detail_lines() {
    local content="$1"
    
    # 清空之前的缓存
    detail_lines=()
    max_line_length=0
    
    # 处理空内容
    if [[ -z "$content" ]]; then
        detail_lines=("")
        max_line_length=0
        return
    fi
    
    # 按行分割内容
    while IFS= read -r line; do
        detail_lines+=("$line")
        local line_len=${#line}
        if [[ $line_len -gt $max_line_length ]]; then
            max_line_length=$line_len
        fi
    done <<< "$content"
    
    # 如果没有内容，至少添加一行
    if [[ ${#detail_lines[@]} -eq 0 ]]; then
        detail_lines=("")
        max_line_length=0
    fi
}

# 绘制滚动条
draw_scrollbar() {
    local current_pos=$1
    local total_items=$2
    local visible_height=$3
    local x_pos=$4
    local y_start=$5
    
    if [[ $total_items -le $visible_height ]]; then
        return
    fi
    
    local thumb_size=$(( (visible_height * visible_height) / total_items ))
    [[ $thumb_size -lt 1 ]] && thumb_size=1
    
    local max_pos=$((total_items - visible_height))
    local thumb_pos=0
    if [[ $max_pos -gt 0 ]]; then
        thumb_pos=$(( (current_pos * (visible_height - thumb_size)) / max_pos ))
    fi
    
    for ((i=0; i<visible_height; i++)); do
        printf '\033[%d;%dH' $((y_start + i)) $x_pos
        if [[ $i -ge $thumb_pos && $i -lt $((thumb_pos + thumb_size)) ]]; then
            printf '\033[1;37m█'
        else
            printf '\033[1;30m│'
        fi
    done
}

# 绘制横向滚动条
draw_horizontal_scrollbar() {
    local content_width=$1
    local visible_width=$2
    local y_pos=$3
    
    if [[ $content_width -le $visible_width ]]; then
        return
    fi
    
    local thumb_size=$(( (visible_width * visible_width) / content_width ))
    [[ $thumb_size -lt 1 ]] && thumb_size=1
    
    local max_scroll=$((content_width - visible_width))
    local thumb_pos=$(( (scroll_offset_x * (visible_width - thumb_size)) / max_scroll ))
    
    printf '\033[%d;1H' $y_pos
    printf '\033[2K'
    printf '\033[1;30m'
    for ((i=0; i<visible_width; i++)); do
        if [[ $i -ge $thumb_pos && $i -lt $((thumb_pos + thumb_size)) ]]; then
            printf '\033[1;37m─'
        else
            printf '\033[1;30m─'
        fi
    done
    printf '\033[0m'
}

# 检查终端尺寸是否变化
check_and_resize() {
    local new_height=$(tput lines)
    local new_width=$(tput cols)
    
    if [[ $new_height -ne $current_term_height || $new_width -ne $current_term_width ]]; then
        current_term_height=$new_height
        current_term_width=$new_width
        return 0
    fi
    return 1
}

# 绘制界面
draw() {
    local selected_idx=$1
    local term_height=$(tput lines)
    local term_width=$(tput cols)
    
    # 更新当前尺寸
    current_term_height=$term_height
    current_term_width=$term_width
    
    local left_width=30
    local right_start=$((left_width + 2))
    local right_width=$((term_width - left_width - 5))
    
    # 确保右侧有足够宽度
    if [[ $right_width -lt 10 ]]; then
        right_width=10
    fi
    
    # 准备当前选择的详细内容
    prepare_detail_lines "${details[\"${MENU_ITEMS[selected_idx]}\"]}"
    
    # 确保滚动偏移量在有效范围内
    local total_lines=${#detail_lines[@]}
    local content_start_line=3
    local content_height=$((term_height - 5))
    
    if [[ $content_height -lt 1 ]]; then
        content_height=1
    fi
    
    # 纵向滚动范围检查
    local max_scroll_y=$((total_lines - content_height))
    if [[ $max_scroll_y -lt 0 ]]; then
        max_scroll_y=0
    fi
    
    if [[ $scroll_offset_y -gt $max_scroll_y ]]; then
        scroll_offset_y=$max_scroll_y
    fi
    if [[ $scroll_offset_y -lt 0 ]]; then
        scroll_offset_y=0
    fi
    
    # 横向滚动范围
    local max_scroll_x=$((max_line_length - right_width))
    if [[ $max_scroll_x -lt 0 ]]; then
        max_scroll_x=0
    fi
    if [[ $scroll_offset_x -gt $max_scroll_x ]]; then
        scroll_offset_x=$max_scroll_x
    fi
    if [[ $scroll_offset_x -lt 0 ]]; then
        scroll_offset_x=0
    fi
    
    # 使用优化的清屏方式
    optimized_clear
    
    # 清空滚动缓冲区（但不影响当前显示）
    printf '\033[3J' 2>/dev/null
    
    # 隐藏光标并关闭自动换行
    printf '\033[?25l\033[?7l'
    
    # 绘制标题栏
    printf '\033[1;33m'
    printf " %-$(($left_width-1))s" "MENU"
    printf "│"
    printf " %-$(($right_width-1))s" "DETAILS"
    printf '\033[0m\n'
    
    # 绘制顶部边框线
    printf '\033[1;30m'
    for ((i=0; i<left_width; i++)); do
        printf '─'
    done
    printf "┼"
    for ((i=0; i<right_width; i++)); do
        printf '─'
    done
    printf '\033[0m\n'
    
    # 绘制左侧菜单区域和右侧内容
    local start_line=$scroll_offset_y
    local end_line=$((start_line + content_height))
    [[ $end_line -gt $total_lines ]] && end_line=$total_lines
    
    for ((line=0; line<content_height; line++)); do
        local current_y=$((content_start_line + line))
        
        # 定位到当前行开头
        printf '\033[%d;1H' $current_y
        
        # 绘制左侧菜单区域
        if [[ $line -lt ${#MENU_ITEMS[@]} ]]; then
            local i=$((line + 1))
            if [[ $i -eq $selected_idx ]]; then
                printf '\033[1;7;32m'
                printf " %-$(($left_width-1))s" "${MENU_ITEMS[i]}"
                printf '\033[0m'
            else
                printf " %-$(($left_width-1))s" "${MENU_ITEMS[i]}"
            fi
        else
            printf " %-$(($left_width-1))s" " "
        fi
        
        # 绘制右边框
        printf "│"
        
        # 绘制右侧内容
        if [[ $line -lt $((end_line - start_line)) ]]; then
            local content_index=$((start_line + line))
            if [[ $content_index -lt $total_lines ]]; then
                local display_line="${detail_lines[content_index + 1]}"
                if [[ ${#display_line} -gt $scroll_offset_x ]]; then
                    display_line="${display_line:$scroll_offset_x:$right_width}"
                else
                    display_line=""
                fi
                printf "%-${right_width}s" "$display_line"
            else
                printf "%${right_width}s" ""
            fi
        else
            printf "%${right_width}s" ""
        fi
        
        # 清理行尾残留
        printf '\033[K'
    done
    
    # 恢复自动换行
    printf '\033[?7h'
    
    # 绘制垂直滚动条
    if [[ $total_lines -gt $content_height ]]; then
        draw_scrollbar $scroll_offset_y $total_lines $content_height \
            $((right_start + right_width + 1)) $content_start_line
        # 清理滚动条右侧区域
        local scrollbar_x=$((right_start + right_width + 2))
        for ((i=0; i<content_height; i++)); do
            printf '\033[%d;%dH' $((content_start_line + i)) $scrollbar_x
            printf '\033[K'
        done
    else
        # 清理滚动条位置
        local scrollbar_x=$((right_start + right_width + 1))
        for ((i=0; i<content_height; i++)); do
            printf '\033[%d;%dH' $((content_start_line + i)) $scrollbar_x
            printf '\033[K'
        done
    fi
    
    # 绘制底部边框线
    printf '\033[%d;1H' $((term_height - 1))
    printf '\033[2K'
    printf '\033[1;30m'
    for ((i=0; i<left_width; i++)); do
        printf '─'
    done
    printf "┼"
    for ((i=0; i<right_width; i++)); do
        printf '─'
    done
    printf '\033[0m'
    
    # 绘制横向滚动条
    if [[ $max_line_length -gt $right_width ]]; then
        draw_horizontal_scrollbar $max_line_length $right_width $((term_height - 1))
    fi
    
    # 绘制底部提示行
    printf '\033[%d;1H' $term_height
    printf '\033[2K'
    printf '\033[1;30m'
    printf "↑/↓:menu  ←/→:scroll  PgUp/PgDn:page  Home/End:top/bottom q:quit"
    if [[ $total_lines -gt $content_height ]]; then
        printf " [Y: %d/%d]" $scroll_offset_y $max_scroll_y
    fi
    if [[ $max_line_length -gt $right_width ]]; then
        printf " [X: %d/%d]" $scroll_offset_x $max_scroll_x
    fi
    printf '\033[0m'
    
    # 显示光标
    printf '\033[?25h'
}

# 主循环
selected=1
scroll_offset_x=0
scroll_offset_y=0

# 获取初始终端尺寸
current_term_height=$(tput lines)
current_term_width=$(tput cols)

# 初始绘制
draw $selected

# 键盘输入循环
while true; do
    # 检查窗口大小是否变化
    if check_and_resize; then
        draw $selected
    fi
    
    # 读取按键
    read -s -k -t 0.05 key 2>/dev/null
    
    if [[ $? -ne 0 ]]; then
        continue
    fi
    
    case $key in
        $'\x1b')
            read -s -k -t 0.05 seq1
            if [[ $seq1 == '[' ]]; then
                read -s -k -t 0.05 seq2
                case $seq2 in
                    'A')
                        if ((selected > 1)); then
                            ((selected--))
                            scroll_offset_y=0
                            scroll_offset_x=0
                            draw $selected
                        fi
                        ;;
                    'B')
                        if ((selected < ${#MENU_ITEMS[@]})); then
                            ((selected++))
                            scroll_offset_y=0
                            scroll_offset_x=0
                            draw $selected
                        fi
                        ;;
                    'C')
                        local term_width=$(tput cols)
                        local right_width=$((term_width - 30 - 5))
                        if [[ $right_width -lt 10 ]]; then
                            right_width=10
                        fi
                        local max_scroll_x=$((max_line_length - right_width))
                        if [[ $max_scroll_x -gt 0 && $scroll_offset_x -lt $max_scroll_x ]]; then
                            ((scroll_offset_x++))
                            draw $selected
                        fi
                        ;;
                    'D')
                        if [[ $scroll_offset_x -gt 0 ]]; then
                            ((scroll_offset_x--))
                            draw $selected
                        fi
                        ;;
                    '5')
                        read -s -k -t 0.05 seq3
                        if [[ $seq3 == '~' ]]; then
                            local term_height=$(tput lines)
                            local content_height=$((term_height - 5))
                            local scroll_step=$((content_height - 1))
                            [[ $scroll_step -lt 1 ]] && scroll_step=1
                            scroll_offset_y=$((scroll_offset_y - scroll_step))
                            [[ $scroll_offset_y -lt 0 ]] && scroll_offset_y=0
                            draw $selected
                        fi
                        ;;
                    '6')
                        read -s -k -t 0.05 seq3
                        if [[ $seq3 == '~' ]]; then
                            local term_height=$(tput lines)
                            local content_height=$((term_height - 5))
                            local total_lines=${#detail_lines[@]}
                            local max_scroll_y=$((total_lines - content_height))
                            [[ $max_scroll_y -lt 0 ]] && max_scroll_y=0
                            local scroll_step=$((content_height - 1))
                            [[ $scroll_step -lt 1 ]] && scroll_step=1
                            scroll_offset_y=$((scroll_offset_y + scroll_step))
                            [[ $scroll_offset_y -gt $max_scroll_y ]] && scroll_offset_y=$max_scroll_y
                            [[ $scroll_offset_y -lt 0 ]] && scroll_offset_y=0
                            draw $selected
                        fi
                        ;;
                    'H')
                        scroll_offset_y=0
                        draw $selected
                        ;;
                    'F')
                        local term_height=$(tput lines)
                        local content_height=$((term_height - 5))
                        local total_lines=${#detail_lines[@]}
                        local max_scroll_y=$((total_lines - content_height))
                        [[ $max_scroll_y -lt 0 ]] && max_scroll_y=0
                        scroll_offset_y=$max_scroll_y
                        draw $selected
                        ;;
                esac
            fi
            ;;
        q|Q)
            # 退出时清屏并恢复设置
            optimized_clear
            printf '\033[?25h\033[?7h'
            exit 0
            ;;
    esac
done