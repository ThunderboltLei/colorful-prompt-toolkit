SYSTEM_MODE=""
if [[ "$.term.mode" == "dark" ]]; then
    # 深色模式配色：使用亮色系
    # echo -e "dark"
    SYSTEM_MODE="#000000"
else
    # 浅色模式配色：使用深色系
    # echo -e "light"
    SYSTEM_MODE="#FFFFFF"
fi
REVERSE_SYSTEM_MODE=`invert_color ${SYSTEM_MODE}`

# 定义颜色和形状字符
LEFT_ARROW=""  # 向左实心箭头
RIGHT_ARROW=""  # 向右实心箭头 (需要 Powerline 字体)
ROUND_LEFT=""   # 左侧圆角左边缘
ROUND_RIGHT=""  # 右侧圆角右边缘

CORRECT="✔"
WRONG="✘"
HEART="❤"
STAR="★"
FLOWER="❀"
SNOW="❅"

TRIANGLE_LEFT="◀"
TRIANGLE_RIGHT="▶"

DOUBLE_ANGEL_LEFT="⟪"
DOUBLE_ANGEL_RIGHT="⟫"
ANGLE_LEFT="❰"
ANGLE_RIGHT="❯"

SQUARE_LEFT="["
SQUARE_RIGHT="]"

LESS_THAN="<"
GREATER_THAN=">"

MEDIUM_LEFT="❨"
MEDIUM_RIGHT="❩"
MEDIUM_FLATTENED_LEFT="❪"
MEDIUM_FLATTENED_RIGHT="❫"

LEFT_CEILING="┌"
RIGHT_CEILING="┐"
LEFT_FLOOR="└"
RIGHT_FLOOR="┘"

LEFT_T="├"
RIGHT_T="┤"
TOP_T="┬"
BOTTOM_T="┴"
CROSS="┼"
TRANSVERSE_LINE="–"
HALF_MAIN_LINE_UP="╵"
HALF_MAIN_LINE_RIGHT="-"
HALF_MAIN_LINE_DOWN="╷"

LEFT="←"
RIGHT="→"
UP="↑"
DOWN="↓"