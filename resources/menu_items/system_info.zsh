#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:

# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 

menu_function() {

    # 收集信息时不执行 echo
    local info=$(uname -a)
    local os_info=$(cat /etc/os-release 2>/dev/null | head -n 3)
    
    # 使用 printf 安全输出
    printf "%s\n\n%s\n" "$info" "$os_info"
}

# 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi