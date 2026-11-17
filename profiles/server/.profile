[ -r "$HOME/.config/shell/path.sh" ] && . "$HOME/.config/shell/path.sh"

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
