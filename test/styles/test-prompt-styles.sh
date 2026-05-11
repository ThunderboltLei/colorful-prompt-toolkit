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
    source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.sh
    source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.sh
    source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.sh
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/menu_items/show_prompt_style.sh

    process_file_content "$MY_COLORFUL_PROMPT_ROOT_PATH/resources/styles/colorful-style.txt"
}


test_process_prompt_style