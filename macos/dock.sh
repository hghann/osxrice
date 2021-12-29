#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Finder.app"
dockutil --no-restart --add "/Applications/KeePassXC.app"
dockutil --no-restart --add "/Applications/Launchpad.app"
dockutil --no-restart --add "/Applications/LibreWolf.app"
dockutil --no-restart --add "/Applications/Chromium.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/System/Applications/Mail.app"
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/Alacritty.app"
dockutil --no-restart --add "/Applications/MacVim.app"

killall Dock
