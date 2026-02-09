#!/bin/bash
#
# author: Derek Taylor (DistroTube)
# 	https://distrotube.com/
# modified by hig9
# 	https://gitub.com/hig9
#
# Runs a random color script from my shell-color-scripts collection.
# Add "exec randomcolors.sh" to your bashrc or zshrc for more fun!
#
# modified: changed the scripts directory to ~/.local/bin

dirOptions=$(/bin/ls ~/.local/bin/shell-color-scripts | cut -d " " -f 1)
pickRandom=$(gshuf -e ${dirOptions[@]} -n 1)
exec ~/.local/bin/shell-color-scripts/${pickRandom}
