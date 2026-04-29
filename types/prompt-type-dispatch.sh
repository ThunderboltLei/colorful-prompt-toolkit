# =====  样式分派 =====

# === 加载配置 ===
source $MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.sh

# 加载公共函数
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-functions.sh

# === 时间：初始化 ===
zmodload zsh/datetime 2>/dev/null
typeset -g ZSH_COMMAND_DURATION=""
typeset -g ZSH_LAST_COMMAND_START=""

# === 方便扩展属于自己的提示符 ===
case $MY_COLORFUL_PROMPT_TYPE in
1)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-default.sh
    ;;
2)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t2.sh
    ;;
3)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-t3.sh
    ;;
*)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/types/prompt-color-default.sh
    ;;
esac