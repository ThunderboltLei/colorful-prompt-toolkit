#!/bin/zsh


# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: prompt-common-funcs.zsh
# Description: common functions

source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh

# Description: 定义 precmd 函数
# Params:
#   param1: 
#   param2: 
# Result: 
#   example: ----------
#
menu_function() {

    local info=""
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # 在 Git 仓库中，显示分支信息
        info=`git log --graph --pretty=format:'%C(yellow)%h%C(cyan)%d%Creset %s %C(white)- %an, %ar%Creset' --all`
    else
        # 普通目录
        source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh
        info=" $E_RING Attention: $SQUARE_LEFT$BOLD_RED$PWD$RESET$SQUARE_RIGHT Not github directory."
    fi

    _cpt_simple_print "$info"
}


# # 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi

