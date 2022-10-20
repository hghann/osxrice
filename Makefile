######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : Makefile
# @created     : Wed 7 Jul 11:14:15 2021
#
# @description : Inspired by Gavin Freeborn's video
#                (https://www.youtube.com/watch?v=aP8eggU2CaU)
######################################################################

BASE = $(PWD)
SCRIPTS = $(HOME)/.scripts
MKDIR = mkdir -p
LN = ln -vsf
LNDIR = ln -vs
SUDO = sudo
PKGINSTALL = brew install
PROGINSTALL = brew install --cask

scripts:
	make -s $(HOME)/.local/bin/scripts

$(HOME)/.local/bin/scripts:
	@test -d $(SCRIPTS) || git clone git@github.com:hghann/scripts.git $(SCRIPTS)

updatescripts:
	cd $(HOME)/.local/bin/scripts;\
		git pull

pass:
	git clone git@github.com:hghann/pass.git $(HOME)/.local/share/password-store

bookmarks:
	git clone git@github.com:hghann/bookmarks.git $(HOME)/.local/share/buku

startpage:
	git clone git@github.com:hghann/startpage.git $(HOME)/.local/share/startpage

vim: ## Init vim
	# requires vim
	git clone git@github.com:hghann/dotvim $(HOME)/.vim
	cd $(HOME)/.vim && make -f $(HOME)/.vim/Makefile

vimpush: ## Updates vim repo
	cd $(HOME)/.vim;\
		git pull;\
		git add .;\
		git commit -m "push via Makefile";\
		git push -u origin master

vimpull: ## Updates local vim config
	cd $(HOME)/.vim;\
		git pull

amethyst: ## Deploy window manager configs
	$(LN) $(PWD)/.config/amethyst/com.amethyst.Amethyst.plist $(HOME)/Library/Preferences/com.amethyst.Amethyst.plist

init: amethyst ## Inital deploy dotfiles on osx machine
	$(LN) $(PWD)/.bash_profile $(HOME)/.bash_profile
	$(LN) $(PWD)/.bashrc $(HOME)/.bashrc
	$(LN) $(PWD)/.profile $(HOME)/.profile
	$(LN) $(PWD)/.zshenv $(HOME)/.zshenv
	rm -rf $(HOME)/.config/zsh
	$(LNDIR) $(PWD)/.config/zsh $(HOME)/.config/zsh
	rm -rf $(HOME)/.config/brew
	$(LNDIR) $(PWD)/.config/brew $(HOME)/.config/brew
	rm -rf $(HOME)/.config/alacritty
	$(LNDIR) $(PWD)/.config/alacritty $(HOME)/.config/alacritty
	rm -rf $(HOME)/.config/lf
	$(LNDIR) $(PWD)/.config/lf $(HOME)/.config/lf
	rm -rf $(HOME)/.config/nvim
	$(LNDIR) $(PWD)/.config/nvim $(HOME)/.config/nvim
	rm -rf $(HOME)/.config/emacs
	$(LNDIR) $(PWD)/.config/emacs $(HOME)/.config/emacs
	rm -rf $(HOME)/.config/sc-im
	$(LNDIR) $(PWD)/.config/sc-im $(HOME)/.config/sc-im
	rm -rf $(HOME)/.config/mpv
	$(LNDIR) $(PWD)/.config/mpv $(HOME)/.config/mpv
	rm -rf $(HOME)/.config/mpd
	$(LNDIR) $(PWD)/.config/mpd $(HOME)/.config/mpd
	rm -rf $(HOME)/.config/ncmpcpp
	$(LNDIR) $(PWD)/.config/ncmpcpp $(HOME)/.config/ncmpcpp
	rm -rf $(HOME)/.config/newsboat
	$(LNDIR) $(PWD)/.config/newsboat $(HOME)/.config/newsboat
	rm -rf $(HOME)/.config/startpage
	$(LNDIR) $(PWD)/.config/startpage $(HOME)/.config/startpage
	rm -rf $(HOME)/.config/htop
	$(LNDIR) $(PWD)/.config/htop $(HOME)/.config/htop
	rm -rf $(HOME)/.config/btop
	$(LNDIR) $(PWD)/.config/btop $(HOME)/.config/btop
	rm -rf $(HOME)/.config/neofetch
	$(LNDIR) $(PWD)/.config/neofetch $(HOME)/.config/neofetch
	rm -rf $(HOME)/.config/gtk-3.0
	$(LNDIR) $(PWD)/.config/gtk-3.0 $(HOME)/.config/gtk-3.0
	rm -rf $(HOME)/.config/wget
	$(LNDIR) $(PWD)/.config/wget $(HOME)/.config/wget
	rm -rf $(HOME)/.config/zathura
	$(LNDIR) $(PWD)/.config/zathura $(HOME)/.config/zathura
	$(LN) $(PWD)/.config/starship.toml $(HOME)/.config/starship.toml
	rm -rf $(HOME)/.config/bat
	$(LNDIR) $(PWD)/.config/bat $(HOME)/.config/bat
	rm -rf $(HOME)/.config/amethyst
	$(LNDIR) $(PWD)/.config/amethyst $(HOME)/.config/amethyst
	rm -rf $(HOME)/.qutebrowser
	$(LNDIR) $(PWD)/.config/qutebrowser $(HOME)/.qutebrowser
	rm -rf $(HOME)/.local/bin
	$(LNDIR) $(PWD)/.local/bin $(HOME)/.local/bin
	rm -rf $(HOME)/.local/share/groff
	$(LNDIR) $(PWD)/.local/share/groff $(HOME)/.local/share/groff

shell: ## Setup shell and prompt
	$(LN) $(PWD)/.bash_profile $(HOME)/.bash_profile
	$(LN) $(PWD)/.bashrc $(HOME)/.bashrc
	$(LN) $(PWD)/.profile $(HOME)/.profile
	$(LN) $(PWD)/.zshenv $(HOME)/.zshenv
	rm -rf $(HOME)/.config/zsh
	$(LNDIR) $(PWD)/.config/zsh $(HOME)/.config/zsh

alacritty: ## Deploy Alacritty configs
	$(MKDIR) $(HOME)/.config/alacritty
	$(LN) $(PWD)/.config/alacritty/alacritty.yml $(HOME)/.config/alacritty/alacritty.yml

lf: ## Deploy lf configs
	$(MKDIR) $(HOME)/.config/lf
	$(LN) $(PWD)/.config/lf/cleaner $(HOME)/.config/lf/cleaner
	$(LN) $(PWD)/.config/lf/lfrc $(HOME)/.config/lf/lfrc
	$(LN) $(PWD)/.config/lf/preview $(HOME)/.config/lf/preview

mpv: ## Deploy mpv configs
	$(MKDIR) $(HOME)/.config/mpv
	$(LN) $(PWD)/.config/mpv/input.conf $(HOME)/.config/mpv/input.conf
	$(LN) $(PWD)/.config/mpv/mpv.conf $(HOME)/.config/mpv/mpv.conf

mpd: ## Deploy mpd configs
	$(MKDIR) $(HOME)/.config/mpd
	touch $(HOME)/.config/mpd/{mpd.db,mpd.log,mpd.pid,mpdstate}
	$(LN) $(PWD)/.config/mpd/mpd.conf $(HOME)/.config/mpd/mpd.conf

ncmpcpp: mpd ## Deploy ncmpcpp configs
	$(MKDIR) $(HOME)/.config/ncmpcpp
	$(LN) $(PWD)/.config/ncmpcpp/config $(HOME)/.config/ncmpcpp/config

duti: ## Setup default applications
	$(PKGINSTALL) duti; $(PROGINSTALL) skim;\
		defaults-xdg.sh

PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man
TMPDIR = $(PWD)/tmp
DESTDIR = ?
PASSEMAIL = johnDoe@email.com

doas: ## Install and configure doas
	xcode-select --install
	$(MKDIR) $(TMPDIR)
	git clone https://github.com/slicer69/doas.git $(TMPDIR)/$<
		cd $(TMPDIR)/$<
		gmake
		gmake install
		cp /etc/pam.d/sudo /etc/pam.d/doas
	rm -rf $(TMPDIR)
	sudo echo "permit persist keepenv $(USER) as root" >> /usr/local/etc/doas.conf

# Please also note that macOS systems have been reported to have their /usr
# and/or /usr/local directories set to be writable to regular user accounts
# when homebrew is installed. If this is the case, fix this before installing
# doas. Having these directories, like /usr/local/bin and /usr/local/etc,
# writable to your user means anyone can remove and replace your doas.conf file
# or the doas binary, allowing anyone or any program to run commands as root on
# your system or harvest your password. This is a large security hole and
# outside the scope of doas.

mutt: ## Init neomutt using mutt-wizard by Luke smith
	$(PROGINSTALL) neomutt isync msmtp pass gpg
	$(MKDIR) $(TMPDIR)
	git clone https://github.com/hghann/mutt-wizard.git $(TMPDIR)/$<
	cd $(TMPDIR)/$<
		make install
		gpg --full-gen-key
		pass init $(PASSEMAIL)
	rm -rf $(TMPDIR)

jot: ## Install jot - a markdown style preprocessor for groff
	$(MKDIR) $(TMPDIR)
	git clone https://gitlab.com/rvs314/jot.git $(TMPDIR)/$<
	rm -rf $(TMPDIR)

# grap can be found here: https://www.lunabase.org/~faber/Vault/software/grap/
#               and here: https://github.com/snorerot13/grap
grap: ## Install grap - a groff preprocessor for drawing graphs
	$(MKDIR) $(TMPDIR)
	git clone https://github.com/snorerot13/grap.git $(TMPDIR)/$<
	rm -rf $(TMPDIR)

walk: ## Installs plan9 find SUDO NEEDED
	$(MKDIR) $(TMPDIR)
	git clone https://github.com/google/walk.git $(TMPDIR)/walk
	cd $(TMPDIR)/walk && make
	$(MKDIR) $(DESTDIR)$(PREFIX)/bin
	# installing walk
	cp -f     $(TMPDIR)/walk/walk   $(DESTDIR)$PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/walk
	cp -f     $(TMPDIR)/walk/walk.1 $(DESTDIR)$(MANPREFIX)/man1/walk.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/walk.1
	# installing sor
	cp -f     $(TMPDIR)/walk/sor   $(DESTDIR)$PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/sor
	cp -f     $(TMPDIR)/walk/sor.1 $(DESTDIR)$(MANPREFIX)/man1/sor.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/sor.1

pkg_base: ## Install base packages plus doas because sudo is bloat
	$(PKGINSTALL) coreutils cmake groff grap bat ffmpeg gcc fzf gnupg exa \
		exiftool figlet htop btop imagemagick lf make mas neofetch neovim \
		newsboat pandoc pass pfetch sc-im speedtest-cli smartmontools \
		trash-cli wifi-password wget xpdf yt-dlp zsh-autosuggestions \
		zsh-syntax-highlighting m4 make duti

prog_base: ## Install base programs
	$(PROGINSTALL) keepassxc lulu alacritty amethyst librewolf cryptomator \
		mactex hiddenbar keepingyouawake macfuse mpv qutebrowser rectangle \
		skim signal veracrypt vmware-horizon-client monitorcontrol

base: ## Install base system
	xcode-select --install
	pkg_base prog_base

macos: ## Apply macOS system defaults
	$(PWD)/.local/bin/macOS.sh

dock: ## Apply macOS dock settings
	$(PWD)/.local/bin/dock.sh

install: ## Install macOS packages using brew
	xargs $(PKGINSTALL) < $(PWD)/pkg/brewlist

backup: ## Backup macOS packages using brew
	$(MKDIR) $(PWD)/pkg
	brew list -1 --full-name > $(PWD)/pkg/brewlist

update: ## Update system and packages, and save packages cache
	sudo softwareupdate -i -a;\
		brew update -v;\
		brew upgrade -v --display-times;\
		cd $(HOME)/.config/brew;\
		brew bundle -v;\
		brew cu -afyv;\
		cd; brew doctor -v

syncdots: ## Push changes to git repo
	git pull;\
		git add .;\
		git commit -m "minor edits";\
		git push -u origin master

#pip: ## Install python packages
#	pip install --user --upgrade pip
#	pip install --user 'python-language-server[all]'

pipbackup: ## Backup python packages
	$(MKDIR) $(PWD)/pkg
	pip freeze > $(PWD)/pkg/piplist

pipupdate: ## Update python packages
	pip list --user | cut -d" " -f 1 | tail -n +3 | xargs pip install -U --user

testpath: ## echo $PATH
	PATH=$$PATH
	@echo $$PATH
	echo $(PWD)
	PWD=$(PWD)
	echo $(HOME)
	HOME=$(HOME)

osxinstall: base init doas sudo suspend scripts vim vm duti

allinstall: base init

allupdate: update vimupdate scriptsupdate

allbackup: backup

.DEFAULT_GOAL := help
.PHONY: allinstall allupdate allbackup

help: ## Prints out Make help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
