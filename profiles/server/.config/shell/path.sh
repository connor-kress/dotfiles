# User binaries for every shell, including non-interactive SSH and `sh -l`.
# POSIX sh; sourced by ~/.profile and ~/.bashrc. Keep in sync with
# .config/environment.d/10-path.conf.
export PNPM_HOME="$HOME/.local/share/pnpm"
for dir in "$PNPM_HOME/bin" "$HOME/.pulumi/bin" "$HOME/.cargo/bin" "$HOME/go/bin" "$HOME/.local/bin"; do
    case ":$PATH:" in
        *":$dir:"*) ;;
        *) PATH="$dir:$PATH" ;;
    esac
done
unset dir
export PATH
