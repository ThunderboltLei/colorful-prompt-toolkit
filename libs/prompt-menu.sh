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

# 清屏函数
clear_screen() {
    printf '\033[2J\033[H'
}

# 将详细内容分解为多行
prepare_detail_lines() {
    local content="$1"
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
    local current_pos=$1        # 当前位置
    local total_items=$2        # 总项目数
    local visible_height=$3     # 可见区域高度
    local x_pos=$4              # 滚动条x位置
    local y_start=$5            # 滚动条起始y位置
    
    if [[ $total_items -le $visible_height ]]; then
        return  # 不需要滚动条
    fi
    
    local scrollbar_height=$visible_height
    local thumb_size=$(( (visible_height * visible_height) / total_items ))
    [[ $thumb_size -lt 1 ]] && thumb_size=1
    
    # 计算滑块位置
    local max_pos=$((total_items - visible_height))
    local thumb_pos
    if [[ $max_pos -gt 0 ]]; then
        thumb_pos=$(( (current_pos * (visible_height - thumb_size)) / max_pos ))
    else
        thumb_pos=0
    fi
    
    for ((i=0; i<visible_height; i++)); do
        printf '\033[%d;%dH' $((y_start + i)) $x_pos
        if [[ $i -ge $thumb_pos && $i -lt $((thumb_pos + thumb_size)) ]]; then
            printf '\033[1;37m█'  # 滚动块
        else
            printf '\033[1;30m│'  # 滚动条背景
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
        return 0  # 尺寸已变化
    fi
    return 1  # 尺寸未变化
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
    local right_width=$((term_width - left_width - 4))  # 留出滚动条空间
    
    # 确保右侧有足够宽度
    if [[ $right_width -lt 10 ]]; then
        right_width=10
    fi
    
    # 准备当前选择的详细内容
    prepare_detail_lines "${details[\"${MENU_ITEMS[selected_idx]}\"]}"
    
    # 确保滚动偏移量在有效范围内
    local total_lines=${#detail_lines[@]}
    local content_start_line=3
    local content_height=$((term_height - 5))  # 减去标题栏(2行)、底部提示行(1行)和边框
    
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
    
    # 清屏并隐藏光标
    printf '\033[?25l'
    clear_screen
    
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
    
    # 先绘制左侧菜单区域的所有行
    for ((line=0; line<content_height; line++)); do
        local current_y=$((content_start_line + line))
        
        # 定位到当前行的开头
        printf '\033[%d;1H' $current_y
        
        if [[ $line -lt ${#MENU_ITEMS[@]} ]]; then
            # 显示菜单项
            local i=$((line + 1))
            if [[ $i -eq $selected_idx ]]; then
                printf '\033[1;7;32m'
                printf " %-$(($left_width-1))s" "${MENU_ITEMS[i]}"
                printf '\033[0m'
            else
                printf " %-$(($left_width-1))s" "${MENU_ITEMS[i]}"
            fi
        else
            # 空白区域，填充空格保持边框
            printf " %-$(($left_width-1))s" " "
        fi
        
        # 绘制右边框
        printf "│"
    done
    
    # 关闭自动换行，防止内容溢出
    printf '\033[?7l'
    
    # 绘制右侧详细内容
    local start_line=$scroll_offset_y
    local end_line=$((start_line + content_height))
    if [[ $end_line -gt $total_lines ]]; then
        end_line=$total_lines
    fi
    
    for ((i=start_line; i<end_line; i++)); do
        local line_num=$((i - start_line + content_start_line))
        printf '\033[%d;%dH' $line_num $right_start
        
        local display_line="${detail_lines[i+1]}"
        
        # 应用横向滚动：截取子字符串
        if [[ ${#display_line} -gt $scroll_offset_x ]]; then
            display_line="${display_line:$scroll_offset_x:$right_width}"
        else
            display_line=""
        fi
        
        # 输出内容
        printf "%-${right_width}s" "$display_line"
    done
    
    # 清理右侧多余的行
    for ((i=end_line - start_line + content_start_line; i<content_start_line+content_height; i++)); do
        printf '\033[%d;%dH' $i $right_start
        printf "%${right_width}s" ""
    done
    
    # 恢复自动换行
    printf '\033[?7h'
    
    # 绘制垂直滚动条
    if [[ $total_lines -gt $content_height ]]; then
        draw_scrollbar $scroll_offset_y $total_lines $content_height \
            $((right_start + right_width + 1)) $content_start_line
    fi
    
    # 绘制底部边框线
    printf '\033[%d;1H' $((term_height - 1))
    printf '\033[1;30m'
    for ((i=0; i<left_width; i++)); do
        printf '─'
    done
    printf "┼"
    for ((i=0; i<right_width; i++)); do
        printf '─'
    done
    printf '\033[0m'
    
    # 底部提示
    printf '\033[%d;1H' $term_height
    printf '\033[2K'
    printf '\033[1;30m'
    printf "↑/↓:menu  ←/→:scroll  PgUp/PgDn:page  Home/End:top/bottom  q:quit"
    if [[ $total_lines -gt $content_height ]]; then
        printf " [Y: %d/%d]" $scroll_offset_y $max_scroll_y
    fi
    if [[ $max_line_length -gt $right_width ]]; then
        printf " [X: %d/%d]" $scroll_offset_x $max_scroll_x
    fi
    printf '\033[0m'
    
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

# 设置非阻塞输入的文件描述符
# 创建一个管道用于定时检查
zmodload zsh/zselect

# 键盘输入循环 - 使用主动检查窗口大小
while true; do
    # 检查窗口大小是否变化
    if check_and_resize; then
        draw $selected
    fi
    
    # 使用 read -t 0 检查是否有输入（非阻塞）
    read -s -k -t 0.1 key 2>/dev/null
    
    # 如果没有按键，继续循环检查窗口大小
    if [[ $? -ne 0 ]]; then
        continue
    fi
    
    case $key in
        $'\x1b')  # ESC 序列
            read -s -k -t 0.05 seq1
            if [[ $seq1 == '[' ]]; then
                read -s -k -t 0.05 seq2
                case $seq2 in
                    'A')  # 上键 - 菜单导航
                        if ((selected > 1)); then
                            ((selected--))
                            scroll_offset_y=0
                            scroll_offset_x=0
                            draw $selected
                        fi
                        ;;
                    'B')  # 下键 - 菜单导航
                        if ((selected < ${#MENU_ITEMS[@]})); then
                            ((selected++))
                            scroll_offset_y=0
                            scroll_offset_x=0
                            draw $selected
                        fi
                        ;;
                    'C')  # 右键 - 横向滚动
                        local term_width=$(tput cols)
                        local right_width=$((term_width - 30 - 4))
                        if [[ $right_width -lt 10 ]]; then
                            right_width=10
                        fi
                        local max_scroll_x=$((max_line_length - right_width))
                        if [[ $max_scroll_x -gt 0 && $scroll_offset_x -lt $max_scroll_x ]]; then
                            ((scroll_offset_x++))
                            draw $selected
                        fi
                        ;;
                    'D')  # 左键 - 横向滚动
                        if [[ $scroll_offset_x -gt 0 ]]; then
                            ((scroll_offset_x--))
                            draw $selected
                        fi
                        ;;
                    '5')  # Page Up
                        read -s -k -t 0.05 seq3
                        if [[ $seq3 == '~' ]]; then
                            local term_height=$(tput lines)
                            local content_height=$((term_height - 5))
                            local scroll_step=$((content_height - 1))
                            if [[ $scroll_step -lt 1 ]]; then
                                scroll_step=1
                            fi
                            scroll_offset_y=$((scroll_offset_y - scroll_step))
                            if [[ $scroll_offset_y -lt 0 ]]; then
                                scroll_offset_y=0
                            fi
                            draw $selected
                        fi
                        ;;
                    '6')  # Page Down
                        read -s -k -t 0.05 seq3
                        if [[ $seq3 == '~' ]]; then
                            local term_height=$(tput lines)
                            local content_height=$((term_height - 5))
                            local total_lines=${#detail_lines[@]}
                            local max_scroll_y=$((total_lines - content_height))
                            local scroll_step=$((content_height - 1))
                            if [[ $scroll_step -lt 1 ]]; then
                                scroll_step=1
                            fi
                            scroll_offset_y=$((scroll_offset_y + scroll_step))
                            if [[ $scroll_offset_y -gt $max_scroll_y ]]; then
                                scroll_offset_y=$max_scroll_y
                            fi
                            if [[ $scroll_offset_y -lt 0 ]]; then
                                scroll_offset_y=0
                            fi
                            draw $selected
                        fi
                        ;;
                    'H')  # Home 键
                        scroll_offset_y=0
                        draw $selected
                        ;;
                    'F')  # End 键
                        local term_height=$(tput lines)
                        local content_height=$((term_height - 5))
                        local total_lines=${#detail_lines[@]}
                        local max_scroll_y=$((total_lines - content_height))
                        scroll_offset_y=$max_scroll_y
                        if [[ $scroll_offset_y -lt 0 ]]; then
                            scroll_offset_y=0
                        fi
                        draw $selected
                        ;;
                esac
            fi
            ;;
        [hjkl])  # Vim 风格的导航
            case $key in
                'j')  # 下 - 菜单导航
                    if ((selected < ${#MENU_ITEMS[@]})); then
                        ((selected++))
                        scroll_offset_y=0
                        scroll_offset_x=0
                        draw $selected
                    fi
                    ;;
                'k')  # 上 - 菜单导航
                    if ((selected > 1)); then
                        ((selected--))
                        scroll_offset_y=0
                        scroll_offset_x=0
                        draw $selected
                    fi
                    ;;
                'h')  # 左 - 横向滚动
                    if [[ $scroll_offset_x -gt 0 ]]; then
                        ((scroll_offset_x--))
                        draw $selected
                    fi
                    ;;
                'l')  # 右 - 横向滚动
                    local term_width=$(tput cols)
                    local right_width=$((term_width - 30 - 4))
                    if [[ $right_width -lt 10 ]]; then
                        right_width=10
                    fi
                    local max_scroll_x=$((max_line_length - right_width))
                    if [[ $max_scroll_x -gt 0 && $scroll_offset_x -lt $max_scroll_x ]]; then
                        ((scroll_offset_x++))
                        draw $selected
                    fi
                    ;;
            esac
            ;;
        q|Q)  # 退出
            clear_screen
            printf '\033[?25h'
            printf '\033[?7h'
            exit 0
            ;;
    esac
done