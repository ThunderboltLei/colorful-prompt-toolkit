#!/bin/zsh

# filename: counter.zsh

# relativePath="/Users/raymondlei/Downloads/apple.jpeg"
# echo $relativePath:

zmodload zsh/curses 2>&1
if [[ $? -ne 0 ]]; then
    echo "错误: zsh/curses 模块不可用"
    exit 1
fi

# 检查 zcurses 支持哪些子命令
for subOrder in `zcurses 2>&1 | grep -E "^[a-z]" | head -20`;
do
    echo -e "${subOrder}"
done

# 初始化主屏幕
zcurses init
#zcurses cursor off

# 创建自定义窗口
# shellcheck disable=SC2168
local win
zcurses addwin win 10 40 2 5


# 计数器
# shellcheck disable=SC2168
local count=0
# shellcheck disable=SC2168
#local key

# # 主循环
# local quit=0
# while (( quit == 0 )); do
#     # 读取按键（使用 zsh 内置的 read）
#     local key
#     read -k key

#     # 处理 ESC 序列（方向键等）
#     if [[ "$key" == $'\e' ]]; then
#         read -k key
#         if [[ "$key" == "[" ]]; then
#             read -k key
#             case "$key" in
#                 "A") key="UP" ;;
#                 "B") key="DOWN" ;;
#                 "C") key="RIGHT" ;;
#                 "D") key="LEFT" ;;
#                 *) key="ESC+[$key" ;;
#             esac
#         else
#             key="ESC"
#         fi
#     fi

# done

# 清理
# zcurses cursor on
zcurses delwin win
zcurses end

echo "Final count: $count"