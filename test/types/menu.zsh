#!/bin/zsh

# 检查 zsh 版本
if [[ $ZSH_VERSION != 5.9* ]]; then
    echo "Warning: designed for zsh 5.9, current version $ZSH_VERSION"
fi

# 定义菜单项 (左侧显示)
menu_items=(
    "System Info"
    "Disk Usage"
    "Memory Status"
    "Network Info"
    "Running Processes"
    "Show Prompt Style"
    # "Exit"
)

# 定义每个菜单项对应的详细内容 (右侧显示)
declare -A details
details["System Info"]="
$(uname -a)
$(cat /etc/os-release 2>/dev/null | head -n 3)
"
details["Disk Usage"]="
$(df -h)
"
details["Memory Status"]="
$(free -h 2>/dev/null || vm_stat 2>/dev/null || echo 'free/vm_stat not available')
"
details["Network Info"]="
IP Addresses: $(ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}')
"
details["Running Processes"]="
$(ps aux | head -n 15)
"
details["Show Prompt Style"]="
$(cat $MY_COLORFUL_PROMPT_ROOT_PATH/resources/styles/colorful-style.txt)
"
details["Exit"]="
Exiting program...
"

# 保留右侧内容占位符
current_detail="${details[\"${menu_items[1]}\"]}"

# 清屏函数
clear_screen() {
    printf '\033[2J\033[H'
}

# 绘制界面 (左侧菜单 + 右侧详情)
draw() {
    local selected_idx=$1
    local term_height=$(tput lines)
    local term_width=$(tput cols)
    local left_width=30
    local right_start=$((left_width + 2))
    
    # 清屏并隐藏光标
    printf '\033[?25l'
    clear_screen
    
    # 绘制分隔线
    printf '\033[1;33m'
    printf "%-${left_width}s" " MENU "
    printf "│"
    printf "%-${term_width}s" " DETAILS"
    printf '\033[0m\n'

    current_detail="${details[\"${menu_items[${selected_idx}]}\"]}"
    
    # 绘制菜单项
    for i in {1..${#menu_items[@]}}; do
        if [[ $i -eq $selected_idx ]]; then
            # 高亮当前选中项
            printf '\033[1;7;32m'  # 反色+绿色背景
            printf "%-${left_width}s" " ${menu_items[i]}"
            printf '\033[0m'
        else
            printf " %-$(($left_width-1))s" "${menu_items[i]}"
        fi
        printf "│"
        # 右侧内容（仅在第一个菜单项或刷新时显示全部，简单展示相同内容）
        if [[ $i -eq 1 ]]; then
            local first_line=$(echo "$current_detail" | head -n 1)
            printf " %.$(($term_width - $right_start - 2))s" "$first_line"
        fi
        printf "\n"
    done
    
    # 右侧完整详细内容区域（从当前选中项下方开始显示，覆盖前几行）
    printf '\033[%d;%dH' $(( ${#menu_items[@]} + 2 )) 1
    printf '\033[?7l'  # 关闭自动换行避免混乱
    
    # 显示右侧详细内容
    printf '\033[%d;%dH' 2 $((left_width + 2))
    local line_count=0
    while IFS= read -r line; do
        printf '\033[K'  # 清除行尾
        printf "%-$(($term_width - $left_width - 2))s" "$line"
        printf '\033[%d;%dH' $((2 + ++line_count)) $((left_width + 2))
        if [[ $line_count -ge $(($term_height - 3)) ]]; then
            break
        fi
    done <<< "$current_detail"
    
    # 清理剩余右侧区域
    for ((i=line_count; i<term_height-2; i++)); do
        printf '\033[K'
        printf '\033[%d;%dH' $((2 + i)) $((left_width + 2))
    done
    
    printf '\033[?7h'  # 恢复自动换行
    printf '\033[%d;1H' $term_height
    printf '\033[2K'   # 清除最后一行
    printf "Use ↑/↓ to navigate, Enter to select/exit"
    printf '\033[?25h' # 恢复光标
}

# 主循环
selected=1
draw $selected

# 键盘输入循环
while true; do
    read -s -k key
    case $key in
        $'\x1b')  # ESC 序列开始
            read -s -k -t 0.1 seq1
            if [[ $seq1 == '[' ]]; then
                read -s -k -t 0.1 seq2
                case $seq2 in
                    'A')  # 上键
                        if ((selected > 1)); then
                            ((selected--))
                            current_detail="${details[${menu_items[selected]}]}"
                            draw $selected
                        fi
                        ;;
                    'B')  # 下键
                        if ((selected < ${#menu_items[@]})); then
                            ((selected++))
                            current_detail="${details[${menu_items[selected]}]}"
                            draw $selected
                        fi
                        ;;
                esac
            fi
            ;;
        q)  # 按 q 退出
            clear_screen
            echo "Exited."
            exit 0
            ;;
    esac
done