# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export MANPAGER='nvim +Man!'

# PS1="\u@\h:\w$ "
PS1="\u@\h:\w$ "

eval "$(starship init bash)"

eval "$(zoxide init bash)"
alias cd="z"

alias i="sudo dnf install"
alias ll="ls -lah"
alias clip="xclip -selection clipboard"
alias push="cat ~/Storage/token.txt | clip && git push origin master"

export PATH="$PATH:/home/connor/Code/Rust/compiler/target/debug/"

. "$HOME/.cargo/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
