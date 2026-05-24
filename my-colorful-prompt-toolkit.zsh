#!/bin/zsh


# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: prompt-themes-toolkit.zsh
# Description:
# 


# ===== my-colorful-prompt-toolkit =====


# === 获取绚彩提示符脚本的根目录 ===
target_path="${0:a:h}"
[[ "${MY_COLORFUL_PROMPT_ROOT_PATH}" != "$target_path" ]] && export MY_COLORFUL_PROMPT_ROOT_PATH="$target_path"


# === 自定义提示符样式 ===
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-themes-selector.zsh

