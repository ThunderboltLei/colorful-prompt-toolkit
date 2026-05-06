# =====  样式分派 =====

# === 加载配置 ===
source $MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.sh

# 加载公共函数
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-functions.sh

# 加载实时时间函数
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-datetime.sh

# === 加载常量 ===
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-consts.sh

# === 时间：初始化 ===
zmodload zsh/datetime 2>/dev/null
typeset -g ZSH_COMMAND_DURATION=""
typeset -g ZSH_LAST_COMMAND_START=""

# === 方便扩展属于自己的提示符 ===
case $MY_COLORFUL_PROMPT_TYPE in
1)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t1-ninja.sh
    ;;
2)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t2-triangle_crumbs.sh
    ;;
3)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t3-finch.sh
    ;;
4)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t4-interval_finch.sh
    ;;
5)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t5-long_path.sh
    ;;
6)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t6-sentence.sh
    ;;
7)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t7-skaro.sh
    ;;
8)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t8-skaro_doublet.sh
    ;;
*)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t1-ninja.sh
    ;;
esac