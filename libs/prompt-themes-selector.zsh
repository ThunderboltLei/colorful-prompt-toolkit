#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: prompt-type-selector.zsh
# Description:
# 


# ===== my-colorful-prompt-toolkit =====

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad


# === 1.启用 zsh 的 PROMPT_SUBST 选项 ===
# 让提示符中的 $(命令) 能被动态执行 ===
setopt PROMPT_SUBST
# 开启提示符间距控制
setopt PROMPT_CR
setopt PROMPT_SP
# 告诉 git-prompt.sh 我们处于 pcmode
GIT_PS1_PCMODE=yes


# ===== 2.git-prompt.sh =====
# === 设置 Git 提示符参数 ===
# 显示与上游分支的差异（ahead/behind）
export GIT_PS1_SHOWUPSTREAM="auto"
# 显示工作区状态（* 表示有修改，+ 表示有暂存）
export GIT_PS1_SHOWDIRTYSTATE="yes"
# 启用颜色提示（分支名会变绿/红等）
export GIT_PS1_SHOWCOLORHINTS="yes"
# 显示未跟踪文件（用 % 表示）
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
# 显示是否有 stash（用 $ 表示）
export GIT_PS1_SHOWSTASHSTATE="yes"
# === 加载 git-prompt 脚本 ===
source $MY_COLORFUL_PROMPT_ROOT_PATH/vendors/git-prompt.sh


# =====  样式分派 =====
# 初始化脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-init.zsh


# 加载命令脚本
source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/orders/prompt-orders.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/orders/prompt-homebrew.zsh


# === 时间：初始化 ===
zmodload zsh/datetime 2>/dev/null
typeset -g G_ZSH_COMMAND_DURATION=""
typeset -g G_ZSH_LAST_COMMAND_START=""
typeset -g G_PROMPT_EOL_MARK=""


# === 方便扩展属于自己的提示符 ===
case $MY_COLORFUL_PROMPT_TYPE in
1)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t1-ninja.zsh
    ;;
2)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t2-triangle_crumbs.zsh
    ;;
3)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t3-finch.zsh
    ;;
4)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t4-interval_finch.zsh
    ;;
5)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t5-long_path.zsh
    ;;
6)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t6-sentence.zsh
    ;;
7)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t7-skaro.zsh
    ;;
8)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t8-skaro_doublet.zsh
    ;;
*)
    source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/themes/prompt-color-t1-ninja.zsh
    ;;
esac

