#!/bin/zsh

source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-datetime.zsh

# 使用示例
_cpt_epoch_to_datetime $EPOCHREALTIME
# 输出: 2024-01-13 14:30:56.123

_cpt_datetime_to_epoch "2024-01-13 14:30:56"
# 输出: 1705123456.000000000