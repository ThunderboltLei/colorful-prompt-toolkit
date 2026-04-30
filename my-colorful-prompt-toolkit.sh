# ===== my-colorful-prompt-toolkit =====

# 获取绚彩提示符脚本的根目录
export MY_COLORFUL_PROMPT_ROOT_PATH="${0:a:h}"

# ===== terminal prompt =====
# 启用颜色
autoload -U colors && colors

# ===== git-prompt.sh =====
### 定义提示符中 git 内容（注：第三方插件，暂不用修改）

# ===== 1. 启用 zsh 的 PROMPT_SUBST 选项 =====
# 让提示符中的 $(命令) 能被动态执行 =====
setopt PROMPT_SUBST
# 告诉 git-prompt.sh 我们处于 pcmode
GIT_PS1_PCMODE=yes

# ===== 2. 加载 git-prompt 脚本 =====
source $MY_COLORFUL_PROMPT_ROOT_PATH/vendors/git-prompt.sh

# ===== 3. 设置 Git 提示符参数 =====
GIT_PS1_SHOWUPSTREAM="auto"           # 显示与上游分支的差异（ahead/behind）
GIT_PS1_SHOWDIRTYSTATE="yes"          # 显示工作区状态（* 表示有修改，+ 表示有暂存）
GIT_PS1_SHOWCOLORHINTS="yes"          # 启用颜色提示（分支名会变绿/红等）[citation:4]
GIT_PS1_SHOWUNTRACKEDFILES="yes"      # 显示未跟踪文件（用 % 表示）
GIT_PS1_SHOWSTASHSTATE="yes"          # 显示是否有 stash（用 $ 表示）

# ===== 4. 自定义提示符样式 =====
source $MY_COLORFUL_PROMPT_ROOT_PATH/libs/prompt-type-dispatcher.sh
