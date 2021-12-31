# The macOSrice (steve's dotfiles)

<!-- Header & Preview Image -->
<p align="center">
    <img width="600" alt="My Desktop" src="https://github.com/hghann/osxrice/blob/master/screenshots/desktop.png">
</p>

<!-- Shields -->
<p align="center">
  <a href="https://github.com/hghann/osxrice/blob/master/LICENSE">
      <img src="https://img.shields.io/github/license/hghann/osxrice">
  </a>
  <a href="https://img.shields.io/github/languages/count/hghann/osxrice">
      <img src="https://img.shields.io/github/languages/count/hghann/osxrice">
  </a>
  <a href="https://img.shields.io/github/languages/code-size/hghann/osxrice">
      <img src="https://img.shields.io/github/languages/code-size/hghann/osxrice">
  </a>
  <a href="https://github.com/hghann/osxrice/pulse" alt="Activity">
      <img src="https://img.shields.io/github/commit-activity/m/hghann/osxrice">
  </a>
</p>

## Table of Contents

- [About this repo](#about-this-repo)
- [Highlights](#highlights)
- [Packages Overview](#packages-overview)
- [Install these dotfiles](#install-these-dotfiles-and-all-dependencies)
- [Post-Installation](#post-Installation)
- [The make Command](#the-make-command)
- [Customize](#customize)
- [Additional Resources](#additional-resources)
- [License](#license)

## About this repo

This repository contains my personal dotfiles. They are stored here for
convenience so that I may quickly access them on new machines or new installs.
Also, others may find some of my configurations helpful in customizing their
own dotfiles.

- Useful scripts are in `~/.local/bin/`
- Settings for:
	- alacritty (terminal emulator)
	- vim (text editor)
	- zsh (shell)
	- lf (file manager)
	- zathura (pdf viewer)
	- newsboat (rss reader)
	- other stuff like inputrc and more, etc.
- I try to minimize what's directly in `~` so:
	- All configs that can be in `~/.config/` are.
	- Some environmental variables have been set in `~/.zshenv` to move configs into `~/.config/`

## Highlights

- Minimal efforts to install everything, using a [Makefile](./Makefile)
- Mostly based around Homebrew, Caskroom, latest Bash + GNU Utils
- Great [Window management](https://github.com/hghann/osxrice/tree/master/.config/wm) (using Amethyst and Rectangle)
- Fast and colored prompt
- Updated macOS defaults
- Well-organized and easy to customize
- Supports both Apple Silicon (M1) and Intel chips

## Packages Overview

- [Homebrew](https://brew.sh) (packages: [Brewfile](./install/Brewfile))
- [homebrew-cask](https://github.com/Homebrew/homebrew-cask) (packages: [Caskfile](./install/Caskfile))
- Latest Git, Bash 4, Python 3, GNU coreutils, and curl
- `$EDITOR` (and Git editor) is [Vim](https://www.vim.org/)

## Install these dotfiles and all dependencies

This repo is managed by a makefile. Run `make` with no arguments to list
all commands that could be executed.

Use Makefile to deploy everything:

```
make init
```

On a sparkling fresh installation of macOS:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

The Xcode Command Line Tools includes `git` and `make` (not available on stock
macOS). Now there are two options:

1. Install this repo with `curl` available:

```bash
bash -c "`curl -fsSL https://raw.githubusercontent.com/webpro/dotfiles/master/remote-install.sh`"
```

This will clone or download, this repo to `~/osxrice` depending on the
availability of `git`, `curl` or `wget`.

2. Alternatively, clone manually into the desired location:

```bash
git clone https://github.com/hghann/osxrice.git ~/.dotfiles
```

Use the [Makefile](./Makefile) to install everything
[listed above](#package-overview), and [config](./config) (using
[make](https://www.gnu.org/software/make/)):

```bash
cd ~/osxrice
make
```

The installation process in the Makefile is tested on every push and every week
in this [GitHub Action](https://github.com/webpro/dotfiles/actions).

## Post-Installation

- `make macos` (set [macOS defaults](./macos/macOS.sh))
- `make dock` (set [Dock items](./macos/dock.sh))

## The `make` command

```bash
$ make help
Usage: make <command>

Commands:
    alacritty        Setup files for alacritty
    backup           Backup macOS packages using brew
    base             Install base system
    doas             Configure doas
    docker           Docker initial setup
    duti             Setup default applications
    grap             install grap - a groff preprocessor for drawing graphs
    help             Prints out Make help
    init             Inital deploy dotfiles on osx machine
    install          Install arch linux packages using pacman
    jot              install jot - a markdown style preprocessor for groff
    lf               Setup files for lf
    mpd              Setup files for mpd
    mpv              Setup files for mpv
    ncmpcpp          Setup files for ncmpcpp
    pip              Install python packages
    pipbackup        Backup python packages
    pipupdate        Update python packages
    pkg_base         Install base packages plus doas because sudo is bloat
    prog_base        Install base programs
    testinit         Test initial deploy dotfiles
    testpath         ECHO PATH
    update           Update macOS packages and save packages cache
    vim              Init vim
    vimupdate        Updates vim config
    walk             installs plan9 find SUDO NEEDED
    wm               Setup files for window managers
```

## Customize

You can put your custom settings, such as Git credentials in the `system/.custom` file which will be sourced from
`.bash_profile` automatically. This file is in `.gitignore`.

Alternatively, you can have an additional, personal dotfiles repo at `~/.extra`. The runcom `.bash_profile` sources all
`~/.extra/runcom/*.sh` files.

## Additional Resources

- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
- [Homebrew](https://brew.sh)
- [Homebrew Cask](https://github.com/Homebrew/homebrew-cask)
- [Bash prompt](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)
- [Lars Kappert's Dotfiles](https://github.com/webpro/dotfiles)
- [Luke Smith's Dotfiles](https://github.com/LukeSmithxyz/voidrice)

## License

The files and scripts in this repository are licensed under the MIT License,
which is a very permissive license allowing you to use, modify, copy,
distribute, sell, give away, etc. the software. In other words, do what you
want with it. The only requirement with the MIT License is that the license and
copyright notice must be provided with the software.
