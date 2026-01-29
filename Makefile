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
DOTS_DIR = $(BASE)/.config
CONF_DIR = $(HOME)/.config
MKDIR = mkdir -p
LN = ln -vsf
LNDIR = ln -vs
SUDO = sudo
PKGINSTALL = brew install
PROGINSTALL = brew install --cask

check-dirs: ## Check paths in vars
	@echo "BASE: $(BASE)"
	@echo "SCRIPTS: $(SCRIPTS)"
	@echo "DOTS_DIR: $(DOTS_DIR)"
	@echo "CONF_DIR: $(CONF_DIR)"

# ----------------------------------------------------------------------
# MACRO: LINK_CONFIG
# Usage: $(call LINK_CONFIG,<app_name>)
# ----------------------------------------------------------------------
define LINK_CONFIG
	@echo "Linking $(1) config..."
	@if [ -L "$(CONF_DIR)/$(1)" ]; then \
		echo "Link already exists, skipping."; \
	else \
		if [ -d "$(CONF_DIR)/$(1)" ]; then \
			echo "Moving existing directory to backup: $(CONF_DIR)/$(1).bak"; \
			mv "$(CONF_DIR)/$(1)" "$(CONF_DIR)/$(1).bak"; \
		fi; \
		ln -snf "$(DOTS_DIR)/$(1)" "$(CONF_DIR)/$(1)"; \
		echo "Done: $(CONF_DIR)/$(1) -> $(DOTS_DIR)/$(1)"; \
	fi
endef

# Define a collective 'link-all' target for convenience
link-all: link-brew link-ghostty

link-brew: ## Symlink homebrew dir from dotfiles to .config
	$(call LINK_CONFIG,homebrew)

link-ghostty: ## Symlink ghostty dir from dotfiles to .config
	$(call LINK_CONFIG,ghostty)

# Add a .PHONY target for good practice
.PHONY: link-all link-brew link-ghostty

# ----------------------------------------------------------------------
# MACRO: LINK_SPECIAL_PATH
# Usage: $(call LINK_SPECIAL_PATH,<source_path>,<destination_path>)
# ----------------------------------------------------------------------
# define LINK_SPECIAL_PATH
# 	@if [ -d "$(2)" ] && [ ! -L "$(2)" ]; then \
# 		echo "Backing up existing directory: $(2).bak"; \
# 		mv "$(2)" "$(2).bak"; \
# 	fi; \
# 	ln -snf "$(1)" "$(2)"; \
# 	echo "Linked special path: $(2)";
# endef
define LINK_SPECIAL_PATH
	@if [ -L "$(2)" ]; then \
		echo "Link already exists, skipping: $(2)"; \
	else \
		if [ -d "$(2)" ] && [ ! -L "$(2)" ]; then \
			echo "Backing up existing directory: $(2).bak"; \
			mv "$(2)" "$(2).bak"; \
		fi; \
		ln -snf "$(1)" "$(2)"; \
		echo "Linked special path: $(2)"; \
	fi
endef

# ----------------------------------------------------------------------
# MACRO: LINK_SPECIAL_PATH_OLD {{{
#
# define LINK_SPECIAL_PATH
# 	@if [ -d "$(2)" ] && [ ! -L "$(2)" ]; then \
# 		echo "Backing up existing directory: $(2).bak"; \
# 		mv "$(2)" "$(2).bak"; \
# 	fi; \
# 	ln -snf "$(1)" "$(2)"; \
# 	echo "Linked special path: $(2)";
# endef
#
# }}}
# ----------------------------------------------------------------------

test-spm: ## Temporary debugging target to inspect LINK_SPECIAL_PATH macro expansion
	@echo "--- Expanded Macro for .local/tmp (Source: $(PWD)/.local/tmp, Dest: $(HOME)/.local/tmp) ---"
	$(call LINK_SPECIAL_PATH,$(PWD)/.local/tmp,$(HOME)/.local/tmp)
	@echo "--- End of Expansion ---"

clean-spm:
	@echo "--- Cleaning up files created by test-spm ---"
	rm -rf $(HOME)/.local/tmp $(HOME)/.local/tmp.bak
	@echo "--- Cleanup complete ---"

.PHONY: test-spm clean-spm

nocupshist: ## Disable CUPS pinter job history on macOS
	# purges /var/spool/cups
	cancel -a -x
	# create /usr/local/sbin director
	sudo mkdir -p /usr/local/sbin
	sudo chown ${USER}:admin /usr/local/sbin
	# create cups.sh script
	$(SUDO) cp $(PWD)/usr/local/sbin/cups.sh /usr/local/sbin/cups.sh
	/usr/local/sbin/cups.sh
	# make cups.sh executable
	chmod +x /usr/local/sbin/cups.sh
	# create local.cups.plist launch daemon
	$(PWD)/.local/bin/nocupshistd
	# reboot

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

vim-dots: ## Init vim from dotfiles repo
	# requires vim
	$(LN) $(PWD)/.vimrc $(HOME)/.vimrc
	$(LN) $(PWD)/.vimrc $(HOME)/.config/nvim/init.vim

vim-git: ## Init vim from vim repo
	# requires vim
	git clone git@github.com:hghann/dotvim $(HOME)/.vim
	cd $(HOME)/.vim && make -f $(HOME)/.vim/Makefile

vimpush: ## Updates vim repo
	cd $(HOME)/.vim;\
		git pull;\
		git add .;\
		git commit -m "Automated push via Makefile";\
		git push -u origin master

vimpull: ## Updates local vim config
	cd $(HOME)/.vim;\
		git pull

arkenfox: ## Setup Arkenfox via cp
	#@ # uncomment to suppress echoing, only showing command output
	@FF_DIR=$(HOME)/Library/ApplicationSupport/Firefox; \
	PREFIX=$$(grep "Path=" $$FF_DIR/profiles.ini | grep "default-release" | cut -d'=' -f2 | cut -d'.' -f1); \
	if [ -z "$$PREFIX" ]; then \
		echo "Error: Profile prefix not found"; \
		exit 1; \
	fi; \
	SOURCE=$(PWD)/Library/ApplicationSupport/Firefox/Profiles/profile.default-release/; \
	DEST=$$FF_DIR/$$PREFIX.default-release; \
	echo "Copying osxrice files to $$DEST..."; \
	mkdir -p "$$DEST"; \
	cp -rvp "$$SOURCE"* "$$DEST"; \
	echo "Changing directory to $$DEST and running 'make update'..."; \
	cd "$$DEST" && make -f Makefile.arkenfox update

# {{{
#arkenfox: ## Setup Arkenfox via Symlinks
#	@FF_DIR=~/Library/Application\ Support/Firefox; \
#	PREFIX=$$(grep "Path=" "$$FF_DIR/profiles.ini" | grep "default-release" | cut -d'=' -f2 | cut -d'/' -f2 | cut -d'.' -f1); \
#	if [ -z "$$PREFIX" ]; then \
#		echo "Error: Profile prefix not found"; \
#		exit 1; \
#	fi; \
#	SOURCE=~/.dots/Library/Application\ Support/Firefox/Profiles/profile.default-release; \
#	DEST="$$FF_DIR/Profiles/$$PREFIX.default-release"; \
#	echo "Symlinking osxrice files to $$DEST..."; \
#	mkdir -p "$$DEST"; \
#	for file in "$$SOURCE"/*; do \
#		ln -shf "$$file" "$$DEST/$$(basename "$$file")"; \
#	done; \
#	echo "Running 'make update' in $$DEST..."; \
#	cd "$$DEST" && make update
# }}}

amethyst: ## Deploy window manager configs
	$(LN) $(PWD)/.config/amethyst/com.amethyst.Amethyst.plist $(HOME)/Library/Preferences/com.amethyst.Amethyst.plist

BASH_FILES := .bash_profile .bashrc .profile .zshenv
CONFIG_APPS := zsh homebrew alacritty ghostty lf nvim helix emacs sc-im \
               mpv mpd ncmpcpp newsboat startpage htop btop neofetch \
               gtk-3.0 wget zathura bat amethyst qutebrowser

# {{{
# ----------------------------------------------------------------------
# Target: init
# ----------------------------------------------------------------------
#init: amethyst ## Initial deploy dotfiles on osx machine
#	@echo "Linking shell profiles..."
#	@$(foreach f,$(BASH_FILES),ln -snf $(PWD)/$(f) $(HOME)/$(f);)
#	@echo "Linking .config directories..."
#	@$(foreach app,$(CONFIG_APPS),$(call LINK_CONFIG,$(app)))
#	@echo "Handling special paths..."
#	@ln -snf $(PWD)/.config/starship.toml $(HOME)/.config/starship.toml
#	@# Handle .local/bin
#	@if [ -d "$(HOME)/.local/bin" ] && [ ! -L "$(HOME)/.local/bin" ]; then mv $(HOME)/.local/bin $(HOME)/.local/bin.bak; fi
#	@ln -snf $(PWD)/.local/bin $(HOME)/.local/bin
#	@# Handle .local/share/groff
#	@if [ -d "$(HOME)/.local/share/groff" ] && [ ! -L "$(HOME)/.local/share/groff" ]; then mv $(HOME)/.local/share/groff $(HOME)/.local/share/groff.bak; fi
#	@ln -snf $(PWD)/.local/share/groff $(HOME)/.local/share/groff
#	@echo "Init complete!"
# }}}

# ----------------------------------------------------------------------
# Target: init (Updated to use macro)
# ----------------------------------------------------------------------
init: amethyst ## Initial deploy dotfiles on osx machine
	@echo "Linking shell profiles..."
	@$(foreach f,$(BASH_FILES),ln -snf $(PWD)/$(f) $(HOME)/$(f);)
	@echo "Linking .config directories..."
	@$(foreach app,$(CONFIG_APPS),$(call LINK_CONFIG,$(app)))
	@echo "Handling special paths..."
	@ln -snf $(PWD)/.config/starship.toml $(HOME)/.config/starship.toml
	@# Handle .local/bin
	$(call LINK_SPECIAL_PATH,$(PWD)/.local/bin,$(HOME)/.local/bin)
	@# Handle .local/share/groff
	$(call LINK_SPECIAL_PATH,$(PWD)/.local/share/groff,$(HOME)/.local/share/groff)
	@echo "Init complete!"

# ----------------------------------------------------------------------
# (COMMENTED REFERENCE BLOCK) {{{
# The original 'init' target is commented out below for historical reference.
# This block is ignored by 'make'.
#
#init: amethyst ## Inital deploy dotfiles on osx machine
#	$(LN) $(PWD)/.bash_profile $(HOME)/.bash_profile
#	$(LN) $(PWD)/.bashrc $(HOME)/.bashrc
#	$(LN) $(PWD)/.profile $(HOME)/.profile
#	$(LN) $(PWD)/.zshenv $(HOME)/.zshenv
#	rm -rf $(HOME)/.config/zsh
#	$(LNDIR) $(PWD)/.config/zsh $(HOME)/.config/zsh
#	rm -rf $(HOME)/.config/homebrew
#	$(LNDIR) $(PWD)/.config/homebrew $(HOME)/.config/homebrew
#	rm -rf $(HOME)/.config/alacritty
#	$(LNDIR) $(PWD)/.config/alacritty $(HOME)/.config/alacritty
#	rm -rf $(HOME)/.config/ghostty
#	$(LNDIR) $(PWD)/.config/ghostty $(HOME)/.config/ghostty
#	rm -rf $(HOME)/.config/lf
#	$(LNDIR) $(PWD)/.config/lf $(HOME)/.config/lf
#	rm -rf $(HOME)/.config/nvim
#	$(LNDIR) $(PWD)/.config/nvim $(HOME)/.config/nvim
#	rm -rf $(HOME)/.config/helix
#	$(LNDIR) $(PWD)/.config/helix $(HOME)/.config/helix
#	rm -rf $(HOME)/.config/emacs
#	$(LNDIR) $(PWD)/.config/emacs $(HOME)/.config/emacs
#	rm -rf $(HOME)/.config/sc-im
#	$(LNDIR) $(PWD)/.config/sc-im $(HOME)/.config/sc-im
#	rm -rf $(HOME)/.config/mpv
#	$(LNDIR) $(PWD)/.config/mpv $(HOME)/.config/mpv
#	rm -rf $(HOME)/.config/mpd
#	$(LNDIR) $(PWD)/.config/mpd $(HOME)/.config/mpd
#	rm -rf $(HOME)/.config/ncmpcpp
#	$(LNDIR) $(PWD)/.config/ncmpcpp $(HOME)/.config/ncmpcpp
#	rm -rf $(HOME)/.config/newsboat
#	$(LNDIR) $(PWD)/.config/newsboat $(HOME)/.config/newsboat
#	rm -rf $(HOME)/.config/startpage
#	$(LNDIR) $(PWD)/.config/startpage $(HOME)/.config/startpage
#	rm -rf $(HOME)/.config/htop
#	$(LNDIR) $(PWD)/.config/htop $(HOME)/.config/htop
#	rm -rf $(HOME)/.config/btop
#	$(LNDIR) $(PWD)/.config/btop $(HOME)/.config/btop
#	rm -rf $(HOME)/.config/neofetch
#	$(LNDIR) $(PWD)/.config/neofetch $(HOME)/.config/neofetch
#	rm -rf $(HOME)/.config/gtk-3.0
#	$(LNDIR) $(PWD)/.config/gtk-3.0 $(HOME)/.config/gtk-3.0
#	rm -rf $(HOME)/.config/wget
#	$(LNDIR) $(PWD)/.config/wget $(HOME)/.config/wget
#	rm -rf $(HOME)/.config/zathura
#	$(LNDIR) $(PWD)/.config/zathura $(HOME)/.config/zathura
#	$(LN) $(PWD)/.config/starship.toml $(HOME)/.config/starship.toml
#	rm -rf $(HOME)/.config/bat
#	$(LNDIR) $(PWD)/.config/bat $(HOME)/.config/bat
#	rm -rf $(HOME)/.config/amethyst
#	$(LNDIR) $(PWD)/.config/amethyst $(HOME)/.config/amethyst
#	rm -rf $(HOME)/.qutebrowser
#	$(LNDIR) $(PWD)/.config/qutebrowser $(HOME)/.qutebrowser
#	rm -rf $(HOME)/.local/bin
#	$(LNDIR) $(PWD)/.local/bin $(HOME)/.local/bin
#	rm -rf $(HOME)/.local/share/groff
#	$(LNDIR) $(PWD)/.local/share/groff $(HOME)/.local/share/groff
#
# }}}
# ----------------------------------------------------------------------

shell: ## Setup shell and prompt
	$(LN) $(PWD)/.bash_profile $(HOME)/.bash_profile
	$(LN) $(PWD)/.bashrc $(HOME)/.bashrc
	$(LN) $(PWD)/.profile $(HOME)/.profile
	$(LN) $(PWD)/.zshenv $(HOME)/.zshenv
	rm -rf $(HOME)/.config/zsh
	$(LNDIR) $(PWD)/.config/zsh $(HOME)/.config/zsh

brew: ## Deploy Homebrew configs
	$(MKDIR) $(HOME)/.config/homebrew
	$(LN) $(PWD)/.config/homebrew/brew.env $(HOME)/.config/homebrew/brew.env
	$(LN) $(PWD)/.config/homebrew/Brewfile $(HOME)/.config/homebrew/Brewfile

# {{{  <-- Start of the fold marker
#link-brew: ## Symlink homebrew dir from dotfiles to .config
#	@echo "Linking Homebrew config..."
#	@if [ -L "$(CONF_DIR)/homebrew" ]; then \
#		echo "Link already exists, skipping."; \
#	elif [ -d "$(CONF_DIR)/homebrew" ]; then \
#		echo "Backing up existing directory to $(CONF_DIR)/homebrew.bak"; \
#		mv $(CONF_DIR)/homebrew $(CONF_DIR)/homebrew.bak; \
#		ln -s $(DOTS_DIR)/homebrew $(CONF_DIR)/homebrew; \
#	else \
#		ln -s $(DOTS_DIR)/homebrew $(CONF_DIR)/homebrew; \
#	fi
#	@echo "Done! $(CONF_DIR)/homebrew -> $(DOTS_DIR)/homebrew"
# }}}  <-- End of the fold marker

alacritty: ## Deploy Alacritty configs
	$(MKDIR) $(HOME)/.config/alacritty
	$(LN) $(PWD)/.config/alacritty/alacritty.yml $(HOME)/.config/alacritty/alacritty.yml

ghostty: ## Deploy Ghostty configs
	$(MKDIR) $(HOME)/.config/ghostty
	$(LN) $(PWD)/.config/ghostty/config $(HOME)/.config/ghostty/config

# {{{
#link-ghostty: ## Symlink ghostty dir from dotfiles to .config
#	@echo "Linking Ghostty config..."
#	@if [ -L "$(CONF_DIR)/ghostty" ]; then \
#		echo "Link already exists, skipping."; \
#	elif [ -d "$(CONF_DIR)/ghostty" ]; then \
#		echo "Backing up existing directory to $(CONF_DIR)/ghostty.bak"; \
#		mv $(CONF_DIR)/ghostty $(CONF_DIR)/ghostty.bak; \
#		ln -s $(DOTS_DIR)/ghostty $(CONF_DIR)/ghostty; \
#	else \
#		ln -s $(DOTS_DIR)/ghostty $(CONF_DIR)/ghostty; \
#	fi
#	@echo "Done! $(CONF_DIR)/ghostty -> $(DOTS_DIR)/ghostty"
#	}}}

ghostty-ssh: ## Inject Ghostty terminfo (Prompts if HOST is not provided)
	@# Usage 1 (Prompt): make ghostty
	@# Usage 2 (Direct): make ghostty HOST=user@192.168.1.1
	@if [ -z "$(HOST)" ]; then \
		read -p "Enter user@remote-host: " target; \
	else \
		target="$(HOST)"; \
	fi; \
	echo "Injecting Ghostty terminfo to $$target..."; \
	infocmp -x | ssh $$target "mkdir -p ~/.terminfo && tic -x -o ~/.terminfo /dev/stdin"

lf: ## Deploy lf configs
	$(MKDIR) $(HOME)/.config/lf
	$(LN) $(PWD)/.config/lf/cleaner $(HOME)/.config/lf/cleaner
	$(LN) $(PWD)/.config/lf/lfrc $(HOME)/.config/lf/lfrc
	$(LN) $(PWD)/.config/lf/preview $(HOME)/.config/lf/preview

yazi: ## Deploy yazi configs
	$(LN) $(PWD)/.config/yazi/init.lua $(HOME)/.config/yazi/init.lua
	$(LN) $(PWD)/.config/yazi/keymap.toml $(HOME)/.config/yazi/keymap.toml
	$(LN) $(PWD)/.config/yazi/package.toml $(HOME)/.config/yazi/package.toml
	$(LN) $(PWD)/.config/yazi/theme.toml $(HOME)/.config/yazi/theme.toml
	$(LN) $(PWD)/.config/yazi/yazi.toml $(HOME)/.config/yazi/yazi.toml
	@#$(MKDIR) $(HOME)/.config/yazi/plugins/{easyjump.yazi,full-border.yazi,jump-to-char.yazi,smart-enter.yazi}
	$(LNDIR) $(PWD)/.config/yazi/plugins $(HOME)/.config/yazi/plugins

# Define ANSI color codes
GREEN  := \033[0;32m
YELLOW := \033[0;33m
NC     := \033[0m # No Color (reset)
BLUE   := \033[0;34m

PACKAGE_NAME = claws-mail fileicon
USER_APP_DIR = $(HOME)/Applications
APP_LINK_PATH = $(USER_APP_DIR)/ClawsMail
# Create a folder ending in .app, which macOS recognizes as a GUI app
APP_BUNDLE = $(USER_APP_DIR)/ClawsMail.app

ICON_DIR = $(PWD)/.local/share/icons/hicolor
ICON_PNG = $(ICON_DIR)/128x128/apps/claws_icon.png
ICON_FILE = $(ICON_DIR)/scalable/apps/claws_icon.icns

ICON_URL = "https://git.claws-mail.org/?p=claws.git;a=blob_plain;f=claws-mail-128x128.png;hb=HEAD"

IS_INSTALLED := $(shell brew list --formulae | grep "$(PACKAGE_NAME)" || true)

.PHONY: claws-install claws-mail claws-clean claws-icon dl-claws-icon prep-claws-icon

claws-install: dl-claws-icon prep-claws-icon claws-mail claws-icon

dl-claws-icon:
	@# Ensure the XDG directories exist quietly
	@mkdir -p $(ICON_DIR)/{128x128,scalable}/apps
ifeq ($(wildcard $(ICON_PNG)),)
	@echo "$(BLUE)--- Downloading icon from $(ICON_URL) ---"
	@echo "$(NC)"
	@# Use curl -L to follow redirects and -o to name the file specifically
	curl -L -o $(ICON_PNG) $(ICON_URL)
	@echo ""
	@echo "$(GREEN)--- DONE! ---$(NC)"
else
	@echo "$(YELLOW)--- Icon already exists locally. Skipping download. ---$(NC)"
endif

prep-claws-icon:
	@echo "$(BLUE)--- Converting PNG to required macOS .icns format ---$(NC)"
	@echo "$(YELLOW)--- Create the temporary iconset ---$(NC)"
	mkdir -p /tmp/claws.iconset
	@echo "$(YELLOW)--- Use standard macOS tools to create a temporary iconset and compile it ---$(NC)"
	@# Resize commands: Add >/dev/null 2>&1 to each line to silence the verbose output
	sips -z 16 16   $(ICON_PNG) --out /tmp/claws.iconset/icon_16x16.png > /dev/null 2>&1
	sips -z 32 32   $(ICON_PNG) --out /tmp/claws.iconset/icon_16x16@2x.png > /dev/null 2>&1
	@sips -z 32 32   $(ICON_PNG) --out /tmp/claws.iconset/icon_32x32.png > /dev/null 2>&1
	@sips -z 64 64   $(ICON_PNG) --out /tmp/claws.iconset/icon_32x32@2x.png > /dev/null 2>&1
	@sips -z 128 128 $(ICON_PNG) --out /tmp/claws.iconset/icon_128x128.png > /dev/null 2>&1
	@sips -z 256 256 $(ICON_PNG) --out /tmp/claws.iconset/icon_128x128@2x.png > /dev/null 2>&1
	@sips -z 256 256 $(ICON_PNG) --out /tmp/claws.iconset/icon_256x256.png > /dev/null 2>&1
	@sips -z 512 512 $(ICON_PNG) --out /tmp/claws.iconset/icon_256x256@2x.png > /dev/null 2>&1
	@sips -z 512 512 $(ICON_PNG) --out /tmp/claws.iconset/icon_512x512.png > /dev/null 2>&1
	@echo "..."
	sips -z 1024 1024 $(ICON_PNG) --out /tmp/claws.iconset/icon_512x512@2x.png > /dev/null 2>&1
	@echo "$(YELLOW)--- Compile the icns file ---$(NC)"
	iconutil -c icns /tmp/claws.iconset -o $(ICON_FILE)
	@echo "$(YELLOW)--- # Cleaning /tmp folder ---$(NC)"
	#rm -rf /tmp/claws.iconset

claws-mail: ## Setup Claws Mail on OSX: simlink homebrew forulae to ~/Applications (no cask for Claws Mail)
ifeq ($(IS_INSTALLED), $(PACKAGE_NAME))
	@echo "$(BLUE)--- Homebrew: $(PACKAGE_NAME) is already installed. ---$(NC)"
else
	@echo "$(BLUE)--- $(PACKAGE_NAME) not found. Installing... ---$(NC)"
	brew install $(PACKAGE_NAME)
endif
	@echo "$(YELLOW)--- Ensuring user Applications directory exists ---$(NC)"
	mkdir -p $(USER_APP_DIR)
	@echo "$(BLUE)--- Creating macOS App Wrapper in $(USER_APP_DIR) ---$(NC)"
	@# Remove any old installations (both symlink and bundle) first
	rm -rf $(APP_BUNDLE) $(APP_LINK_PATH)
	@# Create a tiny script bundle that runs the brew executable
	osacompile -o $(APP_BUNDLE) -e "do shell script \"$(shell which $(PACKAGE_NAME)) > /dev/null 2>&1 &\""
	@echo "$(GREEN)--- Done! ---$(NC)"
	@echo "Wrapper created at: $(APP_BUNDLE)"
	@echo "Spotlight will now index 'ClawsMail' as a real application."

# 	@echo "--- Creating user-level symlink ---"
# 	ln -sf $(shell which $(PACKAGE_NAME)) $(APP_LINK_PATH)
# 	@echo "--- Done! ---"
# 	@echo "Location: $(APP_LINK_PATH)"
# 	@echo "You can now find ClawsMail in your Applications folder or Spotlight."

claws-icon: # Set icon
ifeq ($(IS_INSTALLED), $(PACKAGE_NAME))
	@echo "$(BLUE)--- Homebrew: $(PACKAGE_NAME) is already installed. ---$(NC)"
else
	@echo "$(BLUE)--- $(PACKAGE_NAME) not found. Installing... ---$(NC)"
	brew install $(PACKAGE_NAME)
endif
	@echo "$(BLUE)--- Setting custom icon for $(APP_BUNDLE) ---$(NC)"
	fileicon set $(APP_BUNDLE) $(ICON_FILE)
	touch $(APP_BUNDLE)
	@echo "$(GREEN)--- Icon updated successfully. ---$(NC)"

claws-clean: ## Clean target: Removes the generated files in the Applications folder
	@echo "$(BLUE)--- Cleaning up ClawsMail links/wrappers from $(USER_APP_DIR) ---$(NC)"
	# Use 'rm -f' to forcefully remove both the .app bundle and the old symlink
	rm -rf $(APP_BUNDLE) $(APP_LINK_PATH) $(ICON_PNG) $(ICON_FILE) /tmp/claws.iconset
	@echo "$(GREEN)--- Cleanup complete. Note: Homebrew installation remains untouched. ---$(NC)"

duti: ## Setup default applications
	$(PKGINSTALL) duti; $(PROGINSTALL) skim;\
		defaults-xdg.sh

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

PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man
TMPDIR = $(PWD)/tmp
#DESTDIR = ?
PASSEMAIL = johnDoe@email.com

# ----------------------------------------------------------------------
# (COMMENTED NEW DOAS TARGET BLOCK) {{{1
#
# MKDIR := mkdir -p
# TMPDIR := /tmp/doas_build
# USER := $(shell whoami) # Ensure you have the current user
#
# doas: ## Install and configure doas
# 	@echo "Checking Xcode command line tools..."
# 	@xcode-select --install || echo "Xcode command line tools already installed or check initiated."
# 	@echo "Creating temporary build directory..."
# 	$(MKDIR) $(TMPDIR)
# 	@echo "Cloning and building doas..."
# 	@# Use '&&' to ensure commands only run if the previous one succeeds in the same shell instance
# 	git clone https://github.com/slicer69/doas.git $(TMPDIR)/doas_repo && \
# 		cd $(TMPDIR)/doas_repo && \
# 		gmake && \
# 		sudo gmake install
# 	@echo "Configuring PAM and doas.conf..."
# 	sudo cp /etc/pam.d/sudo /etc/pam.d/doas
# 	@# Fix for sudo echo redirection: pipe echo output to sudo tee
# 	echo "permit persist keepenv $(USER) as root" | sudo tee -a /usr/local/etc/doas.conf > /dev/null
# 	@echo "Cleaning up temporary directory..."
# 	rm -rf $(TMPDIR)
# 	@echo ""
# 	@echo "----------------------------------- SECURITY NOTE -----------------------------------"
# 	@echo "Please also note that macOS systems have been reported to have their /usr"
# 	@echo "and/or /usr/local directories set to be writable to regular user accounts"
# 	@echo "when homebrew is installed. If this is the case, fix this before installing"
# 	@echo "doas. Having these directories, like /usr/local/bin and /usr/local/etc,"
# 	@echo "writable to your user means anyone can remove and replace your doas.conf file"
# 	@echo "or the doas binary, allowing anyone or any program to run commands as root on"
# 	@echo "your system or harvest your password. This is a large security hole and"
# 	@echo "outside the scope of doas."
# 	@echo "-----------------------------------------------------------------------------------"
# 	@echo ""
#
# }}}
# ----------------------------------------------------------------------

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

walk: ## Installs plan9 find, SUDO NEEDED
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

# Use override: 'make sync MSG="hi"' sets MSG="hi".
# If MSG is not provided on the command line, it defaults to the value below.
MSG ?= Automated push via Makefile

# Define color variables for easier use
GREEN   := \033[0;32m
YELLOW  := \033[0;33m
RED     := \033[0;31m
NC      := \033[0m # No Color (resets terminal color)

syncdots: ## Push changes to git repo (use 'make sync MSG="..."' for custom message)
	@echo "$(YELLOW)--- Starting Git Synchronization ---$(NC)"
	@set -e; \
		echo "$(GREEN)Pulling remote changes...$(NC)"; \
		git pull origin master; \
		echo "$(GREEN)Staging all changes...$(NC)"; \
		git add .; \
		echo "$(GREEN)Committing changes with message: $(MSG)...$(NC)"; \
		git commit -m "$(MSG)" || true; \
		echo "$(GREEN)Pushing all committed changes...$(NC)"; \
		git push origin master
	@echo "$(YELLOW)--- Synchronization Complete ---$(NC)"

#syncdots: ## Push changes to git repo
#	git add .;\
#		git commit -m "Automated push via Makefile";\
#		git push -u origin master

#syncdots: ## Push changes to git repo
#	git pull;\
#		git add .;\
#		git commit -m "Push from Makefile";\
#		git push -u origin master

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
	@echo "Usage: make <command>"
	@echo ""
	@echo "Commands:"
	@#grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST)
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

# vim: set fdm=marker fmr={{{,}}}:
