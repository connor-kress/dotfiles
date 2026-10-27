"""Add or update GNOME custom shortcuts from keybinds.toml without deleting others."""

import argparse
import ast
import os
from pathlib import Path
import re
import subprocess
import sys
import tomllib


CONFIG = Path(__file__).resolve().with_name("keybinds.toml")
SCHEMA = "org.gnome.settings-daemon.plugins.media-keys"
PREFIX = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/"
FIELDS = {"name": "name", "command": "command", "shortcut": "binding"}


def running_gnome() -> bool:
    desktop = os.environ.get("XDG_CURRENT_DESKTOP", "")
    if desktop:
        return "gnome" in desktop.lower().split(":")
    session = os.environ.get("XDG_SESSION_DESKTOP") or os.environ.get("DESKTOP_SESSION", "")
    return session.lower() == "gnome" or session.lower().startswith("gnome-")


def gsettings(*args: str) -> str:
    result = subprocess.run(["gsettings", *args], capture_output=True, text=True)
    if result.returncode:
        raise ValueError(result.stderr.strip() or "gsettings failed")
    if result.stderr:
        sys.stderr.write(result.stderr)
    return result.stdout.strip()


def get(schema: str, key: str):
    value = gsettings("get", schema, key)
    # GVariant annotates empty string arrays with their type.
    return ast.literal_eval(value.removeprefix("@as "))


def shortcut_id(shortcut: str) -> tuple:
    """Compare GNOME modifier aliases and modifier order consistently."""
    aliases = {"ctrl": "control", "primary": "control", "mod1": "alt"}
    modifiers = re.findall(r"<([^>]+)>", shortcut.lower())
    key = re.sub(r"<[^>]+>", "", shortcut).lower()
    return tuple(sorted({aliases.get(mod, mod) for mod in modifiers})), key


def load_config(path: Path) -> list[dict[str, str]]:
    with path.open("rb") as file:
        config = tomllib.load(file)
    entries = [entry for group in config["keybinds"] for entry in group.get("custom", [])]
    names = set()
    shortcuts = {}
    for entry in entries:
        for field in FIELDS:
            if not isinstance(entry.get(field), str) or not entry[field].strip():
                raise ValueError(f"Each shortcut needs a nonempty {field}")
            entry[field] = entry[field].strip()
        name = entry["name"]
        if name in names:
            raise ValueError(f"Duplicate shortcut name: {name}")
        names.add(name)
        shortcut = shortcut_id(entry["shortcut"])
        if shortcut in shortcuts:
            raise ValueError(f"{name} and {shortcuts[shortcut]} both use {entry['shortcut']}")
        shortcuts[shortcut] = name
    if not entries:
        raise ValueError("No custom shortcuts found")
    return entries


def apply(entries: list[dict[str, str]], *, dry_run: bool) -> None:
    paths = get(SCHEMA, "custom-keybindings")
    existing = {}
    by_name = {}
    for path in paths:
        schema = f"{SCHEMA}.custom-keybinding:{path}"
        entry = {field: get(schema, key) for field, key in FIELDS.items()}
        existing[path] = entry
        by_name.setdefault(entry["name"], []).append(path)

    changes = []
    for entry in entries:
        matches = by_name.get(entry["name"], [])
        if len(matches) > 1:
            raise ValueError(f"Multiple GNOME shortcuts named {entry['name']}; rename them first")
        if matches:
            path = matches[0]
        else:
            index = 0
            while f"{PREFIX}custom{index}/" in paths:
                index += 1
            path = f"{PREFIX}custom{index}/"
            paths.append(path)
        if path not in existing or any(
            entry[field] != existing[path][field] for field in ("name", "command")
        ) or shortcut_id(entry["shortcut"]) != shortcut_id(existing[path]["shortcut"]):
            changes.append((path, entry))

    # Check the final state, allowing two configured shortcuts to swap bindings.
    final = {**existing, **dict(changes)}
    configured_names = {entry["name"] for entry in entries}
    for path, entry in final.items():
        if entry["name"] not in configured_names:
            continue
        for other_path, other in final.items():
            if (
                other_path != path
                and other["shortcut"]
                and shortcut_id(entry["shortcut"]) == shortcut_id(other["shortcut"])
            ):
                raise ValueError(f"{entry['name']} conflicts with {other['name']} at {entry['shortcut']}")

    writes = []
    for path, entry in changes:
        action = "Update" if path in existing else "Add"
        print(f"{action}: {entry['name']} ({entry['shortcut']})")
        schema = f"{SCHEMA}.custom-keybinding:{path}"
        writes.extend((schema, key, entry[field]) for field, key in FIELDS.items())
    if paths != list(existing):
        writes.append((SCHEMA, "custom-keybindings", paths))

    # Check writability before changing any setting.
    for schema, key, _ in writes:
        if gsettings("writable", schema, key) != "true":
            raise ValueError(f"Setting is locked: {schema} {key}")
    if dry_run:
        print("Dry run complete. No settings changed.")
        return
    for schema, key, value in writes:
        gsettings("set", schema, key, repr(value))
    print(f"Applied {len(changes)} shortcut changes.")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="preview without changing settings")
    parser.add_argument("--config", type=Path, default=CONFIG, help="TOML file to apply")
    args = parser.parse_args()
    if not running_gnome():
        print("Cannot apply shortcuts: no GNOME session detected. Run this in a GNOME session.", file=sys.stderr)
        return 1
    try:
        apply(load_config(args.config), dry_run=args.dry_run)
    except (OSError, ValueError, KeyError, TypeError, SyntaxError) as error:
        print(f"Cannot apply shortcuts: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
