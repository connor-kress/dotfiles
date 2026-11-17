# Dotfiles

Personal shell and application configuration. Agent configuration and scripts live in separate repos, with this repo providing the setup entry point.

## Setup

Requires Git, Python 3.9+, GNU Stow, and GitHub SSH access.

```sh
git clone git@github.com:connor-kress/dotfiles.git ~/dotfiles
cd ~/dotfiles
python install.py --profile=desktop --dry-run
python install.py --profile=desktop
```

The installer:

- Uses Stow to link the profile's configuration into your home directory.
- Clones the profile's repos if missing: [agents-config](https://github.com/connor-kress/agents-config) into `~/.agents` and, for `desktop`, [Scripts](https://github.com/connor-kress/Scripts) into `~/Scripts`.
- Runs the [agent instruction installer](https://github.com/connor-kress/agents-config#readme).

## Profiles

Profiles are defined in `PROFILES` in `install.py`. `--profile` is required.

- `desktop` links everything at the repo root and applies GNOME settings.
- `server` links `profiles/server/` (Bash, Git, and systemd user environment) plus the root paths listed in its `shared_paths`. Its `.bashrc` sets `PATH` before the interactive check so non-interactive SSH commands find user-installed tools.

On the server, `aws sso login` listens for the browser callback on port 47823. The desktop's `agent-server-aws-sso.service` forwards that port over SSH, so the login link can be opened on the desktop. Enable it once with `systemctl --user enable --now agent-server-aws-sso.service`.

To share another root config with a profile, add its path to that profile's `shared_paths`. Profile-only files go in `profiles/<name>/` and cannot overlap shared paths.

Use `--dry-run` to preview setup without changing files or settings. Existing repos are left untouched on reruns. Conflicting files stop installation without being overwritten.

Applications and script dependencies must be installed separately. Some configuration contains machine-specific paths.

In a GNOME session, the `desktop` profile also applies `.gnome/keybinds.toml`; other desktops skip this step. Requires Python 3.11+ and `gsettings`. Shortcuts are matched by name, and unlisted shortcuts are preserved. To apply them separately, run `python .gnome/apply_keybinds.py`, optionally with `--dry-run`.

Keep this checkout in place; installed links point into it. Stow includes untracked files and uses `.stow-local-ignore`, not `.gitignore`, for exclusions.

## Dismiss notifications

On GNOME Shell 50, `dismiss-notification` removes the visible banner and its history entry. After first installation, log out and back in, then rerun `install.py` to enable the extension.

## Updates

Update each repo independently when ready, then rerun the installer to link any new configuration:

```sh
git -C ~/dotfiles pull --ff-only
git -C ~/.agents pull --ff-only
git -C ~/Scripts pull --ff-only
python ~/dotfiles/install.py --profile=<name>
```
