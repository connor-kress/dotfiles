"""Install personal configuration without replacing existing files."""

import argparse
from pathlib import Path
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parent
REPOSITORIES = {
    ".agents": "git@github.com:connor-kress/agents-config.git",
    "Scripts": "git@github.com:connor-kress/Scripts.git",
}


def say(message: str) -> None:
    print(message, flush=True)


def run_install_command(command: list[str], *, check: bool = True) -> int:
    result = subprocess.run(command, stderr=subprocess.PIPE, text=True)
    for line in result.stderr.splitlines(keepends=True):
        if line.rstrip("\r\n") != "WARNING: in simulation mode so not modifying filesystem.":
            sys.stderr.write(line)
    sys.stderr.flush()
    if check:
        result.check_returncode()
    return result.returncode


def check_repositories(home: Path) -> bool:
    valid = True
    for name in REPOSITORIES:
        destination = home / name
        if not destination.exists() and not destination.is_symlink():
            continue
        result = subprocess.run(
            ["git", "-C", str(destination), "rev-parse", "--show-toplevel"],
            text=True, capture_output=True,
        )
        if result.returncode or Path(result.stdout.strip()).resolve() != destination.resolve():
            say(f"Conflict: {destination} exists but is not a Git repository root")
            valid = False
    return valid


def install(home: Path, *, dry_run: bool) -> int:
    for command in ("git", "stow"):
        if shutil.which(command) is None:
            say(f"Missing dependency: {command}. Install it and rerun install.py.")
            return 1

    if not check_repositories(home):
        say("Resolve the conflicts and rerun install.py. No changes made.")
        return 1

    stow_command = [
        "stow", "--no-folding", "--verbose",
        f"--dir={ROOT}", f"--target={home}", "--stow", ".",
    ]
    # Let Stow check every dotfile conflict before cloning or linking anything.
    if run_install_command([*stow_command, "--simulate"], check=False):
        say("Resolve the Stow conflicts and rerun install.py. No changes made.")
        return 1

    for name, url in REPOSITORIES.items():
        destination = home / name
        if destination.exists():
            say(f"Keeping existing checkout: {destination} (no pull or reset)")
        else:
            say(f"{'Would clone' if dry_run else 'Cloning'} {url} into {destination}")
            if not dry_run:
                subprocess.run(["git", "clone", url, str(destination)], check=True)

    agent_installer = home / ".agents" / "install.py"
    if agent_installer.is_file():
        # Check agent instruction conflicts before installing any dotfile links.
        run_install_command([sys.executable, str(agent_installer), "--dry-run"])
    elif not dry_run or (home / ".agents").exists():
        say(f"Missing agent installer: {agent_installer}")
        return 1
    else:
        say("Would run ~/.agents/install.py after cloning; its conflicts cannot be checked yet.")

    if not dry_run:
        run_install_command(stow_command)
        run_install_command([sys.executable, str(agent_installer)])
    say("Dry run complete. No changes made." if dry_run else "Installation complete.")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="preview without cloning or linking")
    args = parser.parse_args()
    try:
        return install(Path.home(), dry_run=args.dry_run)
    except (OSError, RuntimeError, subprocess.CalledProcessError) as error:
        say(f"Installation failed: {error}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
