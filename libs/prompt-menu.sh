#!/bin/zsh


# 检查 zsh 版本
if [[ $ZSH_VERSION != 5.9* ]]; then
    echo "Warning: designed for zsh 5.9, current version $ZSH_VERSION"
fi

# 加载配置
source $MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.sh

#===========================================
# 全局变量
#===========================================

# 菜单数据
typeset -A details
for i in {1..${#MENU_ITEMS[@]}}; do
    details[${MENU_ITEMS[$i]}]="source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/menu_items/${ORDER_ITEMS[i]} menu_item"
done

# 滚动状态
typeset -i scroll_offset_x=0
typeset -i scroll_offset_y=0

# 内容缓存
typeset -a detail_lines=()
typeset -i max_line_length=0

# 终端尺寸
typeset -i current_height=0
typeset -i current_width=0

# UI 状态
typeset -i selected=1
typeset -i need_redraw=1

#===========================================
# ANSI 转义序列常量
#===========================================

readonly ESC="\033"
readonly CLEAR_SCREEN="${ESC}[2J${ESC}[H"
readonly CLEAR_LINE="${ESC}[2K"
readonly CLEAR_TO_END="${ESC}[K"
readonly CLEAR_BUFFER="${ESC}[3J"
readonly HIDE_CURSOR="${ESC}[?25l"
readonly SHOW_CURSOR="${ESC}[?25h"
readonly DISABLE_WRAP="${ESC}[?7l"
readonly ENABLE_WRAP="${ESC}[?7h"
readonly SAVE_CURSOR="${ESC}[s"
readonly RESTORE_CURSOR="${ESC}[u"

# 颜色
readonly COLOR_TITLE="${ESC}[1;33m"
readonly COLOR_BORDER="${ESC}[1;30m"
readonly COLOR_SELECTED="${ESC}[1;7;32m"
readonly COLOR_SCROLLBAR="${ESC}[1;37m"
readonly COLOR_SCROLLBAR_BG="${ESC}[1;30m"
readonly COLOR_RESET="${ESC}[0m"

#===========================================
# 工具函数
#===========================================

# 清屏
clear_screen() { printf "$CLEAR_SCREEN"; }
clear_line() { printf "$CLEAR_LINE"; }
clear_to_end() { printf "$CLEAR_TO_END"; }

# 光标控制
hide_cursor() { printf "$HIDE_CURSOR"; }
show_cursor() { printf "$SHOW_CURSOR"; }
save_cursor() { printf "$SAVE_CURSOR"; }
restore_cursor() { printf "$RESTORE_CURSOR"; }

# 终端设置
disable_wrap() { printf "$DISABLE_WRAP"; }
enable_wrap() { printf "$ENABLE_WRAP"; }

# 移动光标
move_cursor() { printf "${ESC}[%d;%dH" "$1" "$2"; }

# 获取终端尺寸
get_term_size() {
    current_height=$(tput lines)
    current_width=$(($(tput cols) * 1.5))
}

#===========================================
# 数据处理
#===========================================

# Description: 预处理详细内容
# Param
#   Param1: 详细内容
# Result: 
prepare_detail_lines() {
    # local content="$1"
    
    # # 清空缓存
    # detail_lines=()
    # max_line_length=0
    
    # # 处理空内容
    # [[ -z "$content" ]] && {
    #     detail_lines=("")
    #     return
    # }
    
    # # 分割内容
    # while IFS= read -r line; do
    #     detail_lines+=("$line")
    #     (( ${#line} > max_line_length )) && max_line_length=${#line}
    # done <<< "$content"
    
    # # 确保至少有一行
    # (( ${#detail_lines[@]} == 0 )) && detail_lines=("")

    local content="$1"
    
    # 清空缓存
    detail_lines=()
    max_line_length=0
    
    # 处理空内容
    if [[ -z "$content" ]]; then
        detail_lines=("")
        return
    fi
    
    # 方法1：使用 printf 保留所有换行和空格
    local lines=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        lines+=("$line")
        (( ${#line} > max_line_length )) && max_line_length=${#line}
    done < <(printf "%s\n" "$content")
    
    # 如果没有换行符，content 作为单行处理
    if (( ${#lines[@]} == 0 )); then
        lines=("$content")
        max_line_length=${#content}
    fi
    
    detail_lines=("${lines[@]}")
    
    # 确保至少有一行
    (( ${#detail_lines[@]} == 0 )) && detail_lines=("")
}

#===========================================
# 滚动条绘制
#===========================================

# Description: 绘制纵向滚动条
# Param
#   Param1: 当前行
#   Param2: 总行数
#   Param3: 是否可见
#   Param4: x坐标
#   Param5: y坐标
# Result: 
draw_vertical_scrollbar() {
    local current=$1 total=$2 visible=$3 x=$4 y=$5
    
    (( total <= visible )) && return
    
    local thumb_size=$(( (visible * visible) / total ))
    (( thumb_size < 1 )) && thumb_size=1
    
    local max_pos=$((total - visible))
    local thumb_pos=0
    (( max_pos > 0 )) && thumb_pos=$(( (current * (visible - thumb_size)) / max_pos ))
    
    for ((i=0; i<visible; i++)); do
        move_cursor $((y + i)) $x
        if (( i >= thumb_pos && i < thumb_pos + thumb_size )); then
            printf "${COLOR_SCROLLBAR}█${COLOR_RESET}"
        else
            printf "${COLOR_SCROLLBAR_BG}│${COLOR_RESET}"
        fi
    done
}


# Description: 绘制横向滚动条
# Param
#   Param1: 当前行内容的宽度
#   Param2: 可见宽度
#   Param3: y坐标
# Result: 
draw_horizontal_scrollbar() {
    local content_width=$1 visible_width=$2 y=$3
    
    (( content_width <= visible_width )) && return
    
    local thumb_size=$(( (visible_width * visible_width) / content_width ))
    (( thumb_size < 1 )) && thumb_size=1
    
    local max_scroll=$((content_width - visible_width))
    local thumb_pos=$(( (scroll_offset_x * (visible_width - thumb_size)) / max_scroll ))
    
    move_cursor $y 1
    clear_line
    printf "${COLOR_BORDER}"
    for ((i=0; i<visible_width; i++)); do
        if (( i >= thumb_pos && i < thumb_pos + thumb_size )); then
            printf "${COLOR_SCROLLBAR}─${COLOR_RESET}"
        else
            printf "${COLOR_BORDER}─${COLOR_RESET}"
        fi
    done
    printf "${COLOR_RESET}"
}

#===========================================
# 界面绘制
#===========================================

# Description: 标题栏
# Param
#   Param1: 左宽
#   Param2: 右宽
# Result: 
draw_title_bar() {
    local left_width=$1 right_width=$2
    
    printf "${COLOR_TITLE}"
    printf " %-$(($left_width-1))s" "MENU"
    printf "│"
    printf " %-$(($right_width-1))s" "DETAILS"
    printf "${COLOR_RESET}\n"
}

# Description: 绘制边框
# Param
#   Param1: 左宽
#   Param2: 右宽
# Result: 
draw_border_line() {
    local left_width=$1 right_width=$2
    
    printf "${COLOR_BORDER}"
    for ((i=0; i<left_width; i++)); do printf '─'; done
    printf "┼"
    for ((i=0; i<right_width; i++)); do printf '─'; done
    printf "${COLOR_RESET}\n"
}


# Description: 绘制菜单项
# Param
#   Param1: 所选的行
#   Param2: 左边框
#   Param3: 左边框
#   Param4: 左边框
# Result: 
draw_menu_items() {
    local selected_idx=$1 left_width=$2 start_line=$3 visible_lines=$4
    
    for ((line=0; line<visible_lines; line++)); do
        move_cursor $((start_line + line)) 1
        
        # if (( line < ${#MENU_ITEMS[@]} )); then
        if (( line < ${#details[@]} )); then
            local i=$((line + 1))
            if (( i == selected_idx )); then
                printf "${COLOR_SELECTED} %-$(($left_width-1))s${COLOR_RESET}" "${MENU_ITEMS[i]}"
            else
                printf " %-$(($left_width-1))s" "${MENU_ITEMS[i]}"
            fi
        else
            printf " %-$(($left_width-1))s" " "
        fi
        
        printf "│"
        clear_to_end
    done
}


# Description: 绘制内容
# Param
#   Param1: 
#   Param2: 
#   Param3: 
#   Param4: 
# Result: 
draw_content() {
    local right_start=$1 right_width=$2 content_start=$3 content_height=$4
    
    local start_line=$scroll_offset_y
    local end_line=$((start_line + content_height))
    (( end_line > ${#detail_lines[@]} )) && end_line=${#detail_lines[@]}
    
    disable_wrap
    
    for ((i=start_line; i<end_line; i++)); do
        local line_num=$((i - start_line + content_start))
        move_cursor $line_num $right_start
        
        local display_line="${detail_lines[i+1]}"
        (( ${#display_line} > scroll_offset_x )) && \
            display_line="${display_line:$scroll_offset_x:$right_width}" || \
            display_line=""
        
        printf "%-${right_width}s" "$display_line"
    done
    
    # 清理未使用的行
    for ((i=end_line - start_line + content_start; i<content_start+content_height; i++)); do
        move_cursor $i $right_start
        printf "%${right_width}s" ""
        clear_to_end
    done
    
    enable_wrap
}


# Description: 绘制底部
# Param
#   Param1: 
#   Param2: 
#   Param3: 
# Result: 
draw_bottom() {
    local term_height=$1 left_width=$2 right_width=$3
    local total_lines=${#detail_lines[@]}
    local content_height=$((term_height - 5))
    local max_scroll_y=$((total_lines - content_height))
    (( max_scroll_y < 0 )) && max_scroll_y=0
    local max_scroll_x=$((max_line_length - right_width))
    (( max_scroll_x < 0 )) && max_scroll_x=0
    
    # 底部边框
    move_cursor $((term_height - 1)) 1
    clear_line
    printf "${COLOR_BORDER}"
    for ((i=0; i<left_width; i++)); do printf '─'; done
    printf "┼"
    for ((i=0; i<right_width; i++)); do printf '─'; done
    printf "${COLOR_RESET}"
    
    # 横向滚动条
    (( max_line_length > right_width )) && \
        draw_horizontal_scrollbar $max_line_length $right_width $((term_height - 1))
    
    # 提示行
    move_cursor $term_height 1
    clear_line
    printf "${COLOR_BORDER}"
    printf "↑/↓:menu  ←/→:scroll  PgUp/PgDn:page  Home/End:top/bottom  q:quit"
    
    # 状态信息
    (( total_lines > content_height )) && \
        printf " [Y: %d/%d]" $scroll_offset_y $max_scroll_y
    (( max_line_length > right_width )) && \
        printf " [X: %d/%d]" $scroll_offset_x $max_scroll_x
    
    printf "${COLOR_RESET}"
}

#===========================================
# 主绘制函数
#===========================================

# Description: 主绘制函数
# Param
#   Param1: 所选的行
# Result: 
draw() {
    local selected_idx=$1
    
    get_term_size
    
    local left_width=30
    local right_start=$((left_width + 2))
    local right_width=$((current_width - left_width - 5))
    (( right_width < 10 )) && right_width=10
    
    # # 准备内容
    # # local _menu_item_content=$(${details[\"${MENU_ITEMS[selected_idx]}\"]})
    # local _menu_item_content=$(eval "${details[${MENU_ITEMS[$selected_idx]}]}")
    # # printf "--->>> _menu_item_content: %s\n"  $_menu_item_content
    # prepare_detail_lines "$_menu_item_content"

    # 修复：使用引号保护内容
    local cmd="${details[${MENU_ITEMS[$selected_idx]}]}"
    local _menu_item_content
    _menu_item_content=$(eval "$cmd" 2>&1)  # 捕获 stderr 也
    
    # 修复：传递时加引号
    prepare_detail_lines "$_menu_item_content"
    
    # 计算可视区域
    local content_start=3
    local content_height=$((current_height - 5))
    (( content_height < 1 )) && content_height=1
    local total_lines=${#detail_lines[@]}
    
    # 调整滚动位置
    local max_scroll_y=$((total_lines - content_height))
    (( max_scroll_y < 0 )) && max_scroll_y=0
    (( scroll_offset_y > max_scroll_y )) && scroll_offset_y=$max_scroll_y
    (( scroll_offset_y < 0 )) && scroll_offset_y=0
    
    local max_scroll_x=$((max_line_length - right_width))
    (( max_scroll_x < 0 )) && max_scroll_x=0
    (( scroll_offset_x > max_scroll_x )) && scroll_offset_x=$max_scroll_x
    (( scroll_offset_x < 0 )) && scroll_offset_x=0
    
    # 绘制界面
    clear_screen
    printf "${CLEAR_BUFFER}" 2>/dev/null
    hide_cursor
    disable_wrap
    
    draw_title_bar $left_width $right_width
    draw_border_line $left_width $right_width
    draw_menu_items $selected_idx $left_width $content_start $content_height
    
    draw_content $right_start $right_width $content_start $content_height
    
    # 垂直滚动条
    (( total_lines > content_height )) && \
        draw_vertical_scrollbar $scroll_offset_y $total_lines $content_height \
            $((right_start + right_width + 1)) $content_start
    
    draw_bottom $current_height $left_width $right_width
    
    enable_wrap
    show_cursor
}

#===========================================
# 输入处理
#===========================================

# Description: 方向键输入函数
# Param
#   Param1: 
# Result: 
handle_arrow_keys() {
    local key=$1
    
    case $key in
        'A')  # 上
            (( selected > 1 )) && {
                ((selected--))
                scroll_offset_y=0
                scroll_offset_x=0
                draw $selected
            }
            ;;
        'B')  # 下
            # (( selected < ${#MENU_ITEMS[@]} )) && {
            (( selected < ${#details[@]} )) && {
                ((selected++))
                scroll_offset_y=0
                scroll_offset_x=0
                draw $selected
            }
            ;;
        'C')  # 右
            local right_width=$((current_width - 30 - 5))
            (( right_width < 10 )) && right_width=10
            local max_scroll=$((max_line_length - right_width))
            (( max_scroll > 0 && scroll_offset_x < max_scroll )) && {
                ((scroll_offset_x++))
                draw $selected
            }
            ;;
        'D')  # 左
            (( scroll_offset_x > 0 )) && {
                ((scroll_offset_x--))
                draw $selected
            }
            ;;
    esac
}


# Description: PgUp/PgDown/Home/End键输入函数
# Param
#   Param1: 
# Result: 
handle_page_keys() {
    local key=$1
    
    case $key in
        '5')  # Page Up
            local content_height=$((current_height - 5))
            local step=$((content_height - 1))
            (( step < 1 )) && step=1
            scroll_offset_y=$((scroll_offset_y - step))
            (( scroll_offset_y < 0 )) && scroll_offset_y=0
            draw $selected
            ;;
        '6')  # Page Down
            local content_height=$((current_height - 5))
            local total_lines=${#detail_lines[@]}
            local max_scroll=$((total_lines - content_height))
            (( max_scroll < 0 )) && max_scroll=0
            local step=$((content_height - 1))
            (( step < 1 )) && step=1
            scroll_offset_y=$((scroll_offset_y + step))
            (( scroll_offset_y > max_scroll )) && scroll_offset_y=$max_scroll
            draw $selected
            ;;
        'H')  # Home
            scroll_offset_y=0
            draw $selected
            ;;
        'F')  # End
            local content_height=$((current_height - 5))
            local total_lines=${#detail_lines[@]}
            local max_scroll=$((total_lines - content_height))
            (( max_scroll < 0 )) && max_scroll=0
            scroll_offset_y=$max_scroll
            draw $selected
            ;;
    esac
}


#===========================================
# 主循环
#===========================================

# 初始化
get_term_size
draw $selected

# 主循环
while true; do
    # 检查窗口大小变化
    local old_height=$current_height
    local old_width=$current_width
    get_term_size
    
    if (( current_height != old_height || current_width != old_width )); then
        draw $selected
    fi
    
    # 读取按键
    read -s -k -t 0.05 key 2>/dev/null
    (( $? != 0 )) && continue
    
    case $key in
        $'\x1b')  # ESC 序列
            read -s -k -t 0.05 seq1
            [[ $seq1 == '[' ]] && {
                read -s -k -t 0.05 seq2
                case $seq2 in
                    [ABCD]) handle_arrow_keys $seq2 ;;
                    [56])   handle_page_keys $seq2 ;;
                    [HF])   handle_page_keys $seq2 ;;
                esac
            }
            ;;
        [qQ])   # 退出
            clear_screen
            show_cursor
            enable_wrap
            exit 0
            ;;
    esac
done
