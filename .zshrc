# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

zstyle ':omz:update' frequency 13 # (days)

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions

export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export EDITOR="/usr/bin/nvim"
export MANPAGER='nvim +Man!'

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt SHARE_HISTORY

set -o vi

eval "$(zoxide init zsh)"

alias cd="z"
alias i="sudo dnf install"
alias ll="ls -lah"
alias treee="tree -a -I node_modules -I .git -I .next -I target -I cmake-build-debug -I CMakeFiles -I __pycache__"
alias clip="xclip -selection clipboard"
alias push-old="pass git/github/token -c && git push origin master"
alias push="pass git/github/token -c && git push origin main"
alias pw="gpg -d ~/Storage/Secrets/secret.txt.gpg | tr -d '\n' | xclip -selection clipboard"
alias phy="python -i /home/connor/Code/Physics/utils.py"
alias yt="setsid -f mpv --no-terminal"

export pdf() {
    (evince "$@" > /dev/null 2>&1 & disown; true) > /dev/null 2>&1
}

export img() {
    (loupe "$@" > /dev/null 2>&1 & disown; true) > /dev/null 2>&1
}

export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.cargo/env"
