#!/bin/zsh

### alias

#alias history-c='clear && history -p'
alias brew-c='brew cleanup && brew cleanup --prune=all'
alias conda-c='conda clean -t -y && conda clean --packages -y'

# auto-update script
alias macos-autoupdate-scrip='zsh /Users/raymondlei/Studios/developments/toolkit/scripts/macos_auto_update_script.zsh'