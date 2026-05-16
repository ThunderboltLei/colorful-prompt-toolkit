#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:
# 
# 
# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 

# =====  样式分派 =====
# 初始化脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-init.sh

# 加载命令脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/orders/prompt-orders.sh

# === 时间：初始化 ===
zmodload zsh/datetime 2>/dev/null
typeset -g G_ZSH_COMMAND_DURATION=""
typeset -g G_ZSH_LAST_COMMAND_START=""
typeset -g G_PROMPT_EOL_MARK=""

# === 方便扩展属于自己的提示符 ===
case $MY_COLORFUL_PROMPT_TYPE in
1)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t1-ninja.sh
    ;;
2)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t2-triangle_crumbs.sh
    ;;
3)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t3-finch.sh
    ;;
4)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t4-interval_finch.sh
    ;;
5)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t5-long_path.sh
    ;;
6)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t6-sentence.sh
    ;;
7)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t7-skaro.sh
    ;;
8)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t8-skaro_doublet.sh
    ;;
*)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/types/prompt-color-t1-ninja.sh
    ;;
esac

