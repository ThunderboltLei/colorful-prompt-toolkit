#!/bin/zsh

# 检查 zsh 版本
if [[ $ZSH_VERSION != 5.9* ]]; then
    echo "Warning: designed for zsh 5.9, current version $ZSH_VERSION"
fi

# 加载配置
source $MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh

#===========================================
# 全局变量
#===========================================

# 菜单数据

# Description: 解析菜单项
# Param
#   Param1: 索引值
# Result: 返回菜单项各部分内容
# 
parse_menu_item() {
    local index=$1
    local menu_infos="${MENU_ITEMS[$index]}"
    local parts=(${(s/:/)menu_infos})

    print -r -- "${parts[1]}"
    print -r -- ${parts[2]}
    print -r -- "${parts[3]}"
}

# 菜单名称与脚本的对应关系
typeset -A details
local item_counter=1  # 用于跟踪 MenuItem 的索引
for i in {1..${#MENU_ITEMS[@]}}; do

    local result=(${(f)"$(parse_menu_item $i)"})
    local name="${result[1]}"
    local level=${result[2]}
    local type="${result[3]}"

    if [[ "$type" == "MenuItem" ]]; then
        details[$name]="source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/menu_items/${ORDER_ITEMS[$item_counter]} menu_item"

        ((item_counter++))  # 每遇到一个 MenuItem 就增加
    else
        details[$name]="echo \"$name-$level-$type\""
    fi
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
# 菜单-初始值（第一个）
typeset -g _selected_menu_item="${${(f)"$(parse_menu_item 1)"}[1]}"

# 控制是否显示右侧内容
typeset -i show_detail=0  # 1: 显示内容, 0: 不显示内容（默认不显示）

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
# 
prepare_detail_lines() {
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
    done < <(printf "%s${NEW_LINE}" "$content")
    
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
draw_vertical_scrollbar() {
    local current=$1 total=$2 visible=$3 x=$4 y=$5
    
    (( total <= visible )) && return
    
    local thumb_size=1
    if (( visible < total )); then
        thumb_size=$(( (visible * visible) / total ))
        (( thumb_size < 1 )) && thumb_size=1
    fi
    
    local max_pos=$((total - visible))
    local thumb_pos=0
    if (( max_pos > 0 )); then
        thumb_pos=$(( (current * (visible - thumb_size)) / max_pos ))
    fi
    
    local i
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
draw_horizontal_scrollbar() {
    local content_width=$1 visible_width=$2 y=$3
    
    (( content_width <= visible_width )) && return
    
    local thumb_size=1
    if (( visible_width < content_width )); then
        thumb_size=$(( (visible_width * visible_width) / content_width ))
        (( thumb_size < 1 )) && thumb_size=1
    fi
    
    local max_scroll=$((content_width - visible_width))
    local thumb_pos=0
    if (( max_scroll > 0 )); then
        thumb_pos=$(( (scroll_offset_x * (visible_width - thumb_size)) / max_scroll ))
    fi
    
    move_cursor $y 1
    clear_line
    printf "${COLOR_BORDER}"
    local i
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

# Description: 绘制完整的分隔线
draw_full_line() {
    local width=$1
    local i
    for ((i=0; i<width; i++)); do
        printf "${HORIZON_LINE}"
    done
}

# Description: 绘制带分隔符的行
draw_separator_line() {
    local left_width=$1 right_width=$2
    local y_pos=$3
    
    if (( y_pos > 0 )); then
        move_cursor $y_pos 1
    fi
    
    printf "${COLOR_BORDER}"
    draw_full_line $left_width
    printf "${CROSS}"
    draw_full_line $right_width
    printf "${COLOR_RESET}"
    if (( y_pos == 0 )); then
        printf "${NEW_LINE}"
    fi
}

# Description: 标题栏
draw_title_bar() {
    local left_width=$1 right_width=$2
    
    printf "${COLOR_TITLE}"
    printf " %-$(($left_width-1))s" "MENU"
    printf "${COLOR_BORDER}${VERTICAL_LINE}${COLOR_TITLE}"
    
    if (( show_detail == 0 )); then
        printf " %-$(($right_width-1))s" ""
    else
        printf " %-$(($right_width-1))s" "DETAILS"
    fi
    printf "${COLOR_RESET}"
    printf "${NEW_LINE}"
}

# Description: 绘制菜单项
draw_menu_items() {
    local selected_idx=$(($1 + 1)) left_width=$2 start_line=$3 visible_lines=$4

    local line
    for ((line=0; line<visible_lines; line++)); do
        move_cursor $((start_line + line)) 1

        if (( line < $(( ${#details[@]} + 1 )) )); then
            local i=$((line + 1))

            # 菜单-根节点
            if [[ $line -eq 0 ]]; then
                printf " %-$(($left_width-2))s" "${E_LADY_BUG} Menu"
                printf "${COLOR_BORDER}${VERTICAL_LINE}${COLOR_RESET}"
                continue
            fi

            local result=(${(f)"$(parse_menu_item $line)"})
            local name="${result[1]}"
            local level=${result[2]}
            local type="${result[3]}"
            local symbol="$([[ $type == "MenuItem" ]] && echo "${LEFT_FLOOR}" || echo "${TRIANGLE_RIGHT}")"

            if (( i == selected_idx )); then
                _selected_menu_item="${name}"
                printf "${COLOR_SELECTED} %-$(($left_width-1))s${COLOR_RESET}" "$(_cpt_symbol_printf ' ' ${level}) ${symbol} ${name}"
                printf "${COLOR_BORDER}${VERTICAL_LINE}${COLOR_RESET}"
            else
                printf " %-$(($left_width-1))s" "$(_cpt_symbol_printf ' ' ${level}) ${symbol} ${name}"
                printf "${COLOR_BORDER}${VERTICAL_LINE}${COLOR_RESET}"
            fi
        else
            printf " %-$(($left_width-1))s" " "
            printf "${COLOR_BORDER}${VERTICAL_LINE}${COLOR_RESET}"
        fi
        
        clear_to_end
    done
}

# Description: 绘制内容
draw_content() {
    local right_start=$1 right_width=$2 content_start=$3 content_height=$4
    
    # 确保 right_width 有效
    if (( right_width < 5 )); then
        right_width=10
    fi
    
    # 如果不显示内容，直接清空右侧区域
    if (( show_detail == 0 )); then
        local i
        for ((i=0; i<content_height; i++)); do
            local line_num=$((i + content_start))
            move_cursor $line_num $right_start
            printf "%${right_width}s" ""
            clear_to_end
        done
        return
    fi
    
    # 确保 detail_lines 有内容
    if (( ${#detail_lines[@]} == 0 )); then
        detail_lines[1]="(无内容)"
        max_line_length=10
    fi
    
    local start_line=$scroll_offset_y
    local end_line=$((start_line + content_height))
    if (( end_line > ${#detail_lines[@]} )); then
        end_line=${#detail_lines[@]}
    fi
    
    disable_wrap
    
    local i
    for ((i=start_line; i<end_line; i++)); do
        local line_num=$((i - start_line + content_start))
        move_cursor $line_num $right_start
        
        local display_line="${detail_lines[i+1]}"
        local line_len=${#display_line}
        if (( line_len > scroll_offset_x )); then
            display_line="${display_line:$scroll_offset_x:$right_width}"
        else
            display_line=""
        fi
        
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
draw_bottom() {
    local term_height=$1 left_width=$2 right_width=$3
    local total_lines=${#detail_lines[@]}
    local content_height=$((term_height - 5))
    local max_scroll_y=$((total_lines - content_height))
    (( max_scroll_y < 0 )) && max_scroll_y=0
    local max_scroll_x=$((max_line_length - right_width))
    (( max_scroll_x < 0 )) && max_scroll_x=0
    
    # 底部边框
    draw_separator_line $left_width $right_width $((term_height - 1))
    
    # 横向滚动条（仅在显示内容时显示）
    if (( show_detail == 1 && max_line_length > right_width )); then
        draw_horizontal_scrollbar $max_line_length $right_width $((term_height - 1))
    fi
    
    # 提示行
    move_cursor $term_height 1
    clear_line
    printf "${COLOR_BORDER}"
    printf "${UP}${SLASH}${DOWN}:menu  ${LEFT}${SLASH}${RIGHT}:scroll  PgUp${SLASH}PgDn:page  Home${SLASH}End:top${SLASH}bottom  Enter:show  q:quit"
    
    # 状态信息（仅在显示内容时显示）
    if (( show_detail == 1 )); then
        if (( total_lines > content_height )); then
            printf " [Y: %d${SLASH}%d]" $scroll_offset_y $max_scroll_y
        fi
        if (( max_line_length > right_width )); then
            printf " [X: %d${SLASH}%d]" $scroll_offset_x $max_scroll_x
        fi
    fi
    
    printf "${COLOR_RESET}"
}

#===========================================
# 主绘制函数
#===========================================

# Description: 主绘制函数
draw() {
    local selected_idx=$1
    
    get_term_size
    
    local left_width=30
    local right_start=$((left_width + 2))
    local right_width=$((current_width - left_width - 5))
    if (( right_width < 10 )); then
        right_width=10
    fi
    
    # 计算可视区域
    local content_start=3
    local content_height=$((current_height - 4))
    if (( content_height < 1 )); then
        content_height=1
    fi
    local total_lines=${#detail_lines[@]}
    
    # 只在显示内容时调整滚动位置
    if (( show_detail == 1 )); then
        local max_scroll_y=$((total_lines - content_height))
        if (( max_scroll_y < 0 )); then
            max_scroll_y=0
        fi
        if (( scroll_offset_y > max_scroll_y )); then
            scroll_offset_y=$max_scroll_y
        fi
        if (( scroll_offset_y < 0 )); then
            scroll_offset_y=0
        fi
        
        local max_scroll_x=$((max_line_length - right_width))
        if (( max_scroll_x < 0 )); then
            max_scroll_x=0
        fi
        if (( scroll_offset_x > max_scroll_x )); then
            scroll_offset_x=$max_scroll_x
        fi
        if (( scroll_offset_x < 0 )); then
            scroll_offset_x=0
        fi
    fi
    
    # 绘制界面
    clear_screen
    printf "${CLEAR_BUFFER}" 2>/dev/null
    hide_cursor
    disable_wrap
    
    draw_title_bar $left_width $right_width
    draw_separator_line $left_width $right_width 2
    draw_menu_items $selected_idx $left_width $content_start $content_height
    
    draw_content $right_start $right_width $content_start $content_height
    
    # 垂直滚动条（仅在显示内容时显示）
    if (( show_detail == 1 && total_lines > content_height )); then
        draw_vertical_scrollbar $scroll_offset_y $total_lines $content_height \
            $((right_start + right_width + 1)) $content_start
    fi
    
    draw_bottom $current_height $left_width $right_width
    
    enable_wrap
    show_cursor
}

#===========================================
# 输入处理
#===========================================

# Description: 显示当前选中的菜单项内容
show_current_content() {
    # 获取当前选中项的内容
    local cmd="${details[${_selected_menu_item}]}"
    
    if [[ -n "$cmd" ]]; then
        # 执行命令并获取输出
        local output
        output=$(eval "$cmd" 2>&1)
        prepare_detail_lines "$output"
    else
        prepare_detail_lines "错误: 未找到命令 '${_selected_menu_item}'"
    fi
    
    # 设置为显示模式
    show_detail=1
    scroll_offset_y=0
    scroll_offset_x=0
    
    # 重新绘制界面
    draw $selected
}

# Description: 方向键输入函数
handle_arrow_keys() {
    local key=$1
    
    case $key in
        'A')  # 上
            if (( ${#details[@]} > 0 )); then
                if (( selected > 1 )); then
                    ((selected--))
                else
                    selected=${#details[@]}  # 跳到最后一个
                fi
                scroll_offset_y=0
                scroll_offset_x=0
                show_detail=0

                local result=(${(f)"$(parse_menu_item $selected)"})
                _selected_menu_item="${result[1]}"

                draw $selected
            fi
            ;;
        'B')  # 下
            if (( ${#details[@]} > 0 )); then
                if (( selected < ${#details[@]} )); then
                    ((selected++))
                else
                    selected=1  # 跳到第一个
                fi
                scroll_offset_y=0
                scroll_offset_x=0
                show_detail=0

                local result=(${(f)"$(parse_menu_item $selected)"})
                _selected_menu_item="${result[1]}"

                draw $selected
            fi
            ;;
        'C')  # 右
            if (( show_detail == 1 )); then
                local right_width=$((current_width - 30 - 5))
                if (( right_width < 10 )); then
                    right_width=10
                fi
                local max_scroll=$((max_line_length - right_width))
                if (( max_scroll > 0 && scroll_offset_x < max_scroll )); then
                    ((scroll_offset_x++))
                    draw $selected
                fi
            fi
            ;;
        'D')  # 左
            if (( show_detail == 1 && scroll_offset_x > 0 )); then
                ((scroll_offset_x--))
                draw $selected
            fi
            ;;
    esac
}

# Description: PgUp/PgDown/Home/End键输入函数
handle_page_keys() {
    local key=$1
    
    if (( show_detail == 0 )); then
        return
    fi
    
    local content_height=$((current_height - 5))
    local step=$((content_height - 1))
    if (( step < 1 )); then
        step=1
    fi
    
    case $key in
        '5')
            scroll_offset_y=$((scroll_offset_y - step))
            if (( scroll_offset_y < 0 )); then
                scroll_offset_y=0
            fi
            draw $selected
            ;;
        '6')
            local total_lines=${#detail_lines[@]}
            local max_scroll=$((total_lines - content_height))
            if (( max_scroll < 0 )); then
                max_scroll=0
            fi
            scroll_offset_y=$((scroll_offset_y + step))
            if (( scroll_offset_y > max_scroll )); then
                scroll_offset_y=$max_scroll
            fi
            draw $selected
            ;;
        'H')
            scroll_offset_y=0
            draw $selected
            ;;
        'F')
            local total_lines=${#detail_lines[@]}
            local content_height=$((current_height - 5))
            local max_scroll=$((total_lines - content_height))
            if (( max_scroll < 0 )); then
                max_scroll=0
            fi
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
        continue
    fi
    
    # 读取按键
    read -s -k key
    
    # 处理按键
    case $key in
        $'\n'|$'\r')
            # 回车键 - 显示内容
            show_current_content
            ;;
        $'\x1b')
            # ESC 序列（方向键等）
            read -s -k -t 0.05 seq1
            if [[ $seq1 == '[' ]]; then
                read -s -k -t 0.05 seq2
                case $seq2 in
                    [ABCD])
                        handle_arrow_keys $seq2
                        ;;
                    [56]|H|F)
                        handle_page_keys $seq2
                        ;;
                esac
            fi
            ;;
        [qQ])
            # 退出
            clear_screen
            show_cursor
            enable_wrap
            exit 0
            ;;
    esac
done