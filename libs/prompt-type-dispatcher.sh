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

# 加载配置项脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.sh

# 加载常量脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.sh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.sh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.sh

# 加载公共函数脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.sh

# 加载文件操作脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-file.sh

# 加载颜色脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-color.sh

# 加载实时时间操作脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-datetime.sh

# 加载事件脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-event.sh

# 加载命令脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/orders/prompt-orders.sh

# === 时间：初始化 ===
zmodload zsh/datetime 2>/dev/null
typeset -g ZSH_COMMAND_DURATION=""
typeset -g ZSH_LAST_COMMAND_START=""

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