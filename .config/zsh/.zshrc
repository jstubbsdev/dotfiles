# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"

plugins=(git)

# Auto select Node version.
# @see: https://github.com/Sparragus/zsh-auto-nvm-use
plugins+=(zsh-auto-nvm-use)

source $ZSH/oh-my-zsh.sh

# User configuration

# SSH key assistance (disables prompt every time)
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Applications directory
export XDG_DATA_DIRS="/home/james/.local/share/applications:/usr/local/share:/usr/share"

# MDS bin scripts
export PATH="$PATH:/home/james/.mds/bin"

# Quick assume command.
source ~/.mds/functions/mds.sh

# private environment variables.
source ~/.config/zsh/.env

# Docker compose backwards compatible alias.
alias docker-compose="docker compose"

# phpenv
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

# composer without memory limit
alias dcomposer="php -d memory_limit=-1 $(which composer)"
