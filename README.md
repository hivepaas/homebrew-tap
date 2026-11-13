# HivePaaS Homebrew tap

[Homebrew](https://brew.sh) formulae and casks for apps made by HivePaaS.

## packwing

[packwing](https://packwing.app) is a file archiver that uses every core of your computer
and opens archives safely: ZIP, 7z, RAR, tar, ISO and more.

`pkw`, the command line, on macOS and Linux:

```sh
brew install hivepaas/tap/pkw
```

The app, on macOS:

```sh
brew install --cask hivepaas/tap/packwing
```

The app also holds `pkw`, at `/Applications/Packwing.app/Contents/MacOS/pkw`, and updates
itself; `pkw` from the formula is updated by `brew upgrade`.

| | |
| --- | --- |
| [`pkw`](Formula/pkw.rb) | macOS 13 or later and Linux, on Apple silicon, Intel and ARM |
| [`packwing`](Casks/packwing.rb) | macOS 13 or later, Apple silicon and Intel |

## shellwing

[shellwing](https://shellwing.app) is a fast, native SSH client. The app, on macOS 13 or
later, Apple silicon and Intel:

```sh
brew install --cask hivepaas/tap/shellwing
```

It updates itself, as packwing does.

## How it is kept up to date

[Bump](.github/workflows/bump.yml) looks every three hours for each app's stable release, the
one the app itself updates to, and opens a pull request for it. The files' SHA-256 come from
the release on GitHub: [scripts/bump.py](scripts/bump.py) writes the formula and the casks from
[templates/](templates), so change them there. [Tests](.github/workflows/tests.yml) audits,
installs and tests them on macOS and Linux.

Problems with an app itself: [packwing](https://github.com/hivepaas/packwing/issues),
[shellwing](https://github.com/hivepaas/shellwing/issues).
