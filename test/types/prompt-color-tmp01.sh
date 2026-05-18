# ===== 自定义样式（）=====

# 1. 定义一个函数来生成可点击的用户名
make_clickable_user() {
    # 构建 command:// 协议的 URL
    # 注意：实际支持取决于终端；这里作为示例
    local url="command://printf 'Clicked user: $USER'"
    # local url="command://https://www.baidu.com"

        # 创建一个临时脚本
    local script="/tmp/click_user_$$.zsh"
    cat > "$script" << EOF
#!/bin/bash
osascript -e 'display dialog "点击了用户: $USER" buttons {"OK"}'
rm "$script"
EOF
    chmod +x "$script"

        # 使用 file:// 协议
    local url="file://$script"

    local text="$USER"
    
    # 应用 OSC 8 序列
    # %{...%}: Zsh 的非打印字符包裹符，确保不计入提示符宽度 [citation:3]
    # %F{...}: 设置前景色；%f 重置颜色
    echo -n $'%{\e]8;;'"$url"$'\e\\%}'
    echo -n "%F{green}$text%f"
    echo -n $'%{\e]8;;\e\\%}'
}

# 2. 定义完整的提示符函数
custom_prompt() {
    local user_part="$(make_clickable_user)" 
    local host_part="@%F{cyan}%m%f"
    local path_part=":%F{yellow}%~%f"
    local git_part='$(git branch 2>/dev/null | grep "^*" | colrm 1 2 | sed "s/.*/ [&]/")'
    local symbol="
%F{green}❯%f "

    PROMPT="${user_part}${host_part}${path_part}${git_part}${symbol}"
}

# 3. 设置 prompt_subst 选项，允许 PROMPT 中的命令替换
setopt prompt_subst

# 4. 应用提示符
precmd_functions+=(custom_prompt)

