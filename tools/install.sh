#!/bin/zsh


source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh

# 判断 zsh
if command -v zsh >/dev/null 2>&1; then
    _cpt_simple_print  "zsh 已安装"
else
    _cpt_simple_print "zsh 未安装"
fi

# 判断 util-linux-user 包
if command -v chsh >/dev/null 2>&1; then
    _cpt_simple_print "util-linux-user 已安装"
else
    _cpt_simple_print "util-linux-user 未安装"
fi

# 判断 bc 包
if command -v bc >/dev/null 2>&1; then
    _cpt_simple_print "bc 已安装"
else
    _cpt_simple_print "bc 未安装"
fi

exit

#zsh
#util-linux-user
#    chsh -s $(which zsh)
#bc