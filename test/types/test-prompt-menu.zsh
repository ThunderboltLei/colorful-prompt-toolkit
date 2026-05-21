#!/bin/zsh

# === 定义菜单项 ===
# MENU_ITEMS: 左侧，菜单项
# ORDER_ITEMS: 右侧，菜单项对应的命令
MENU_ITEMS=(
    # === 菜单项名称:层数:类型"
    "System:1:Dir"
        "System Info:2:MenuItem"
        "Disk Usage:2:MenuItem"
        "Memory Status:2:MenuItem"
        "Network Info:2:MenuItem"
        "Running Processes:2:MenuItem"
        "Show Prompt Style:2:MenuItem"
    "Files:1:Dir"
        "Dirs & Docs:2:MenuItem"
        "Git Log Graph:2:MenuItem"
)
ORDER_ITEMS=(
    "system_info.zsh"
    "disk_usage.zsh"
    "memory_status.zsh"
    "network_info.zsh"
    "running_processes.zsh"
    "show_prompt_style.zsh"
    "dirs_and_docs.zsh"
    "git_log_graph.zsh"
)

# 菜单数据

# 定义函数
parse_menu_item() {
    local index=$1
    local menu_infos="${MENU_ITEMS[$index]}"
    local parts=(${(s/:/)menu_infos})

    print -r -- "${parts[1]}"
    print -r -- "${parts[2]}"
    print -r -- "${parts[3]}"
}

# for i in {1..${#MENU_ITEMS[@]}}; do
#     print -n "<<<<< i:$i, menu: ${MENU_ITEMS[$i]}\n"

#     local result=(${(f)"$(parse_menu_item $i)"})
#     local name="${result[1]}"
#     local level="${result[2]}"
#     local type="${result[3]}"
#     print -n ">>>>> name:$name, level:$level, type:$type\n"
# done

# exit

typeset -A details
local item_counter=1  # 用于跟踪 MenuItem 的索引
for i in {1..${#MENU_ITEMS[@]}}; do
    # details[${MENU_ITEMS[$i]}]="source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/menu_items/${ORDER_ITEMS[$i]} menu_item"

    print -n ">>>>> i: $i\n"

    # local menu_infos="${MENU_ITEMS[$i]}"
    # local parts=(${(s/:/)menu_infos})
    # local name="${parts[1]}"
    # local level="${parts[2]}"
    # local type="${parts[3]}"

    # 使用示例
    local result=(${(f)"$(parse_menu_item $i)"})
    local name="${result[1]}"
    local level="${result[2]}"
    local type="${result[3]}"
    print -n ">>>>> name:$name, level:$level, type:$type\n"

    
    if [[ "$type" == "MenuItem" ]]; then
        details["$name"]="source $MY_COLORFUL_PROMPT_ROOT_PATH/resources/menu_items/${ORDER_ITEMS[$item_counter]} menu_item"

        print -n ">>>> item_counter: $item_counter - $name: ${details[$name]}\n"

        ((item_counter++))  # 每遇到一个 MenuItem 就增加
    else
        details["$name"]="echo \"$name-$level-$type\""
    fi
done


for k in ${(k)details}; do
    print -n ">>> $k - ${details[$k]}\n"
done