#!/bin/zsh


# 加载配置项脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.sh"

# 加载常量脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.sh"
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.sh"
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.sh"

# 加载公共函数脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.sh"

# 加载文件操作脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-file.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-file.sh"

# 加载颜色脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-color.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-color.sh"

# 加载实时时间操作脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-datetime.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-datetime.sh"

# 加载事件脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-event.sh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-event.sh"