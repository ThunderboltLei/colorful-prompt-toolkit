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
    info="IP Addresses: $(ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}')"
    printf "%s\n" $info
}

# 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi