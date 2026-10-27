# Personal environment

This repo is the starting point for setting up my shell and application configuration. Agent configuration and scripts remain independent Git repos at `~/.agents` and `~/Scripts`.

## Setup

Install Git, Python 3.9 or newer, and GNU Stow using your system package manager. GitHub SSH access is required for the clone URLs below and in `install.py`.

```sh
git clone git@github.com:connor-kress/dotfiles.git ~/dotfiles
cd ~/dotfiles
python install.py --dry-run
python install.py
```

The installer does the following:

- Checks for missing dependencies and conflicting dotfiles or repo paths.
- Clones `connor-kress/agents-config` into `~/.agents` and `connor-kress/Scripts` into `~/Scripts` if missing. Fresh clones use the latest commit on each remote's default branch, with no version pinning or submodules.
- Uses GNU Stow to link dotfiles into the home directory, including files under `.config` and `.gnome`. `.stow-local-ignore` excludes Git metadata, this README, `install.py`, `tests/`, Python bytecode, and local application data. Stow keeps its own ignore file out of the target too.
- Runs `~/.agents/install.py` to install agent instructions using GNU Stow. See the [agent configuration README](https://github.com/connor-kress/agents-config#readme) for package targets and uninstall commands.

Existing checkouts, files, and links are preserved. A conflicting path stops setup so you can move it aside yourself. Existing relative links into this checkout are accepted by Stow, including directory links such as `~/.config/nvim`. Rerunning the installer installs missing links and skips existing checkouts without pulling, switching branches, or resetting local changes.

`--dry-run` does not clone or create links. If the agent repo is missing, it reports the planned clone but cannot check agent instruction conflicts until the repo is available. A normal run checks those conflicts after cloning and before creating dotfile links. Clones remain in place if a later step fails, so rerunning can resume setup.

Keep the dotfiles checkout in place after installation because the installed links point into it. Stow includes untracked files unless `.stow-local-ignore` excludes them; it does not read `.gitignore`. Add new configuration to Git for use on other machines, and add local-only files to both ignore lists as needed. `--no-folding` keeps new target directories as real directories and links individual files.

## Updates

Update each repo independently when ready:

```sh
git -C ~/dotfiles pull --ff-only
git -C ~/.agents pull --ff-only
git -C ~/Scripts pull --ff-only
python ~/dotfiles/install.py
```

The installer installs configuration, not applications or script-specific dependencies. Some configuration contains machine-specific paths. `.gnome/keybinds.toml` documents shortcuts; linking it does not apply GNOME settings.

