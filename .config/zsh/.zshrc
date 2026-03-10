# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="af-magic"

plugins=(git)

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

# Copilot CLI installation directory

export PATH="$PATH:/$HOME/.local/bin"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Auto select Node version.
# This must be done after sourcing nvm.
# @see: https://github.com/Sparragus/zsh-auto-nvm-use
plugins+=(zsh-auto-nvm-use)

source $ZSH/oh-my-zsh.sh

# Applications directory
export XDG_DATA_DIRS="/$HOME/.local/share/applications:/usr/local/share:/usr/share"

# GPG fix (see https://stackoverflow.com/a/72788147)
export GPG_TTY=$(tty)

# MDS bin scripts
export PATH="$PATH:/$HOME/.mds/bin"

# Quick assume command.
alias assume="source $(which assume)"
source ~/.mds/functions/mds.sh

# private environment variables.
source ~/.config/zsh/.env

# phpenv
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

# composer without memory limit
alias dcomposer="php -d memory_limit=-1 $(which composer)"

# hex <-> dec converters
hex2dec () {
    echo "ibase=16; $(echo $@ | tr '[:lower:]' '[:upper:]')" | bc
}

dec2hex () {
    echo "obase=16; $@" | bc
}
