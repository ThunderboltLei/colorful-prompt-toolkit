#!/bin/zsh

# filename: keytest.zsh

# 尝试加载模块
if ! zmodload zsh/curses 2>/dev/null; then
    echo "错误: zsh/curses 模块不可用"
    echo "macOS 自带 Zsh 通常不包含此模块"
    echo ""
    echo "解决方案："
    echo "1. 使用 homebrew 安装完整版 Zsh: brew install zsh"
    echo "2. 或者使用其他 TUI 方案: dialog, fzf, gum 等"
    exit 1
fi

# 关键：禁用当前函数内的 ZLE 特性
local zle=${ZLE_DISABLED:-false}

zcurses init
# zcurses clear

# 创建自定义窗口
local win
zcurses addwin win 10 40 2 5
zcurses border win

# 显示标题
zcurses move win 0 15
zcurses string win "T04 Demo - Window"
zcurses refresh win

# 获取当前尺寸
local rows cols
rows=$LINES
cols=$COLUMNS

zcurses string win "LINES: [$rows]"
zcurses string win "COLUMNS: [$rows]"
# zcurses refresh win

# local quit=0
# local key

# while (( quit == 0 )); do

#     # zcurses string win "LINES: [$LINES]"
#     # zcurses string win "COLUMNS: [$COLUMNS]"

#     # # 清空显示区域（用空格覆盖）
#     # for ((i=2; i<15; i++)); do
#     #     zcurses move win $i 0
#     #     zcurses string win " "
#     # done
#     # zcurses clear win
#     # zcurses refresh

#     # zcurses getch win key
#     read -k key
    
#     zcurses move win 2 0
#     zcurses string win "Press a key (press 'q' to quit): "
#     zcurses refresh
    
#     zcurses move win 4 0
#     zcurses string win "Key: [$key]"
    
#     # 显示 ASCII 码
#     local code
#     printf -v code "%d" "'$key"
#     zcurses move win 5 0
#     zcurses string win "ASCII: $code"
    
#     zcurses refresh
    
#     [[ "$key" == "q" ]] && quit=1
# done

# 启用鼠标（如果支持）
if ! zcurses mouse 2>/dev/null; then
    zcurses mouse 1
fi

# 设置超时
zcurses timeout win 0

while true; do
    # print -n "\033[2J\033[3J\033[H"   # 清屏并重置光标
    zcurses clear win

    local raw key mouse_info
    zcurses input win raw key mouse_info
    
    case "$key" in
        "q"|"Q")
            break
            ;;
        "MOUSE")
            # 鼠标坐标在 mouse_info[2], mouse_info[3]
            zcurses move win 10 5
            zcurses string win "Mouse at: ${mouse_info[2]},${mouse_info[3]}"
            ;;
        "UP")
            zcurses move win 12 5
            zcurses string win "Pressed Up Arrow"
            ;;
        "DOWN")
            zcurses move win 12 5
            zcurses string win "Pressed Down Arrow"
            ;;
        *)
            if [[ -n "$raw" ]]; then
                zcurses move win 10 5
                zcurses string win "Raw: $raw"
            fi
            ;;
    esac


    zcurses refresh

    read -k key
done

# 清理
zcurses clear
zcurses delwin win
zcurses end

