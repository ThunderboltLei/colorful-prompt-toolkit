#!/bin/zsh

### miniconda
export MINICONDA_HOME="$MyStudios/developments/miniconda"
export PATH="$MINICONDA_HOME/bin:$PATH"

# 添加以下内容，隐藏 conda 环境提示
conda config --set changeps1 false