#!/bin/zsh

# filename: simple_curses.zsh

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

# 简单测试：创建窗口并显示
zcurses init

# 创建自定义窗口
local win
zcurses addwin win 10 40 2 5

# zcurses clear
zcurses move win 5 10
zcurses string win "Hello from zsh/curses!"
zcurses move win 7 10
zcurses string win "Press any key to exit..."
zcurses refresh win

read -k key

zcurses end
echo -n "Done."
