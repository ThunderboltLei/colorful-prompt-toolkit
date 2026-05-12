#!/bin/zsh


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