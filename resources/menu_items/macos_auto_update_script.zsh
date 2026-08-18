#!/bin/zsh

# === File Description Format ===
# 
# Creator: Raymond-Magnus-Lei
# Filename: 
# Description:

# === Function Description Format ===
# 
# Description: 
# Params:
#   param1: 
#   param2: 
# Result: 
# 
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-common-funcs.zsh

# Description: 菜单项对应的业务函数
# Params: 无
#   param1: 
#   param2: 
# Result: 输出要显示的内容
# 
menu_function() {
    ### 菜单项执行的业务逻辑

    # 文件
    SCRIPT_FILE="/Users/raymondlei/Studios/developments/toolkit/scripts/macos_auto_update_script.sh"
    LOG_FILE="$MY_COLORFUL_PROMPT_ROOT_PATH/resources/logs/macos_auto_update_script.sh.log"

    # 确保目录和文件
    mkdir -p "$(dirname "$LOG_FILE")"
    > "$LOG_FILE"

    # 检查脚本是否存在
    if [[ ! -f "$SCRIPT_FILE" ]]; then
        echo "❌ 脚本文件不存在: $SCRIPT_FILE"
        exit 1
    fi

    # # 如果脚本需要 sudo，提前获取权限
    # sudo -v 2>/dev/null

    echo "⏳ 开始执行脚本，日志保存到: $LOG_FILE"

    # 执行脚本，同时写入日志并实时显示
    zsh "$SCRIPT_FILE" 2>&1 | tee -a "$LOG_FILE" | awk '{print; fflush()}' | while IFS= read -r line; do
        # 如果 _cpt_simple_print 函数存在则调用，否则用 echo
        # if type _cpt_simple_print >/dev/null 2>&1; then
            # _cpt_simple_print "$line"
        # else
            echo "$line"
        # fi
    done
}

# 不要修改，固定写法
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi