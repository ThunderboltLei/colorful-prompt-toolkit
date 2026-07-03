#!/bin/zsh


# 加载配置项脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/configs/prompt-settings.zsh"

# 加载常量脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.zsh"
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh"
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.zsh"

# 加载公共函数脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh"

# 加载文件操作脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-file.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-file.zsh"

# 加载颜色脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-color.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-color.zsh"

# 加载实时时间操作脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-datetime.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-datetime.zsh"

# 加载事件脚本
[[ -f "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-event.zsh" ]] && source "$MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-event.zsh"