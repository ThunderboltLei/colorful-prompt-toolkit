#!/bin/zsh

### alias

alias cpt.clear=_cpt_clear
alias cpt.history-c=_cpt_clean_history
alias cpt.ll=_cpt_list

#alias history-c='clear && history -p'
alias cpt.brew-c='brew cleanup && brew cleanup --prune=all'
alias cpt.conda-c='conda clean -t -y && conda clean --packages -y'
alias cpt.log-erase='du -sh /var/db/diagnostics && sudo log erase --all && du -sh /var/db/diagnostics'

# alias scripts
local _CPT_APACHE_COMPONETS_PATH="/Users/raymondlei/Studios/developments/workspace/thunderboltlei/apache"
alias cpt.git-apache-script='$_CPT_APACHE_COMPONETS_PATH/_git_apache.sh'

local _CPT_SHELL_SCRIPTS_PATH="/Users/raymondlei/Studios/developments/workspace/thunderboltlei/X-Projects/shell"
alias cpt.macos-autoupdate-scrip='zsh $_CPT_SHELL_SCRIPTS_PATH/git/macos_auto_update_script.zsh'
alias cpt.macos-github-repository-synced-toolkit='$_CPT_SHELL_SCRIPTS_PATH/git/macos_github_repository_synced_toolkit.sh'