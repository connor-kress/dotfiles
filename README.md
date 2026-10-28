# Dotfiles

Personal shell and application configuration. Agent configuration and scripts live in separate repos, with this repo providing the setup entry point.

## Setup

Requires Git, Python 3.9+, GNU Stow, and GitHub SSH access.

```sh
git clone git@github.com:connor-kress/dotfiles.git ~/dotfiles
cd ~/dotfiles
python install.py --dry-run
python install.py
```

The installer:

- Uses Stow to link configuration and `.local/bin` commands into your home directory.
- Clones the latest default branches of [agents-config](https://github.com/connor-kress/agents-config) into `~/.agents` and [Scripts](https://github.com/connor-kress/Scripts) into `~/Scripts` if missing.
- Runs the [agent instruction installer](https://github.com/connor-kress/agents-config#readme).

Use `--dry-run` to preview setup without changing files or settings. Existing repos are left untouched on reruns. Conflicting files stop installation without being overwritten.

Applications and script dependencies must be installed separately. Some configuration contains machine-specific paths.

In a GNOME session, the installer also applies `.gnome/keybinds.toml`; other desktops skip this step. Requires Python 3.11+ and `gsettings`. Shortcuts are matched by name, and unlisted shortcuts are preserved. To apply them separately, run `python .gnome/apply_keybinds.py`, optionally with `--dry-run`.

Keep this checkout in place; installed links point into it. Stow includes untracked files and uses `.stow-local-ignore`, not `.gitignore`, for exclusions.

## Dismiss notifications

On GNOME Shell 50, `dismiss-notification` removes the visible banner and its history entry. After first installation, log out and back in, then rerun `install.py` to enable the extension.

## Updates

Update each repo independently when ready, then rerun the installer to link any new configuration:

```sh
git -C ~/dotfiles pull --ff-only
git -C ~/.agents pull --ff-only
git -C ~/Scripts pull --ff-only
python ~/dotfiles/install.py
```
