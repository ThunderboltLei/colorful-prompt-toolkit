#!/bin/zsh

# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 
test_process_prompt_style() {
    source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.zsh
    source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh
    source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/menu_items/show_prompt_style.zsh

    process_file_content "$MY_COLORFUL_PROMPT_ROOT_PATH/resources/styles/colorful-style.txt"
}


test_process_prompt_style