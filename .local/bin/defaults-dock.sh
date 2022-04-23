#!/bin/sh

######################################################################
# @author      : hg (https://github.com/hghann)
# @file        : dock.sh
# @created     : Wed 29 Dec 00:15:38 2021
######################################################################

echo "Applying dock"

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Finder.app"
dockutil --no-restart --add "/Applications/KeePassXC.app"
dockutil --no-restart --add "/Applications/Launchpad.app"
dockutil --no-restart --add "/Applications/LibreWolf.app"
dockutil --no-restart --add "/Applications/Chromium.app"
dockutil --no-restart --add "/System/Applications/Mail.app"
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/System Preferences.app"
dockutil --no-restart --add "/Applications/Alacritty.app"

killall Dock

echo "Dock reloaded."
