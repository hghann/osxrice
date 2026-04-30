#!/bin/zsh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : .zshrc
# @created     : Sun 10 July 11:41:43 2022
#
# @description : Runs on login. Various shell (zsh) options are set here.
######################################################################

# Put this at the VERY FIRST line
#zmodload zsh/zprof

# INITIALIZATION & PROMPT {{{

# Visuals first for instant feedback
#/usr/local/bin/randomcolors.sh # deploy randomcolors.sh (orig script)
/usr/local/bin/zshcolors.sh     # zshcolors.sh optimized for zsh shell

# Enable colors and change prompt:
autoload -U colors && colors    # Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Git prompt settings
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%r%f'
zstyle ':vcs_info:*' enable git

# Starship auto-sync {{{2
# Only regenerate the init file if the starship binary is newer than our static file
# This replaces the slow eval "$(starship init zsh)" call.
STARSHIP_BIN="/opt/homebrew/bin/starship"
STARSHIP_INIT="$HOME/.config/zsh/starship-init.zsh"

if [[ "$STARSHIP_BIN" -nt "$STARSHIP_INIT" ]]; then
  # --print-full-init is required for static sourcing to work correctly
  $STARSHIP_BIN init zsh --print-full-init > "$STARSHIP_INIT"
fi

# Source the static file if it exists
#[ -f "$STARSHIP_INIT" ] && source "$STARSHIP_INIT"
# 2}}} "Starship

# }}}

# COMPLETION SYSTEM {{{

# (REDUNDANT) {{{2
## Case insensitive tab completion
#autoload -Uz compinit && compinit
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#
## Basic auto/tab complete
#autoload -U compinit
#zstyle ':completion:*' menu select
#zmodload zsh/complist
#compinit
#_comp_options+=(globdots)       # Include hidden files.
# 2}}}

# Point to your specific config location
ZDF="${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"

autoload -Uz compinit
setopt extendedglob # Enable advanced globbing for the (#q) math to work

# Only regenerate .zcompdump if the file exists AND is older than 24h old
if [[ -n "$ZDF"(#qN.m-1) ]]; then
  # -C = Use cache, -u = Skip security checks if insecure folders exist
  compinit -C -d "$ZDF"
else
  compinit -d "$ZDF"
fi

# Settings
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # Case insensitive
_comp_options+=(globdots)                                    # Include hidden files

# }}}

# SHELL OPTIONS & HISTORY {{{
setopt autocd                   # Automatically cd into typed directory.
stty stop undef                 # Disable ctrl-s to freeze terminal.
setopt interactive_comments     # Allow comments in the interactive shell (e.g., $cmd # comment)

# Setting history file and some options
HISTSIZE=100000000              # How many lines of history to keep in memory
SAVEHIST=100000000              # Number of history entries to save to disk
setopt appendhistory            # Append history to the history file (no overwriting)
setopt sharehistory             # Share history across terminals
setopt INC_APPEND_HISTORY       # Immediately append commands to history file.
setopt HIST_IGNORE_ALL_DUPS     # Never add duplicate entries.
setopt HIST_IGNORE_SPACE        # Ignore commands that start with a space.
setopt HIST_REDUCE_BLANKS       # Remove unnecessary blank lines.

setopt HIST_VERIFY # Don't execute immediately; reload the expanded line for editing
# In zsh, history expansion commands (like ^old^new) are not stored as
# literally typed by default. Instead, the shell expands them into the full
# command and saves that to your history

# }}}

# VI-MODE & CURSOR LOGIC {{{

# Instant Mode Switching {{{2
# Reduce the delay (default 0.4s) to 0.01s for instant ESC response
export KEYTIMEOUT=1
# }}}2

# Modern Backspace Behavior {{{2
# Allow backspace to delete past the start of insert mode (Vim-style)
bindkey -v
bindkey '^?' backward-delete-char  # Standard Backspace
bindkey '^H' backward-delete-char  # ctrl+H (Alternate Backspace)
# }}}2

# Cursor Shape Management {{{2

# Change cursor shape for different vi modes.
# 1 = blinking block, 2 = steady block, 5 = blinking bar, 6 = steady bar
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[5 q';;      # block
        viins|main) echo -ne '\e[1 q';; # beam
    esac
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[1 q"
}
zle -N zle-line-init

echo -ne '\e[1 q'                # Use beam shape cursor on startup.
preexec() { echo -ne '\e[1 q' ;} # Use beam shape cursor for each new prompt.
# }}}2

# }}}

# CUSTOM FUNCTIONS {{{

# lfcd: LF Directory Switcher (ctrl+O) {{{2
# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
# 2}}} "lfcd
# fdr: Directory Jumper (ctrl+G) {{{2
fdrl() {
  local dir
  # fd -u (unrestricted) + follow symlinks + depth 2 for instant load
  local cmd="fd -u --type d --follow --max-depth 2 --exclude .git"
  [[ ! -x "$(command -v fd)" ]] && cmd="command find -L . -maxdepth 2 -type d 2>/dev/null"

  dir=$(eval "$cmd" | fzf --multi --height 80% --reverse --border=double \
    --header-label=" 📂 SPEED NAV " --prompt="λ " \
    --header="[TAB] Multi | [ENT] CD | [?] Toggle Preview" \
    --color="bg+:#30343c,bg:#282c34,fg:#bbc2cf,header:#51afef,info:#98be65,pointer:#c678dd,marker:#98be65,prompt:#a9a1e1,hl:#ecbe7b,hl+:#ecbe7b,border:#464b5d,label:#da8548" \
    --preview 'eza -aT -L 1 --color=always --icons {} 2>/dev/null' \
    --bind "?:toggle-preview" --preview-window="right,50%,hidden,wrap")

  if [[ -z "$dir" ]]; then [[ -o zle ]] && zle redisplay; return 0; fi
  cd "$(echo "$dir" | head -n 1)"
  [[ -o zle ]] && zle reset-prompt
}

fdr() {
  local dir
  # Base command for a full recursive search
  local base_cmd="fd -u --type d --follow --exclude .git"
  # Initial command restricted to depth 2 for instant popup
  local init_cmd="$base_cmd --max-depth 2"

  dir=$(eval "$init_cmd" | fzf --multi --height 80% --reverse --border=double \
    --header-label=" 📂 SPEED NAV " --prompt="λ " \
    --header="[Alt-D] Deep Scan | [TAB] Multi | [ENT] CD | [?] Preview" \
    --color="bg+:#30343c,bg:#282c34,fg:#bbc2cf,header:#51afef,info:#98be65,pointer:#c678dd,marker:#98be65,prompt:#a9a1e1,hl:#ecbe7b,hl+:#ecbe7b,border:#464b5d,label:#da8548" \
    --preview 'eza -aT -L 1 --color=always --icons {} 2>/dev/null' \
    --bind "alt-d:reload($base_cmd)+change-prompt(🌊 DEEP SEARCH > )" \
    --bind "?:toggle-preview" --preview-window="right,50%,hidden,wrap")

  if [[ -z "$dir" ]]; then [[ -o zle ]] && zle redisplay; return 0; fi
  cd "$(echo "$dir" | head -n 1)"
  [[ -o zle ]] && zle reset-prompt
}
# }}}2 "fdr
# ff: File Hunter (ctrl+P) {{{2
ff() {
  local file
  local base_cmd="fd -u --type f --follow --exclude .git"
  local init_cmd="$base_cmd --max-depth 2"

  file=$(eval "$init_cmd" | fzf --multi --height 85% --reverse --border=double \
    --header-label=" 🔍 SPEED RADAR " --prompt="λ " \
    --header="[Alt-D] Deep Scan | [TAB] Multi | [?] Toggle Preview" \
    --color="bg+:#30343c,bg:#282c34,fg:#bbc2cf,header:#c678dd,info:#51afef,pointer:#da8548,marker:#98be65,prompt:#a9a1e1,hl:#ecbe7b,hl+:#ecbe7b,border:#464b5d,label:#da8548" \
    --preview 'bat --color=always --style=numbers --line-range :30 {} 2>/dev/null' \
    --bind "alt-d:reload($base_cmd)+change-prompt(🌊 DEEP SCAN > )" \
    --bind "?:toggle-preview" --preview-window="right,60%,hidden,wrap")

  if [[ -z "$file" ]]; then [[ -o zle ]] && zle redisplay; return 0; fi

  # macOS-safe multi-open (opens all selected in Vim buffers)
  echo "$file" | xargs -o vim
  [[ -o zle ]] && zle reset-prompt
}
# }}}2 "ff
# fk: Fuzzy process killer (ctrl+K) {{{2
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        # Standard user processes
        pid=$(ps -u $UID -o pid,ppid,comm | sed 1d | fzf -m --ansi --header="[TAB] Multi-select | [ENTER] Kill" | awk '{print $1}')
    else
        # All processes if run with sudo
        pid=$(ps -ax -o pid,ppid,comm | sed 1d | fzf -m --ansi --header="[TAB] Multi-select | [ENTER] Kill" | awk '{print $1}')
    fi

    if [ -n "$pid" ]; then
        echo "$pid" | xargs kill -9
        echo "Killed process(es): $(echo $pid | tr '\n' ' ')"
    fi
}

fko() {
  local pid
  # Get processes: PID, CPU%, MEM%, COMMAND
  # Use 'ps -u $USER' to only show your own processes by default
  pid=$(ps -u "$USER" -o pid,pcpu,pmem,comm | sed 1d | fzf -m \
    --height 40% --reverse --header-label=" 💀 KILL RADAR " \
    --header="[TAB] Multi-select | [ENT] Kill -9" \
    --preview 'ps -p {1} -o pid,ppid,user,%cpu,%mem,start,time,command | numfmt --header --to=iec --field=4,5' \
    --preview-window="top,4,wrap" \
    --color="bg+:#30343c,bg:#282c34,fg:#bbc2cf,header:#ff6c6b,info:#98be65,pointer:#c678dd,marker:#98be65,prompt:#a9a1e1,hl:#ecbe7b,hl+:#ecbe7b,border:#464b5d,label:#ff6c6b" \
    | awk '{print $1}')

  if [[ -n "$pid" ]]; then
    # Kill all selected PIDs
    echo "$pid" | xargs kill -9
    echo "Successfully terminated PIDs: ${(j:, :)pid}"
    [[ -o zle ]] && zle reset-prompt
  fi
}

fkpp() {
  local pid
  # 1. Define the two commands
  local user_cmd="ps -u $USER -o pid,ppid,pcpu,pmem,comm"
  local deep_cmd="ps -ax -o pid,ppid,pcpu,pmem,comm"

  # 2. Setup Doom One Header
  local header=$(print -P "%F{magenta}[Alt-D] Deep Scan | [TAB] Multi | [ENT] Kill -9%f")

  # 3. Execution with dynamic reload
  pid=$(eval "$user_cmd" | sed 1d | fzf -m \
    --ansi \
    --height 45% --reverse --border=double \
    --header-label=" 💀 KILL RADAR " \
    --header="$header" \
    --color="bg+:#30343c,bg:#282c34,fg:#bbc2cf,header:#ff6c6b,info:#98be65,pointer:#c678dd,marker:#98be65,prompt:#a9a1e1,hl:#ecbe7b,hl+:#ecbe7b,border:#464b5d,label:#ff6c6b" \
    --preview 'ps -p {1} -o pid,ppid,user,%cpu,%mem,start,time,command' \
    --preview-window="top,4,wrap" \
    --bind "alt-d:reload($deep_cmd | sed 1d)+change-prompt(🌊 DEEP SCAN > )" \
    | awk '{print $1}')

  if [[ -n "$pid" ]]; then
    # Try standard kill; if it fails (permission), suggest sudo
    echo "$pid" | xargs kill -9 2>/dev/null || {
      print -P "%F{red}Permission denied. Some processes require sudo.%f"
    }
    [[ -o zle ]] && zle reset-prompt
  fi
}

fk() {
  local pid

  # Only show the magenta instruction row
  local header=$(print -P "%F{magenta}[TAB] Multi-select | [ENT] Kill -9%f")

  # Get processes and pipe to fzf
  # Use 'ps -u $USER' to only show your own processes by default
  pid=$(ps -u "$USER" -o pid,ppid,pcpu,pmem,comm | sed 1d | fzf -m \
    --ansi \
    --height 45% --reverse --border=double \
    --header-label=" 💀 KILL RADAR " \
    --header="$header" \
    --color="bg+:#30343c,bg:#282c34,fg:#bbc2cf,header:#ff6c6b,info:#98be65,pointer:#c678dd,marker:#98be65,prompt:#a9a1e1,hl:#ecbe7b,hl+:#ecbe7b,border:#464b5d,label:#ff6c6b" \
    --preview 'ps -p {1} -o pid,ppid,user,%cpu,%mem,start,time,command' \
    --preview-window="top,4,wrap" \
    | awk '{print $1}')

  if [[ -n "$pid" ]]; then
    # Kill all selected PIDs
    echo "$pid" | xargs kill -9
    echo "Terminated: ${(j:, :)pid}"
    [[ -o zle ]] && zle reset-prompt
  fi
}
# Register widget and bind to Ctrl+K
zle -N fk_widget fk
bindkey '^K' fk_widget

# }}}2

# Widget Registration
zle -N fdr_widget fdr
zle -N ff_widget ff
autoload edit-command-line; zle -N edit-command-line # Edit line in vim with ctrl-e

# }}}

## CUSTOM FUNCTIONS (Lazy Loaded) {{{
#fpath=( ~/.config/zsh/functions $fpath )
#
## Autoload all files in that directory
## This tells Zsh these functions exist without reading their code yet
#autoload -Uz ~/.config/zsh/functions/*(:t)
#
## Register the widgets (Zsh needs to know they are ZLE widgets)
#zle -N fdr_widget fdr
#zle -N ff_widget ff
#zle -N fk_widget fk
#autoload -Uz edit-command-line; zle -N edit-command-line
## }}}

# KEYBINDINGS {{{
# --- Command Shortcuts (String injection) ---
bindkey -s '^o' 'lfcd\n'        # Ctrl+O: Open LF directory switcher
bindkey -s '^a' 'bc -lq\n'      # Ctrl+A: Open calculator (Quick math)
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n' # Ctrl+F: Jump to directory of chosen file
# --- Editor & Terminal Behavior ---
bindkey '^[[P' delete-char      # Fix Delete key behavior
bindkey '^e' edit-command-line  # Ctrl+E: Open current buffer in Vim
bindkey '^ ' autosuggest-accept # Ctrl+Space: Accept zsh-autosuggestion
# --- Custom FZF Widgets (Function triggers) ---
bindkey '^G' fdr_widget         # Ctrl+G: Search/Jump to directory
bindkey '^P' ff_widget          # Ctrl+P: Search/Open file in Vim
# }}}

# EXTERNAL SOURCES & PLUGINS {{{

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"
[ -f "$HOME/.config/zsh/functionrc" ] && source "$HOME/.config/zsh/functionrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/functionrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

## fzf auto-sync {{{2
# only regenerate the init file if the fzf binary is newer than our static file
# this handles Homebrew updates automatically with zero overhead.
FZF_BIN="/opt/homebrew/bin/fzf"
FZF_INIT="$HOME/.config/zsh/fzf-init.zsh"

if [[ "$FZF_BIN" -nt "$FZF_INIT" ]]; then
  $FZF_BIN --zsh > "$FZF_INIT"
fi

# Enable native fzf key bindings (includes CTRL-R for history).
[ -f "$FZF_INIT" ] && source "$FZF_INIT" # source the static file if it exists

#[ -f "$HOME/.config/zsh/fzf-init.zsh" ] && source "$HOME/.config/zsh/fzf-init.zsh"
# N.B.: run 'fzf --zsh > ~/.config/zsh/fzf-init.zsh' upon update the fzf package
#       no longer needed, handled by auto-sync
#
# 2}}} "fzf auto-sync
## Plugins {{{2
# Define plugin paths for cleaner code
ZSH_AS="/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_SH="/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Source only if files exist
[ -f "$ZSH_AS" ] && source "$ZSH_AS"
[ -f "$ZSH_SH" ] && source "$ZSH_SH" # Must be last!
# 2}}} "Plugins

## PLUGINS (Delayed Load) {{{
#_lazy_load_plugins() {
#    # Source only if files exist
#    [[ -f "$ZSH_AS" ]] && source "$ZSH_AS"
#    [[ -f "$ZSH_SH" ]] && source "$ZSH_SH"
#
#    # Clean up: remove this function so it doesn't run again
#    add-zsh-hook -d precmd _lazy_load_plugins
#}
#
#autoload -Uz add-zsh-hook
#add-zsh-hook precmd _lazy_load_plugins
## }}}

# 1}}}

# Put this at the VERY LAST line
#zprof

# vim: foldmethod=marker foldlevel=0

