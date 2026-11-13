#!/usr/bin/env python3
"""Writes Formula/pkw.rb and Casks/packwing.rb for packwing's stable release.

The version is the one packwing's own apps update to: `channels.stable` in
release.json on packwing's `release` branch, which is only moved once a
release is published and signed (docs/releasing.md in packwing). The SHA-256
of each file is the digest GitHub keeps for the release's assets.

    scripts/bump.py            # the stable release
    scripts/bump.py v0.2.0     # a given one

GH_TOKEN, when set, is sent to the GitHub API, for its higher rate limit.
Prints the version written; leaves the files as they are when it is the one
they already have.
"""

import json
import os
import pathlib
import sys
import urllib.request

REPO = "hivepaas/packwing"
CHANNELS = f"https://raw.githubusercontent.com/{REPO}/release/release.json"
TAP = pathlib.Path(__file__).resolve().parent.parent

FORMULA = """\
class Pkw < Formula
  desc "Fast, safe archiver for the command line: ZIP, 7z, RAR, tar and more"
  homepage "https://packwing.app"
  version "{version}"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://raw.githubusercontent.com/hivepaas/packwing/release/release.json"
    strategy :json do |json|
      json.dig("channels", "stable")&.delete_prefix("v")
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v{version}/pkw_{version}_macos_aarch64.tar.gz"
      sha256 "{macos_aarch64}"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v{version}/pkw_{version}_macos_x86_64.tar.gz"
      sha256 "{macos_x86_64}"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v{version}/pkw_{version}_linux_aarch64.tar.gz"
      sha256 "{linux_aarch64}"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v{version}/pkw_{version}_linux_x86_64.tar.gz"
      sha256 "{linux_x86_64}"
    end
  end

  def install
    bin.install "pkw"
    man1.install Dir["man/*.1"]
    bash_completion.install "completions/pkw.bash" => "pkw"
    zsh_completion.install "completions/_pkw"
    fish_completion.install "completions/pkw.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{{bin}}/pkw --version")

    (testpath/"hello.txt").write "hello from Homebrew"
    system bin/"pkw", "create", "hello.zip", "hello.txt"
    rm "hello.txt"
    system bin/"pkw", "extract", "hello.zip"
    assert_equal "hello from Homebrew", (testpath/"hello/hello.txt").read
  end
end
"""

CASK = """\
cask "packwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "{version}"
  sha256 arm:   "{app_aarch64}",
         intel: "{app_x86_64}"

  url "https://github.com/hivepaas/packwing/releases/download/v#{{version}}/packwing_#{{version}}_macos_#{{arch}}.app.tar.gz"
  name "packwing"
  desc "File archiver that uses every core and opens archives safely"
  homepage "https://packwing.app"

  livecheck do
    url "https://raw.githubusercontent.com/hivepaas/packwing/release/release.json"
    strategy :json do |json|
      json.dig("channels", "stable")&.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Packwing.app"

  zap trash: [
    "~/Library/Application Support/packwing",
    "~/Library/Caches/packwing",
    "~/Library/Saved Application State/com.hivepaas.packwing.savedState",
  ]
end
"""

# The key in the templates for each of the release's files.
FILES = {
    "macos_aarch64": "pkw_{version}_macos_aarch64.tar.gz",
    "macos_x86_64": "pkw_{version}_macos_x86_64.tar.gz",
    "linux_aarch64": "pkw_{version}_linux_aarch64.tar.gz",
    "linux_x86_64": "pkw_{version}_linux_x86_64.tar.gz",
    "app_aarch64": "packwing_{version}_macos_aarch64.app.tar.gz",
    "app_x86_64": "packwing_{version}_macos_x86_64.app.tar.gz",
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
    tag = sys.argv[1] if len(sys.argv) > 1 else get(CHANNELS)["channels"]["stable"]
    version = tag.removeprefix("v")
    release = get(f"https://api.github.com/repos/{REPO}/releases/tags/v{version}", api=True)
    if release.get("draft") or release.get("prerelease"):
        sys.exit(f"v{version} is not a published release")
    digests = {a["name"]: a.get("digest") or "" for a in release["assets"]}

    values = {"version": version}
    for key, name in FILES.items():
        name = name.format(version=version)
        digest = digests.get(name, "")
        if not digest.startswith("sha256:"):
            sys.exit(f"v{version} has no SHA-256 for {name}")
        values[key] = digest.removeprefix("sha256:")

    for path, template in (("Formula/pkw.rb", FORMULA), ("Casks/packwing.rb", CASK)):
        (TAP / path).write_text(template.format(**values))
    print(version)


if __name__ == "__main__":
    main()
