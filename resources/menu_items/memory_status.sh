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
    info=`free -h 2>/dev/null || vm_stat 2>/dev/null || echo 'free/vm_stat not available'`
    printf "%s\n" $info
}

# 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi