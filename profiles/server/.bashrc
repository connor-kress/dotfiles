# Runs for non-interactive SSH commands too, so agents get the same PATH.
# Keep in sync with .config/environment.d/10-path.conf.
export PNPM_HOME="$HOME/.local/share/pnpm"
for dir in "$PNPM_HOME" "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/.local/bin"; do
    case ":$PATH:" in
        *":$dir:"*) ;;
        *) PATH="$dir:$PATH" ;;
    esac
done
unset dir
export PATH

export EDITOR=nvim
export VISUAL=nvim

case $- in
    *i*) ;;
    *) return ;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=100000
shopt -s histappend checkwinsize
set -o vi

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

export MANPAGER='nvim +Man!'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -lah'

# Git aliases matching the oh-my-zsh git plugin.
git_main_branch() {
    local ref
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
        if git show-ref -q --verify "$ref"; then
            echo "${ref##*/}"
            return
        fi
    done
    echo master
}

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gau='git add --update'
alias gc='git commit --verbose'
alias gcm='git checkout $(git_main_branch)'
alias gd='git diff'
alias glg='git log --stat'
alias gp='git push'
alias gst='git status'
