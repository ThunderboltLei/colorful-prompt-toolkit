#!/bin/zsh


RESET="\033[0m"

hex_to_rgb() {
    local hex=${1#\#}
    printf "\033[38;2;%d;%d;%dm" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

process_color_line() {
    local line=$1
    local parts=("${(@s:|:)line}")
    local result_parts=()
    
    for part in "${parts[@]}"; do
        if [[ $part =~ '^#[0-9A-Fa-f]{6}$' ]]; then
            result_parts+=("$(hex_to_rgb "$part")${part}${RESET}")
        else
            result_parts+=("$part")
        fi
    done
    
    # 关键修复：使用 j:|: 正确连接
    echo "${(j:|:)result_parts}"
}

# 测试
test_line="17|雨林渐变|#4C9F70|#2D6A4F|#1B4332|#40916C|#52B788|#081C15"
echo "测试输出:"
process_color_line "$test_line"

# 测试长度
output=$(process_color_line "$test_line")
echo "输出长度: ${#output}"