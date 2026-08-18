#!/bin/zsh

source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-ansi.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-emojis.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/consts/prompt-symbols.zsh
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh


# Description: 若当前目录是 git 目录，则可查看全部提交历史
# Params:
#   param1: 
#   param2: 
# Result: 
# 
_cpt_git-log-graph() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # 在 Git 仓库中，显示分支信息
        git log --graph --pretty=format:'%C(yellow)%h%C(cyan)%d%Creset %s %C(white)- %an, %ar%Creset' --all
    else
        # 普通目录
        source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh
        _cpt_print_color "34" " $E_RING Attention: $SQUARE_LEFT$BOLD_RED$PWD$RESET$SQUARE_RIGHT Not github directory."
    fi
}
alias git-log-graph=_cpt_git-log-graph