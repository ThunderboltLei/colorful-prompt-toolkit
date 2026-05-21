#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: dirs_and_docs.zsh
# Description: show directories and documents in current directory


source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh



# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 
menu_function() {
    local info="$({

        _cpt_print_color "34" "${E_DOCUMENT} 当前目录：$(pwd)"

        _cpt_simple_print "${GREEN} >>> ${RED}${BOLD}Directory List:${RESET}"
        # 使用 ls -lt 按时间排序目录
        if ls -ld -- *(/) 2>/dev/null | grep -q .; then
            ls -lt -- *(/) 2>/dev/null | grep -v '^total'
        else
            _cpt_simple_print "No Directory Here ..."
        fi

        _cpt_simple_print

        _cpt_simple_print "${GREEN} >>> ${CYAN}${BOLD}Document List:${RESET}"
        # 使用 ls -lt 按时间排序文件
        if ls -l -- *(.) 2>/dev/null | grep -q .; then
            ls -lt -- *(.) 2>/dev/null | grep -v '^total'
        else
            _cpt_simple_print "No Document Here ..."
        fi
    } 2>/dev/null | grep -v '^total')"

    _cpt_print_color "35" "$info"
}

# 如果脚本有参数且第一个参数是 "menu"
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi