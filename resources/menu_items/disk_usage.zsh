#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:


source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh


# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 
menu_function() {
    local info="$(df -h)"
    _cpt_simple_print "$info"
}

# 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi