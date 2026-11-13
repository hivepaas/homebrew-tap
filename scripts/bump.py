#!/usr/bin/env python3
"""Writes an app's formula and casks for its stable release.

    scripts/bump.py packwing            # its stable release
    scripts/bump.py shellwing v0.3.0    # a given one

The version is the one the app itself updates to: `channels.stable` in
release.json on its repository's `release` branch, which is only moved once
a release is published and signed. The SHA-256 of each file is the digest
GitHub keeps for the release's assets. Each file is written from its template
in templates/, where @version@ is the version and @key@ the SHA-256 of the
file FILES names by that key.

GH_TOKEN, when set, is sent to the GitHub API, for its higher rate limit.
Prints the version written.
"""

import json
import os
import pathlib
import re
import sys
import urllib.request

TAP = pathlib.Path(__file__).resolve().parent.parent

APPS = {
    "packwing": {
        "repo": "hivepaas/packwing",
        "files": {
            "macos_aarch64": "pkw_{version}_macos_aarch64.tar.gz",
            "macos_x86_64": "pkw_{version}_macos_x86_64.tar.gz",
            "linux_aarch64": "pkw_{version}_linux_aarch64.tar.gz",
            "linux_x86_64": "pkw_{version}_linux_x86_64.tar.gz",
            "app_aarch64": "packwing_{version}_macos_aarch64.app.tar.gz",
            "app_x86_64": "packwing_{version}_macos_x86_64.app.tar.gz",
        },
        "writes": {"Formula/pkw.rb": "pkw.rb.in", "Casks/packwing.rb": "packwing.rb.in"},
    },
    "shellwing": {
        "repo": "hivepaas/shellwing",
        "files": {
            "aarch64": "shellwing_{version}_macos_aarch64.app.tar.gz",
            "x86_64": "shellwing_{version}_macos_x86_64.app.tar.gz",
        },
        "writes": {"Casks/shellwing.rb": "shellwing.rb.in"},
    },
}


def get(url, api=False):
    headers = {"User-Agent": "homebrew-tap-bump"}
    if api:
        headers["Accept"] = "application/vnd.github+json"
        token = os.environ.get("GH_TOKEN")
        if token:
            headers["Authorization"] = f"Bearer {token}"
    with urllib.request.urlopen(urllib.request.Request(url, headers=headers), timeout=60) as r:
        return json.load(r)


def main():
    if len(sys.argv) not in (2, 3) or sys.argv[1] not in APPS:
        sys.exit(f"usage: bump.py {'|'.join(APPS)} [vX.Y.Z]")
    app = APPS[sys.argv[1]]
    repo = app["repo"]
    if len(sys.argv) == 3:
        tag = sys.argv[2]
    else:
        tag = get(f"https://raw.githubusercontent.com/{repo}/release/release.json")["channels"]["stable"]
    version = tag.removeprefix("v")
    release = get(f"https://api.github.com/repos/{repo}/releases/tags/v{version}", api=True)
    if release.get("draft") or release.get("prerelease"):
        sys.exit(f"{repo} v{version} is not a published release")
    digests = {a["name"]: a.get("digest") or "" for a in release["assets"]}

    values = {"version": version}
    for key, name in app["files"].items():
        name = name.format(version=version)
        digest = digests.get(name, "")
        if not digest.startswith("sha256:"):
            sys.exit(f"{repo} v{version} has no SHA-256 for {name}")
        values[key] = digest.removeprefix("sha256:")

    for path, template in app["writes"].items():
        text = (TAP / "templates" / template).read_text()
        for key, value in values.items():
            text = text.replace(f"@{key}@", value)
        left = re.findall(r"@[a-z0-9_]+@", text)
        if left:
            sys.exit(f"{template}: nothing for {', '.join(left)}")
        (TAP / path).write_text(text)
    print(version)


if __name__ == "__main__":
    main()
