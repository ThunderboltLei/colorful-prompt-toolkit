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

### 说明：需要执行长时间才能返回信息的脚本，不适合放到菜单列表中。切记 ！！！

# Description: 菜单项对应的业务函数
# Params: 无
#   param1: 
#   param2: 
# Result: 输出要显示的内容
# 
menu_function() {
    # 菜单项执行的业务逻辑
}

# 不要修改，固定写法
if [[ "$1" == "menu_item" ]]; then
    menu_function
fi