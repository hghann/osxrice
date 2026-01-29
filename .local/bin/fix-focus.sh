#!/bin/bash

######################################################################
# @author      : {{+~g:name+}} ({{+~g:web+}})
# @file        : {{+~expand('%:t')+}}
# @created     : {{+~strftime("%c")+}}
#
# @description : {{++}}
######################################################################

echo "🚀 Applying deep focus fixes for macOS 2026..."

# 1. Standard Mission Control fixes
# Disables auto-switching to spaces with open windows
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false
# Disables auto-rearranging spaces by recent use
defaults write com.apple.dock mru-spaces -bool false

# 2. Deeper "Anti-Swoosh" settings
# Forces macOS to stay on the current desktop during app activation
defaults write com.apple.dock workspaces-auto-swoosh -bool NO

# 3. Clear App-to-Space Sticky Assignments
# Prevents apps like Strongbox from 'pulling' you to their assigned desktop
defaults delete com.apple.spaces AppHandlers 2>/dev/null

## 4. Ghostty Focus Retention
## Prevents Ghostty from releasing focus to the 'next' app (Strongbox) when a window closes
#GHOSTTY_CONF="$HOME/.config/ghostty/config"
#if [ -f "$GHOSTTY_CONF" ]; then
#    echo "Updating Ghostty to retain focus..."
#    # Remove existing line if it exists to avoid duplicates
#    sed -i '' '/quit-after-last-window-closed/d' "$GHOSTTY_CONF"
#    echo "quit-after-last-window-closed = false" >> "$GHOSTTY_CONF"
#fi

# 5. Apply Changes
echo "🔄 Clearing preference cache and restarting Dock..."
killall cfprefsd
killall Dock

echo "✅ Done! Important: Log out and back in to fully apply focus stack changes."

# vim: set tw=78 ts=2 et sw=2 sr:

