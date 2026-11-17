"""Install personal configuration without replacing existing files."""

import argparse
from dataclasses import dataclass
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parent
PROFILE_DIR = ROOT / "profiles"
REPOSITORIES = {
    ".agents": "git@github.com:connor-kress/agents-config.git",
    "Scripts": "git@github.com:connor-kress/Scripts.git",
}


@dataclass(frozen=True)
class Profile:
    # Root paths to link; None links the whole root.
    shared_paths: "tuple[str, ...] | None"
    repositories: "tuple[str, ...]"
    gnome: bool = False
    # Profile-only files live in profiles/<name>/ when True.
    package: bool = False


PROFILES = {
    "desktop": Profile(shared_paths=None, repositories=(".agents", "Scripts"), gnome=True),
    "server": Profile(shared_paths=(".config/nvim",), repositories=(".agents",), package=True),
}
NOTIFICATION_EXTENSION = "dismiss-notification@local"


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


def check_repositories(home: Path, names: "tuple[str, ...]") -> bool:
    valid = True
    for name in names:
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


def shared_path_ignore(paths: "tuple[str, ...]") -> str:
    """Return a Stow --ignore regex that skips every root path outside `paths`."""
    allowed = "|".join(re.escape(path) for path in paths)
    ancestors = sorted({
        str(parent) for path in paths for parent in PurePosixPath(path).parents if str(parent) != "."
    })
    keep = f"(?:{allowed})(?:/|\\z)"
    if ancestors:
        keep += "|(?:" + "|".join(re.escape(path) for path in ancestors) + ")\\z"
    return f"\\A(?!{keep}).*"


def stow_commands(name: str, profile: Profile, home: Path) -> "list[list[str]]":
    base = ["stow", "--no-folding", "--verbose", f"--target={home}"]
    root = [*base, f"--dir={ROOT}"]
    if profile.shared_paths is not None:
        root.append(f"--ignore={shared_path_ignore(profile.shared_paths)}")
    commands = [[*root, "--stow", "."]]
    if profile.package:
        commands.append([*base, f"--dir={PROFILE_DIR}", "--stow", name])
    return commands


def check_profile(name: str, profile: Profile) -> bool:
    valid = True
    for path in profile.shared_paths or ():
        if not (ROOT / path).exists():
            say(f"Profile {name}: shared path {path} does not exist")
            valid = False
    if profile.package:
        package = PROFILE_DIR / name
        if not package.is_dir():
            say(f"Profile {name}: missing package directory {package}")
            return False
        for file in package.rglob("*"):
            relative = PurePosixPath(file.relative_to(package).as_posix())
            for path in profile.shared_paths or ():
                if relative == PurePosixPath(path) or PurePosixPath(path) in relative.parents:
                    say(f"Profile {name}: {relative} is also provided by shared path {path}")
                    valid = False
    return valid


def running_gnome() -> bool:
    desktop = os.environ.get("XDG_CURRENT_DESKTOP", "")
    if desktop:
        return "gnome" in desktop.lower().split(":")
    session = os.environ.get("XDG_SESSION_DESKTOP") or os.environ.get("DESKTOP_SESSION", "")
    return session.lower() == "gnome" or session.lower().startswith("gnome-")


def enable_notification_extension(*, dry_run: bool) -> None:
    result = subprocess.run(
        ["gnome-extensions", "list"],
        check=True, capture_output=True, text=True,
    )
    if NOTIFICATION_EXTENSION not in result.stdout.splitlines():
        say("GNOME must discover the notification extension: log out and back in, then rerun install.py.")
        return
    if dry_run:
        say(f"Would enable GNOME extension: {NOTIFICATION_EXTENSION}")
        return
    run_install_command(["gnome-extensions", "enable", NOTIFICATION_EXTENSION])
    run_install_command(["gsettings", "set", "org.gnome.shell", "disable-user-extensions", "false"])
    say(f"Enabled GNOME extension: {NOTIFICATION_EXTENSION}")


def install(home: Path, name: str, *, dry_run: bool) -> int:
    profile = PROFILES[name]
    for command in ("git", "stow"):
        if shutil.which(command) is None:
            say(f"Missing dependency: {command}. Install it and rerun install.py.")
            return 1

    if not check_profile(name, profile):
        say("Fix the profile definition and rerun install.py. No changes made.")
        return 1

    if not check_repositories(home, profile.repositories):
        say("Resolve the conflicts and rerun install.py. No changes made.")
        return 1

    say(f"Installing profile: {name}")
    commands = stow_commands(name, profile, home)
    # Let Stow check every dotfile conflict before cloning or linking anything.
    conflicts = [run_install_command([*command, "--simulate"], check=False) for command in commands]
    if any(conflicts):
        say("Resolve the Stow conflicts and rerun install.py. No changes made.")
        return 1

    keybinds_command = None
    if profile.gnome and running_gnome():
        if sys.version_info < (3, 11):
            say("GNOME shortcuts require Python 3.11+. Rerun install.py with a newer Python.")
            return 1
        for command in ("gsettings", "gnome-extensions", "gdbus"):
            if shutil.which(command) is None:
                say(f"Missing dependency: {command}. Install it and rerun install.py.")
                return 1
        keybinds_command = [sys.executable, str(ROOT / ".gnome" / "apply_keybinds.py")]
        say("Checking GNOME custom shortcuts...")
        run_install_command([*keybinds_command, "--dry-run"])
    elif profile.gnome:
        say("Skipping GNOME shortcuts and extensions: no GNOME session detected.")

    for repository in profile.repositories:
        url = REPOSITORIES[repository]
        destination = home / repository
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
        for command in commands:
            run_install_command(command)
        run_install_command([sys.executable, str(agent_installer)])
        if keybinds_command:
            say("")
            say("Applying GNOME custom shortcuts...")
            run_install_command(keybinds_command)
    if keybinds_command:
        enable_notification_extension(dry_run=dry_run)
    say("")
    say("Dry run complete. No changes made." if dry_run else "Installation complete.")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--profile", required=True, choices=PROFILES, help="configuration set to install")
    parser.add_argument("--dry-run", action="store_true", help="preview without changing files or settings")
    args = parser.parse_args()
    try:
        return install(Path.home(), args.profile, dry_run=args.dry_run)
    except (OSError, RuntimeError, subprocess.CalledProcessError) as error:
        say(f"Installation failed: {error}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
